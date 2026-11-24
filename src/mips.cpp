// ===========================================================================
// MIPS32 backend for the FNS compiler.
//
// Consumes the in-memory IR `Module` produced by the code generator and emits
// little-endian MIPS32 assembly that runs on the spim simulator.
//
// Calling convention (shared with src/runtime.s):
//   * arguments are pushed on the stack, arg0 at the lowest address; a scalar
//     occupies one word, a double two words (low word first);
//   * the caller pops the arguments after the call;
//   * integer / pointer results come back in $v0, doubles in $f0;
//   * every local, parameter and temporary lives in the function's frame
//     (there is no register allocation at this level); $fp addresses the frame.
//
// Frame layout (offsets are relative to $fp, which equals the caller's $sp on
// entry = the address of incoming arg0):
//      0($fp), 4($fp), ...   incoming arguments
//     -4($fp)                saved return address
//     -8($fp)                saved caller frame pointer
//     below that             locals, parameters, temporaries
// ===========================================================================

#include "mips.hpp"

#include <algorithm>
#include <cstdint>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

namespace fns {
namespace {

// The hand-written runtime library, embedded as a string at build time.
static const char *RUNTIME =
#include "runtime_asm.inc"
;

// The C runtime library compiled to MIPS by `fnsc --runtime` (empty while
// bootstrapping the compiler that builds it).
#ifdef FNS_BOOTSTRAP
static const char *LIBFNS = "";
#else
static const char *LIBFNS =
#include "libfns_asm.inc"
;
#endif

// ---------------------------------------------------------------------------
// Small string helpers.
// ---------------------------------------------------------------------------
std::vector<std::string> split_ws(const std::string &s) {
    std::vector<std::string> v;
    std::istringstream is(s);
    std::string t;
    while (is >> t) v.push_back(t);
    return v;
}

std::string strip_commas(std::string s) {
    s.erase(std::remove(s.begin(), s.end(), ','), s.end());
    return s;
}

std::string trim(const std::string &s) {
    size_t a = s.find_first_not_of(" \t");
    if (a == std::string::npos) return "";
    size_t b = s.find_last_not_of(" \t");
    return s.substr(a, b - a + 1);
}

bool is_int_literal(const std::string &s) {
    if (s.empty()) return false;
    size_t i = (s[0] == '-' || s[0] == '+') ? 1 : 0;
    if (i == s.size()) return false;
    for (; i < s.size(); ++i)
        if (!isdigit((unsigned char)s[i])) return false;
    return true;
}

// A floating literal as the IR prints it: "1.5", ".5", "1e5", "2.5f", "1.0E-3".
bool is_float_literal(const std::string &s) {
    if (s.empty()) return false;
    std::string t = s;
    if (t.back() == 'f' || t.back() == 'F' || t.back() == 'l' || t.back() == 'L') t.pop_back();
    bool dot = false, digit = false, exp = false;
    size_t i = (t[0] == '-' || t[0] == '+') ? 1 : 0;
    for (; i < t.size(); ++i) {
        char c = t[i];
        if (isdigit((unsigned char)c)) digit = true;
        else if (c == '.' && !exp) dot = true;
        else if ((c == 'e' || c == 'E') && digit && !exp) {
            exp = true;
            if (i + 1 < t.size() && (t[i + 1] == '+' || t[i + 1] == '-')) ++i;
        } else return false;
    }
    return digit && (dot || exp);
}

// Spell a numeric literal the way spim's li.s / li.d accept it ("1.0e5", "0.5", "3.0").
std::string fp_spelling(const std::string &lit) {
    std::string t = lit;
    if (!t.empty() && (t.back() == 'f' || t.back() == 'F' || t.back() == 'l' || t.back() == 'L')) t.pop_back();
    double v = strtod(t.c_str(), nullptr);
    char buf[64];
    snprintf(buf, sizeof buf, "%.17g", v);
    std::string r = buf;
    if (r.find("inf") != std::string::npos || r.find("nan") != std::string::npos) return "0.0";
    size_t e = r.find_first_of("eE");
    std::string mant = e == std::string::npos ? r : r.substr(0, e);
    std::string ex = e == std::string::npos ? "" : r.substr(e);
    if (mant.find('.') == std::string::npos) mant += ".0";
    return mant + ex;
}

bool is_temp(const std::string &s) {
    if (s.size() < 2 || s[0] != 't') return false;
    for (size_t i = 1; i < s.size(); ++i)
        if (!isdigit((unsigned char)s[i])) return false;
    return true;
}

bool is_string_label(const std::string &s) {
    if (s.rfind("str", 0) != 0 || s.size() == 3) return false;
    for (size_t i = 3; i < s.size(); ++i)
        if (!isdigit((unsigned char)s[i])) return false;
    return true;
}

// The IR spells types as "int", "unsigned char", "struct Point", "Shape*",
// "double[3]", "fn*", "Vec&".  Classification is done on the first word
// (after sign/const qualifiers), never by substring, so a class called
// `Point` or `Character` is not mistaken for `int` or `char`.
std::string base_word(const std::string &type) {
    std::istringstream is(type);
    std::string w;
    while (is >> w) {
        if (w == "unsigned" || w == "signed" || w == "const" || w == "static") continue;
        size_t cut = w.find_first_of("[*&(");
        if (cut != std::string::npos) w = w.substr(0, cut);
        return w;
    }
    return "int";
}

bool has_indirection(const std::string &type) {
    return type.find('*') != std::string::npos || type.find('&') != std::string::npos;
}

bool is_builtin_word(const std::string &w) {
    static const std::set<std::string> b = {"void", "bool", "char", "short", "int", "long",
                                            "float", "double", "auto", "fn", "lambda", "enum",
                                            "ptr"};
    return b.count(w) > 0;
}

// Is `type` a scalar held in a single 4- or 8-byte slot (as opposed to an
// array/struct buffer addressed only through its address)?
bool is_scalar_type(const std::string &type) {
    if (!type.empty() && type.back() == '*') return true;    // pointer (also to an array: int[4]*)
    if (type.find('[') != std::string::npos) return false;   // array
    if (has_indirection(type)) return true;                   // pointer / reference
    return is_builtin_word(base_word(type));
}

bool type_is_unsigned(const std::string &type) {
    return type.find("unsigned") != std::string::npos || has_indirection(type) ||
           base_word(type) == "fn";
}

bool type_is_double(const std::string &type) {
    return !has_indirection(type) && type.find('[') == std::string::npos &&
           base_word(type) == "double";
}

// Byte width used for a load/store through a pointer, from the IR note type.
int width_of_type(const std::string &type) {
    if (has_indirection(type)) return 4;
    std::string w = base_word(type);
    if (w == "double") return 8;
    if (w == "char" || w == "bool") return 1;
    if (w == "short") return 2;
    return 4;
}

struct Slot { int offset; int size; };

// ---------------------------------------------------------------------------
// Backend state.
// ---------------------------------------------------------------------------
struct Backend {
    const Module &mod;
    std::ostream &out;
    std::vector<std::string> &unsupported;

    std::set<std::string> globals;         // global variable names
    std::map<std::string, int> global_size;
    std::map<std::string, std::string> global_type;
    std::set<std::string> funcnames;       // defined function + lambda names
    std::set<std::string> externs;         // external (runtime) names
    std::set<std::string> vtables;         // vtable labels
    std::set<std::string> lib_refs;        // runtime-library symbols used by the program
    // Uninitialised global arrays/objects larger than this live on the heap:
    // spim's static data area ends at 0x10040000 (about 192 KB of .data).
    static const int HEAP_GLOBAL_MIN = 32768;
    std::map<std::string, int> heap_globals;  // name -> size; .data holds a pointer

    // per-function state
    std::unordered_map<std::string, Slot> slots;
    std::unordered_map<std::string, std::string> type_of;   // name -> type
    int frame_size = 0;
    int va_off = 0;                        // $fp offset of the first variadic argument
    // Register forwarding: a temporary used only by the next IR instruction stays
    // in $t2 instead of going through its stack slot.
    std::string pend_candidate;            // temp the current instruction may keep in $t2
    std::string pending;                   // temp whose value is live in $t2 right now
    bool at_last_instr = false;            // translating the function's final IR instruction
    int func_idx = 0;
    int uid = 0;                           // unique label counter
    std::vector<std::string> pending_params;

    // Runtime mode compiles the C runtime library (src/lib/libfns.c): its
    // symbols are prefixed R_, its local labels .R, its strings Rstr, so it can
    // be appended to any user program without clashing with U_ user symbols.
    bool rt = false;
    std::string lp = ".L";                 // local label prefix

    Backend(const Module &m, std::ostream &o, std::vector<std::string> &u, bool runtime_mode)
        : mod(m), out(o), unsupported(u), rt(runtime_mode), lp(runtime_mode ? ".R" : ".L") {}

    std::string str_label(size_t i) const { return (rt ? "Rstr" : "str") + std::to_string(i); }

    void note_unsupported(const std::string &s) {
        unsupported.push_back(s);
        out << "    # UNSUPPORTED: " << s << "\n";
    }

    std::string asm_label(const std::string &name) {
        return lp + std::to_string(func_idx) + "_" + name;
    }

    // Map an IR symbol (function / global / vtable) to a safe assembly symbol.
    // User names are prefixed with "U_" so a function called `add`, `sub`,
    // `move`, etc. cannot collide with a MIPS instruction mnemonic and confuse
    // the spim assembler.  `main` keeps its name (spim's startup calls it) and
    // runtime/extern names are left untouched.
    std::string sym(const std::string &n) {
        if (n == "main" && !rt) return "main";
        if (funcnames.count(n) || globals.count(n) || vtables.count(n))
            return (rt ? "R_" : "U_") + n;
        if (!rt && externs.count(n) && n != "__pure_virtual") {                // library function
            lib_refs.insert("R_" + n);
            return "R_" + n;
        }
        return n;                                                               // asm stub
    }

    void run();
    void collect_symbols();
    void emit_data();
    void emit_function(const Function *f);

    // $fp-relative load/store and address; offsets outside the 16-bit immediate
    // range (frames with large local arrays) go through $t3.
    void fp_access(const std::string &op, const std::string &reg, int off) {
        if (off >= -32768 && off <= 32767) {
            out << "    " << op << " " << reg << ", " << off << "($fp)\n";
            return;
        }
        out << "    li $t3, " << off << "\n    addu $t3, $fp, $t3\n";
        out << "    " << op << " " << reg << ", 0($t3)\n";
    }
    void fp_address(const std::string &reg, int off) {
        if (off >= -32768 && off <= 32767) out << "    addiu " << reg << ", $fp, " << off << "\n";
        else out << "    li " << reg << ", " << off << "\n    addu " << reg << ", $fp, " << reg << "\n";
    }
    void emit_library();
    void build_frame(const Function *f);

    // operand helpers (emit code that leaves a value / address in `reg`)
    void load_operand(const std::string &tok, const std::string &reg);
    void addr_of(const std::string &name, const std::string &reg);
    void store_result(const std::string &reg, const std::string &dest);

    bool operand_unsigned(const std::string &tok);
    std::map<std::string, int> count_temp_uses(const Function *f);
    std::string forwardable_temp(const Function *f, size_t i, const std::map<std::string, int> &uses);
    bool arg_is_double(const std::string &tok) {
        std::string t = strip_commas(tok);
        if (is_float_literal(t)) return operand_fp_kind(t) == 2;
        return type_is_double(operand_type(t));
    }
    std::string operand_type(const std::string &tok);

    // floating point helpers
    int fp_kind(const std::string &type);        // 2=double, 1=float, 0=int
    int operand_fp_kind(const std::string &tok);
    void load_fp(const std::string &tok, const std::string &freg, int kind);
    void store_fp(const std::string &freg, const std::string &dst, int kind);
    void emit_fp_binop(const std::string &dst, const std::string &a,
                       const std::string &op, const std::string &b, int kind);
    void emit_fp_cast(const std::string &dst, const std::string &ty,
                      const std::string &val);

    void translate(const Instr &ins);
    void emit_binop(const std::string &dst, const std::string &a,
                    const std::string &op, const std::string &b,
                    const std::string &note);
    void emit_call(const std::string &callee, int /*n*/, const std::string &dest,
                   const std::string &note);
    void emit_copy(const std::vector<std::string> &toks);
};

// ---------------------------------------------------------------------------
// Parse the declaration tables and build the global symbol sets.
// ---------------------------------------------------------------------------
void Backend::collect_symbols() {
    for (const auto &g : mod.globals) {
        // "name : type (size) [= init]"
        size_t colon = g.find(" : ");
        if (colon == std::string::npos) continue;
        std::string name = trim(g.substr(0, colon));
        std::string rest = g.substr(colon + 3);
        size_t lp = rest.find('(');
        std::string type = trim(rest.substr(0, lp));
        int size = 4;
        if (lp != std::string::npos) {
            size_t rp = rest.find(')', lp);
            size = std::stoi(rest.substr(lp + 1, rp - lp - 1));
        }
        globals.insert(name);
        global_size[name] = size;
        global_type[name] = type;
        if (size > HEAP_GLOBAL_MIN && !is_scalar_type(type) && g.find('=', rest.find(')')) == std::string::npos &&
            rest.find('=') == std::string::npos)
            heap_globals[name] = size;
    }
    for (const auto &v : mod.vtables) {
        size_t colon = v.find(':');
        if (colon != std::string::npos) vtables.insert(trim(v.substr(0, colon)));
    }
    for (const Function *f : mod.funcs) funcnames.insert(f->name);
    for (const auto &e : mod.externs) externs.insert(e);
}

void Backend::run() {
    collect_symbols();
    if (rt) {
        out << "# FNS runtime library (compiled from " << mod.source << " by fnsc --runtime)\n";
    } else {
        out << "# FNS -> MIPS32 (spim).  Generated assembly.\n";
        out << "# source: " << mod.source << "\n";
        out << "# run with:  spim -file <this file> [program arguments]\n";
    }
    emit_data();
    out << "\n.text\n";
    if (!rt) out << ".globl main\n";
    func_idx = 0;
    for (const Function *f : mod.funcs) {
        emit_function(f);
        ++func_idx;
    }
    if (rt) return;
    out << "\n# ==== FNS runtime: syscall stubs (src/runtime.s) ====\n";
    out << RUNTIME << "\n";
    out << "\n# ==== FNS runtime: C library (src/lib/libfns.c), functions used by this program ====\n";
    emit_library();
}

// Append the runtime library, keeping only the functions reachable from the
// program (spim's default text segment is 64 KB, so the whole library would
// not leave room for larger programs).  Library functions are delimited by
// "# @fn NAME" / "# @endfn" markers written in runtime mode.
// Comment: >30 lines because it splits the library into functions, computes
// the call/reference closure and re-emits the kept parts in their original order.
void Backend::emit_library() {
    struct Chunk { std::string name; std::vector<std::string> lines; std::set<std::string> refs; };
    std::vector<Chunk> chunks;            // name empty = always kept (data, directives)
    std::istringstream is(LIBFNS);
    std::string line;
    Chunk cur;
    bool in_fn = false;
    while (std::getline(is, line)) {
        if (line.rfind("# @fn ", 0) == 0) {
            if (!cur.lines.empty()) chunks.push_back(cur);
            cur = Chunk();
            cur.name = line.substr(6);
            in_fn = true;
            continue;
        }
        if (line == "# @endfn") {
            chunks.push_back(cur);
            cur = Chunk();
            in_fn = false;
            continue;
        }
        if (in_fn) {
            size_t p = 0;
            while ((p = line.find("R_", p)) != std::string::npos) {
                size_t e = p + 2;
                while (e < line.size() && (isalnum((unsigned char)line[e]) || line[e] == '_')) ++e;
                if (p == 0 || !(isalnum((unsigned char)line[p - 1]) || line[p - 1] == '_'))
                    cur.refs.insert(line.substr(p, e - p));
                p = e;
            }
        }
        cur.lines.push_back(line);
    }
    if (!cur.lines.empty()) chunks.push_back(cur);

    std::map<std::string, const Chunk *> by_name;
    for (const Chunk &c : chunks) if (!c.name.empty()) by_name[c.name] = &c;
    std::set<std::string> keep;
    std::vector<std::string> work(lib_refs.begin(), lib_refs.end());
    while (!work.empty()) {
        std::string n = work.back();
        work.pop_back();
        if (!by_name.count(n) || keep.count(n)) continue;
        keep.insert(n);
        for (const std::string &r : by_name[n]->refs) work.push_back(r);
    }
    for (const Chunk &c : chunks) {
        if (!c.name.empty() && !keep.count(c.name)) continue;
        for (const std::string &l : c.lines) out << l << "\n";
    }
}

// ---------------------------------------------------------------------------
// Decode the escapes of a C string literal (quotes included in `lit`).
// ---------------------------------------------------------------------------
std::string decode_c_string(const std::string &lit) {
    std::string r;
    size_t i = 1, n = lit.size() >= 2 ? lit.size() - 1 : lit.size();
    while (i < n) {
        char c = lit[i++];
        if (c != '\\' || i >= n) { r += c; continue; }
        char e = lit[i++];
        switch (e) {
            case 'n': r += '\n'; break;
            case 't': r += '\t'; break;
            case 'r': r += '\r'; break;
            case 'a': r += '\a'; break;
            case 'b': r += '\b'; break;
            case 'f': r += '\f'; break;
            case 'v': r += '\v'; break;
            case 'x': {
                int v = 0, k = 0;
                while (i < n && k < 2 && isxdigit((unsigned char)lit[i])) {
                    char h = lit[i++];
                    v = v * 16 + (isdigit((unsigned char)h) ? h - '0' : (tolower(h) - 'a' + 10));
                    ++k;
                }
                r += (char)v;
                break;
            }
            default:
                if (e >= '0' && e <= '7') {
                    int v = e - '0', k = 1;
                    while (i < n && k < 3 && lit[i] >= '0' && lit[i] <= '7') { v = v * 8 + (lit[i++] - '0'); ++k; }
                    r += (char)v;
                } else {
                    r += e;       // \\ \' \" \? and unknown escapes
                }
        }
    }
    return r;
}

// Emit a decoded string as .asciiz when spim can read it back verbatim,
// otherwise as a .byte list (always NUL-terminated).
void emit_string_data(std::ostream &out, const std::string &label, const std::string &lit) {
    std::string d = decode_c_string(lit);
    bool plain = true;
    for (char c : d)
        if (!(c == '\n' || c == '\t' || (c >= 32 && c < 127)) || c == '\\' || c == '"') plain = false;
    if (plain) {
        std::string esc;
        for (char c : d) {
            if (c == '\n') esc += "\\n";
            else if (c == '\t') esc += "\\t";
            else esc += c;
        }
        out << label << ": .asciiz \"" << esc << "\"\n";
        return;
    }
    out << label << ": .byte ";
    for (char c : d) out << (int)(unsigned char)c << ", ";
    out << "0    # " << lit << "\n";
}

// Split "{a, b, c}" into its items.
std::vector<std::string> split_init_list(const std::string &init) {
    std::vector<std::string> vals;
    size_t close = init.rfind('}');
    std::string inner = init.substr(1, close == std::string::npos ? std::string::npos : close - 1);
    std::stringstream ss(inner);
    std::string item;
    while (std::getline(ss, item, ',')) {
        item = trim(item);
        if (!item.empty()) vals.push_back(item);
    }
    return vals;
}

// The directive and byte width used to store one element of `type` in .data.
void data_directive(const std::string &type, std::string &dir, int &width) {
    if (has_indirection(type)) { dir = ".word"; width = 4; return; }
    std::string w = base_word(type);
    if (w == "double") { dir = ".double"; width = 8; }
    else if (w == "float") { dir = ".float"; width = 4; }
    else if (w == "char" || w == "bool") { dir = ".byte"; width = 1; }
    else if (w == "short") { dir = ".half"; width = 2; }
    else { dir = ".word"; width = 4; }
}

// One value for a .data directive.
std::string data_value(const std::string &v, const std::string &dir) {
    if (dir == ".double" || dir == ".float") {
        if (is_float_literal(v) || is_int_literal(v)) return fp_spelling(v);
        return "0.0";
    }
    if (is_int_literal(v)) return std::to_string((int32_t)(int64_t)std::stoll(v));
    if (is_float_literal(v)) return std::to_string((int32_t)strtod(v.c_str(), nullptr));
    return "0";
}

// ---------------------------------------------------------------------------
// Emit the .data section: strings, globals, vtables.
// Comment: >30 lines because every global is laid out from its IR type:
// scalars and arrays of every width, string pointers, and zero-filled space.
// ---------------------------------------------------------------------------
void Backend::emit_data() {
    out << "\n.data\n";
    for (size_t i = 0; i < mod.strings.size(); ++i)
        emit_string_data(out, str_label(i), mod.strings[i]);

    for (const auto &g : mod.globals) {
        size_t colon = g.find(" : ");
        if (colon == std::string::npos) continue;
        std::string name = trim(g.substr(0, colon));
        std::string rest = g.substr(colon + 3);
        size_t lp = rest.find('(');
        size_t rp = rest.find(')', lp);
        std::string type = trim(rest.substr(0, lp));
        int size = std::stoi(rest.substr(lp + 1, rp - lp - 1));
        std::string init;
        size_t eq = rest.find('=', rp);
        if (eq != std::string::npos) init = trim(rest.substr(eq + 1));

        std::string elem = type.substr(0, type.find('['));
        std::string dir;
        int width = 4;
        data_directive(elem, dir, width);
        out << (dir == ".double" ? ".align 3\n" : ".align 2\n") << sym(name) << ":";
        if (init.empty() && size > HEAP_GLOBAL_MIN && !is_scalar_type(type)) {
            out << " .word 0    # " << size << " bytes allocated on the heap at start-up\n";
        } else if (init.empty()) {
            out << " .space " << (size > 0 ? size : 4) << "\n";
        } else if (init[0] == '{') {
            std::vector<std::string> vals = split_init_list(init);
            out << " " << dir << " ";
            for (size_t i = 0; i < vals.size(); ++i)
                out << (i ? ", " : "") << data_value(vals[i], dir);
            out << "\n";
            int rest_bytes = size - (int)vals.size() * width;
            if (rest_bytes > 0) out << "    .space " << rest_bytes << "\n";
        } else if (is_string_label(init)) {
            out << " .word " << str_label(std::stoi(init.substr(3))) << "\n";
        } else if (dir == ".double" || dir == ".float") {
            out << " " << dir << " " << data_value(init, dir) << "\n";
        } else {
            // every scalar gets a full word so word-sized loads stay in bounds
            out << " .word " << data_value(init, ".word") << "\n";
            if (size > 4) out << "    .space " << size - 4 << "\n";
        }
    }

    for (const auto &v : mod.vtables) {
        size_t colon = v.find(':');
        std::string label = trim(v.substr(0, colon));
        std::string rest = trim(v.substr(colon + 1));
        out << ".align 2\n" << sym(label) << ": .word ";
        std::vector<std::string> fns;
        std::stringstream ss(rest);
        std::string item;
        while (std::getline(ss, item, ',')) fns.push_back(trim(item));
        for (size_t i = 0; i < fns.size(); ++i) {
            if (i) out << ", ";
            out << (fns[i].empty() || fns[i] == "(empty)" ? "0" : sym(fns[i]));
        }
        out << "\n";
    }
}

// ---------------------------------------------------------------------------
// Compute the frame: assign a slot to every parameter, local and temporary.
// Comment: >30 lines because it must parse three declaration spellings and
// collect every temporary that appears anywhere in the code.
// ---------------------------------------------------------------------------
void Backend::build_frame(const Function *f) {
    slots.clear();
    type_of.clear();
    int top = 8;   // saved $ra + saved $fp
    int in_off = 0;
    auto add_slot = [&](const std::string &name, int size) {
        if (slots.count(name)) return;
        int s = (size + 3) & ~3;          // round to a word
        top += s;
        slots[name] = {-top, size};
    };

    // Parameters: "type... name"  (name is the last token)
    for (const auto &p : f->params) {
        std::vector<std::string> t = split_ws(p);
        if (t.empty() || t.back() == "...") continue;
        std::string name = t.back();
        std::string type;
        for (size_t i = 0; i + 1 < t.size(); ++i) type += (i ? " " : "") + t[i];
        type_of[name] = type;
        int size = type_is_double(type) ? 8 : 4;
        if (f->name == "main" && !rt) {
            add_slot(name, size);                 // argc/argv arrive in registers
        } else {
            slots[name] = {in_off, size};         // use the incoming argument in place
            in_off += size;
        }
    }

    // Locals: "name : type (size)".  Small slots first, buffers larger than
    // 64 bytes last, so scalars stay within the 16-bit offset range of lw/sw.
    std::vector<std::pair<std::string, int>> big;
    for (const auto &l : f->locals) {
        size_t colon = l.find(" : ");
        if (colon == std::string::npos) continue;
        std::string name = trim(l.substr(0, colon));
        std::string rest = l.substr(colon + 3);
        size_t lp = rest.find('(');
        std::string type = trim(rest.substr(0, lp));
        int size = 4;
        if (lp != std::string::npos) {
            size_t rp = rest.find(')', lp);
            size = std::stoi(rest.substr(lp + 1, rp - lp - 1));
        }
        type_of[name] = type;
        if (size > 64) big.push_back({name, size});
        else add_slot(name, size);
    }

    // Temporaries whose every definition is forwarded in $t2 to the next
    // instruction never touch memory and get no slot (smaller frames).
    std::set<std::string> no_slot;
    {
        std::map<std::string, int> uses = count_temp_uses(f), fwd, other;
        for (size_t i = 0; i < f->code.size(); ++i) {
            std::vector<std::string> t = split_ws(f->code[i].text);
            if (t.size() < 2 || t[1] != "=" || !is_temp(t[0])) continue;
            if (forwardable_temp(f, i, uses) == t[0]) fwd[t[0]]++;
            else other[t[0]]++;
        }
        for (const auto &e : fwd) if (!other.count(e.first)) no_slot.insert(e.first);
    }
    // Temporaries: scan the code.  A temp's type comes from the note on the
    // instruction that assigns it; its slot is 8 bytes for a double, else 4.
    for (const auto &ins : f->code) {
        std::vector<std::string> t = split_ws(ins.text);
        if (t.size() >= 2 && t[1] == "=" && is_temp(t[0]))
            if (!ins.note.empty()) type_of[t[0]] = ins.note;
        for (const auto &tok : t) {
            std::string nm = strip_commas(tok);
            if (nm.size() && nm[0] == '*') nm = nm.substr(1);
            if (nm.size() && nm[0] == '&') nm = nm.substr(1);
            if (is_temp(nm) && !no_slot.count(nm)) {
                int size = type_is_double(type_of.count(nm) ? type_of[nm] : "") ? 8 : 4;
                add_slot(nm, size);
            }
        }
    }
    for (const auto &b : big) add_slot(b.first, b.second);
    frame_size = (top + 7) & ~7;   // keep the frame 8-byte aligned
}

// How many times each temporary is read in the function body.
std::map<std::string, int> Backend::count_temp_uses(const Function *f) {
    std::map<std::string, int> uses;
    for (const auto &ins : f->code) {
        std::vector<std::string> t = split_ws(ins.text);
        for (size_t k = 0; k < t.size(); ++k) {
            if (k == 0 && t.size() > 1 && t[1] == "=" && t[0][0] != '*') continue;   // the definition
            std::string nm = strip_commas(t[k]);
            if (!nm.empty() && (nm[0] == '*' || nm[0] == '&')) nm = nm.substr(1);
            if (is_temp(nm)) uses[nm]++;
        }
    }
    return uses;
}

// The temp defined by instruction i if it may stay in $t2: an integer value
// read exactly once, by instruction i+1, which is not a label or a `param`.
std::string Backend::forwardable_temp(const Function *f, size_t i, const std::map<std::string, int> &uses) {
    if (i + 1 >= f->code.size()) return "";
    std::vector<std::string> t = split_ws(f->code[i].text);
    if (t.size() < 3 || t[1] != "=" || !is_temp(t[0])) return "";
    if (t[2] == "call") return "";
    if (fp_kind(f->code[i].note) || width_of_type(f->code[i].note) == 8) return "";
    auto u = uses.find(t[0]);
    if (u == uses.end() || u->second != 1) return "";
    const std::string &next = f->code[i + 1].text;
    if (next.empty() || next.back() == ':' || next.rfind("param", 0) == 0) return "";
    std::vector<std::string> n = split_ws(next);
    for (size_t k = 0; k < n.size(); ++k) {
        if (k == 0 && n.size() > 1 && n[1] == "=" && n[0][0] != '*') continue;
        std::string nm = strip_commas(n[k]);
        if (!nm.empty() && (nm[0] == '*' || nm[0] == '&')) nm = nm.substr(1);
        if (nm == t[0]) {
            // a floating-point use would read the slot directly
            std::string ty = f->code[i + 1].note;
            if (n.size() > 1 && n[1] == "=" && (fp_kind(ty) || width_of_type(ty) == 8)) return "";
            if (n[0][0] == '*' && (fp_kind(ty) || width_of_type(ty) == 8) && nm != strip_commas(n[0]).substr(1)) return "";
            return t[0];
        }
    }
    return "";
}

std::string Backend::operand_type(const std::string &tok) {
    std::string t = tok;
    if (t.size() && (t[0] == '&' || t[0] == '*')) t = t.substr(1);
    if (type_of.count(t)) return type_of[t];
    if (globals.count(t)) return global_type[t];
    return "int";
}

bool Backend::operand_unsigned(const std::string &tok) {
    if (is_int_literal(tok)) return false;
    return type_is_unsigned(operand_type(tok));
}

// ---------------------------------------------------------------------------
// Load an operand's VALUE into `reg`.
// ---------------------------------------------------------------------------
void Backend::load_operand(const std::string &tok, const std::string &reg) {
    std::string t = strip_commas(tok);
    if (!pending.empty() && t == pending) {
        if (reg != "$t2") out << "    move " << reg << ", $t2\n";
        pending.clear();
        return;
    }
    if (is_int_literal(t)) {
        int64_t v = std::stoll(t);
        out << "    li " << reg << ", " << (int32_t)v << "\n";
        return;
    }
    if (t.size() && t[0] == '&') { addr_of(t.substr(1), reg); return; }
    if (slots.count(t)) {
        fp_access("lw", reg, slots[t].offset);
        return;
    }
    if (is_string_label(t) && !globals.count(t)) {
        out << "    la " << reg << ", " << str_label(std::stoul(t.substr(3))) << "\n";
        return;
    }
    if (globals.count(t)) {
        if (is_scalar_type(global_type[t]))
            out << "    la " << reg << ", " << sym(t) << "\n    lw " << reg << ", 0(" << reg << ")\n";
        else if (heap_globals.count(t))
            out << "    la " << reg << ", " << sym(t) << "\n    lw " << reg << ", 0(" << reg << ")\n";
        else
            out << "    la " << reg << ", " << sym(t) << "\n";  // array decays to address
        return;
    }
    if (funcnames.count(t) || externs.count(t) || vtables.count(t)) {
        out << "    la " << reg << ", " << sym(t) << "\n";
        return;
    }
    note_unsupported("operand '" + t + "'");
    out << "    li " << reg << ", 0\n";
}

// Load the ADDRESS of a named object into `reg`.
void Backend::addr_of(const std::string &name, const std::string &reg) {
    std::string t = strip_commas(name);
    if (t == "__va_args") {   // va_start: incoming arguments after the named ones
        out << "    addiu " << reg << ", $fp, " << va_off << "\n";
        return;
    }
    if (slots.count(t)) {
        fp_address(reg, slots[t].offset);
        return;
    }
    if (heap_globals.count(t)) {
        out << "    la " << reg << ", " << sym(t) << "\n    lw " << reg << ", 0(" << reg << ")\n";
        return;
    }
    if (globals.count(t) || funcnames.count(t) || externs.count(t) || vtables.count(t)) {
        out << "    la " << reg << ", " << sym(t) << "\n";
        return;
    }
    note_unsupported("address of '" + t + "'");
    out << "    li " << reg << ", 0\n";
}

// Store the value in `reg` into the named destination.
void Backend::store_result(const std::string &reg, const std::string &dest) {
    std::string t = strip_commas(dest);
    if (!pend_candidate.empty() && t == pend_candidate) {
        if (reg != "$t2") out << "    move $t2, " << reg << "\n";
        pending = t;                       // value stays in $t2 for the next instruction
        return;
    }
    if (slots.count(t)) {
        fp_access("sw", reg, slots[t].offset);
        return;
    }
    if (globals.count(t)) {
        out << "    la $t8, " << sym(t) << "\n    sw " << reg << ", 0($t8)\n";
        return;
    }
    note_unsupported("store to '" + t + "'");
}

// ---------------------------------------------------------------------------
// Floating-point helpers.
// ---------------------------------------------------------------------------
int Backend::fp_kind(const std::string &type) {
    if (has_indirection(type) || type.find('[') != std::string::npos) return 0;
    std::string w = base_word(type);
    if (w == "double") return 2;
    if (w == "float") return 1;
    return 0;
}

int Backend::operand_fp_kind(const std::string &tok) {
    if (is_float_literal(tok)) {           // decimal literal: double unless suffixed f
        char c = tok.back();
        return (c == 'f' || c == 'F') ? 1 : 2;
    }
    return fp_kind(operand_type(tok));
}

// Load an FP operand into `freg` (a coprocessor-1 register).  kind picks the
// precision (1=single, 2=double); literals are materialised with li.s/li.d.
void Backend::load_fp(const std::string &tok, const std::string &freg, int kind) {
    std::string t = strip_commas(tok);
    const char *ld = (kind == 2) ? "l.d" : "l.s";
    const char *li = (kind == 2) ? "li.d" : "li.s";
    if (is_float_literal(t) || is_int_literal(t)) {
        out << "    " << li << " " << freg << ", " << fp_spelling(t) << "\n";
    } else if (slots.count(t)) {
        fp_access(ld, freg, slots[t].offset);
    } else if (globals.count(t)) {
        out << "    la $t8, " << sym(t) << "\n    " << ld << " " << freg << ", 0($t8)\n";
    } else {
        note_unsupported("fp operand '" + t + "'");
    }
}

void Backend::store_fp(const std::string &freg, const std::string &dst, int kind) {
    const char *st = (kind == 2) ? "s.d" : "s.s";
    std::string t = strip_commas(dst);
    if (slots.count(t))
        fp_access(st, freg, slots[t].offset);
    else if (globals.count(t))
        out << "    la $t8, " << sym(t) << "\n    " << st << " " << freg << ", 0($t8)\n";
    else
        note_unsupported("fp store to '" + t + "'");
}

// FP arithmetic (result in $f0 -> dst) or FP comparison (0/1 int -> dst).
// Comment: >30 lines because it covers four arithmetic and six relational ops
// across single and double precision.
void Backend::emit_fp_binop(const std::string &dst, const std::string &a,
                            const std::string &op, const std::string &b, int kind) {
    const char *sfx = (kind == 2) ? ".d" : ".s";
    load_fp(a, "$f4", kind);
    load_fp(b, "$f6", kind);
    if (op == "+" || op == "-" || op == "*" || op == "/") {
        std::string mn = (op == "+") ? "add" : (op == "-") ? "sub"
                       : (op == "*") ? "mul" : "div";
        out << "    " << mn << sfx << " $f0, $f4, $f6\n";
        store_fp("$f0", dst, kind);
        return;
    }
    // relational: set $t2 to 0/1 using the FP condition flag
    int id = uid++;
    std::string L = lp + "fc" + std::to_string(id);
    if (op == "!=") {
        out << "    li $t2, 1\n    c.eq" << sfx << " $f4, $f6\n    bc1f " << L << "\n";
        out << "    li $t2, 0\n" << L << ":\n";
    } else {
        std::string cc;
        std::string fa = "$f4", fb = "$f6";
        if (op == "==") cc = "eq";
        else if (op == "<") cc = "lt";
        else if (op == "<=") cc = "le";
        else if (op == ">") { cc = "lt"; fa = "$f6"; fb = "$f4"; }
        else if (op == ">=") { cc = "le"; fa = "$f6"; fb = "$f4"; }
        else { note_unsupported("fp op '" + op + "'"); }
        out << "    li $t2, 0\n    c." << cc << sfx << " " << fa << ", " << fb << "\n";
        out << "    bc1f " << L << "\n    li $t2, 1\n" << L << ":\n";
    }
    store_result("$t2", dst);
}

// FP conversion cast: (target) val, where target and/or source is FP.
void Backend::emit_fp_cast(const std::string &dst, const std::string &ty,
                           const std::string &val) {
    int tgt = fp_kind(ty);
    int src = operand_fp_kind(val);
    if (tgt && is_float_literal(val)) {           // (float)1.5 / (double)2.0
        load_fp(val, "$f0", tgt);
        store_fp("$f0", dst, tgt);
    } else if (tgt && src == 0) {                 // int -> float/double
        load_operand(val, "$t0");
        out << "    mtc1 $t0, $f4\n    cvt." << (tgt == 2 ? "d" : "s") << ".w $f0, $f4\n";
        store_fp("$f0", dst, tgt);
    } else if (tgt && src) {                       // float <-> double
        load_fp(val, "$f4", src);
        out << "    cvt." << (tgt == 2 ? "d" : "s") << "." << (src == 2 ? "d" : "s")
            << " $f0, $f4\n";
        store_fp("$f0", dst, tgt);
    } else {                                       // FP -> int
        load_fp(val, "$f4", src);
        out << "    trunc.w." << (src == 2 ? "d" : "s") << " $f0, $f4\n    mfc1 $t0, $f0\n";
        store_result("$t0", dst);
    }
}

// ---------------------------------------------------------------------------
// Binary operator lowering.  $t0=left, $t1=right, $t2=result.
// ---------------------------------------------------------------------------
void Backend::emit_binop(const std::string &dst, const std::string &a,
                         const std::string &op, const std::string &b,
                         const std::string &note) {
    int fk = std::max(operand_fp_kind(a), operand_fp_kind(b));
    if (fk > 0) { emit_fp_binop(dst, a, op, b, fk); return; }
    bool uns_div = note.find("unsigned") != std::string::npos;       // for / % >>
    bool uns_cmp = operand_unsigned(a) || operand_unsigned(b);       // for < > <= >=
    // immediate forms when the right operand is a small constant
    std::string bb = strip_commas(b);
    if (is_int_literal(bb)) {
        long long k = std::stoll(bb);
        const char *imm = nullptr;
        long long kk = k;
        if (op == "+" && k >= -32768 && k <= 32767) imm = "addiu";
        else if (op == "-" && k >= -32767 && k <= 32768) { imm = "addiu"; kk = -k; }
        else if (op == "&" && k >= 0 && k <= 65535) imm = "andi";
        else if (op == "|" && k >= 0 && k <= 65535) imm = "ori";
        else if (op == "^" && k >= 0 && k <= 65535) imm = "xori";
        else if (op == "<<" && k >= 0 && k <= 31) imm = "sll";
        else if (op == ">>" && k >= 0 && k <= 31) imm = uns_div ? "srl" : "sra";
        else if (op == "<" && k >= -32768 && k <= 32767) imm = uns_cmp ? "sltiu" : "slti";
        if (imm) {
            load_operand(a, "$t0");
            out << "    " << imm << " $t2, $t0, " << kk << "\n";
            store_result("$t2", dst);
            return;
        }
    }
    load_operand(a, "$t0");
    load_operand(b, "$t1");
    if (op == "+")       out << "    addu $t2, $t0, $t1\n";
    else if (op == "-")  out << "    subu $t2, $t0, $t1\n";
    else if (op == "*")  out << "    mult $t0, $t1\n    mflo $t2\n";
    else if (op == "/")  out << "    " << (uns_div ? "divu" : "div") << " $t0, $t1\n    mflo $t2\n";
    else if (op == "%")  out << "    " << (uns_div ? "divu" : "div") << " $t0, $t1\n    mfhi $t2\n";
    else if (op == "&")  out << "    and $t2, $t0, $t1\n";
    else if (op == "|")  out << "    or $t2, $t0, $t1\n";
    else if (op == "^")  out << "    xor $t2, $t0, $t1\n";
    else if (op == "<<") out << "    sllv $t2, $t0, $t1\n";
    else if (op == ">>") out << "    " << (uns_div ? "srlv" : "srav") << " $t2, $t0, $t1\n";
    else if (op == "==") out << "    subu $t2, $t0, $t1\n    sltiu $t2, $t2, 1\n";
    else if (op == "!=") out << "    subu $t2, $t0, $t1\n    sltu $t2, $zero, $t2\n";
    else if (op == "<")  out << "    " << (uns_cmp ? "sltu" : "slt") << " $t2, $t0, $t1\n";
    else if (op == ">")  out << "    " << (uns_cmp ? "sltu" : "slt") << " $t2, $t1, $t0\n";
    else if (op == "<=") out << "    " << (uns_cmp ? "sltu" : "slt") << " $t2, $t1, $t0\n    xori $t2, $t2, 1\n";
    else if (op == ">=") out << "    " << (uns_cmp ? "sltu" : "slt") << " $t2, $t0, $t1\n    xori $t2, $t2, 1\n";
    else { note_unsupported("binary op '" + op + "'"); out << "    move $t2, $t0\n"; }
    store_result("$t2", dst);
}

// ---------------------------------------------------------------------------
// Call lowering.  Pushes pending params (arg0 lowest), jal/jalr, pops.
// Comment: >30 lines because it handles both direct and indirect calls, mixed
// 4- and 8-byte arguments, and an optional result.
// ---------------------------------------------------------------------------
void Backend::emit_call(const std::string &callee, int /*n*/,
                        const std::string &dest, const std::string &note) {
    // compute total argument bytes
    int total = 0;
    std::vector<int> off;
    for (const auto &p : pending_params) {
        off.push_back(total);
        total += arg_is_double(p) ? 8 : 4;
    }
    bool indirect = (!callee.empty() && callee[0] == '*');
    std::string target = indirect ? strip_commas(callee.substr(1)) : strip_commas(callee);

    if (indirect) load_operand(target, "$t9");   // function address before pushing
    if (total) out << "    addiu $sp, $sp, -" << total << "\n";
    for (size_t i = 0; i < pending_params.size(); ++i) {
        const std::string &p = pending_params[i];
        if (arg_is_double(p)) {
            load_fp(p, "$f0", 2);
            out << "    s.d $f0, " << off[i] << "($sp)\n";
        } else if (is_float_literal(p)) {          // 2.5f: push the single's bits
            load_fp(p, "$f0", 1);
            out << "    s.s $f0, " << off[i] << "($sp)\n";
        } else {
            load_operand(p, "$t0");
            out << "    sw $t0, " << off[i] << "($sp)\n";
        }
    }
    if (indirect) out << "    jalr $t9\n";
    else          out << "    jal " << sym(target) << "\n";
    if (total) out << "    addiu $sp, $sp, " << total << "\n";
    pending_params.clear();

    if (!dest.empty()) {
        int fk = fp_kind(note);
        if (fk) store_fp("$f0", dest, fk);   // FP results come back in $f0
        else store_result("$v0", dest);
    }
}

// copy dst, src, n   (byte memcpy between two address operands)
void Backend::emit_copy(const std::vector<std::string> &toks) {
    // toks: copy <dst>, <src>, <n>
    std::string dst = strip_commas(toks[1]);
    std::string src = strip_commas(toks[2]);
    std::string n = strip_commas(toks[3]);
    load_operand(dst, "$t8");
    load_operand(src, "$t9");
    load_operand(n, "$t0");
    int id = uid++;
    std::string L = lp + "cpy" + std::to_string(id);
    out << L << ":\n";
    out << "    beq $t0, $zero, " << L << "_end\n";
    out << "    lb $t1, 0($t9)\n    sb $t1, 0($t8)\n";
    out << "    addiu $t8, $t8, 1\n    addiu $t9, $t9, 1\n    addiu $t0, $t0, -1\n";
    out << "    j " << L << "\n" << L << "_end:\n";
}

// ---------------------------------------------------------------------------
// Translate one IR instruction.
// Comment: >30 lines because it dispatches every IR instruction form.
// ---------------------------------------------------------------------------
void Backend::translate(const Instr &ins) {
    const std::string &text = ins.text;
    const std::string &note = ins.note;

    // label?
    if (!text.empty() && text.back() == ':' && text.find(' ') == std::string::npos) {
        out << asm_label(text.substr(0, text.size() - 1)) << ":\n";
        return;
    }
    std::vector<std::string> t = split_ws(text);
    if (t.empty()) return;

    if (t[0] == "goto") { out << "    j " << asm_label(t[1]) << "\n"; return; }
    if (t[0] == "if" || t[0] == "ifFalse") {   // if X goto L / ifFalse X goto L
        bool jump_if_true = t[0] == "if";
        int k = operand_fp_kind(strip_commas(t[1]));
        if (k > 0) {                               // floating condition: compare with 0.0
            load_fp(t[1], "$f4", k);
            out << "    mtc1 $zero, $f6\n";
            if (k == 2) out << "    cvt.d.w $f6, $f6\n";
            out << "    c.eq." << (k == 2 ? "d" : "s") << " $f4, $f6\n";
            out << "    " << (jump_if_true ? "bc1f " : "bc1t ") << asm_label(t[3]) << "\n";
            return;
        }
        std::string reg = "$t0";
        if (!pending.empty() && strip_commas(t[1]) == pending) { reg = "$t2"; pending.clear(); }
        else load_operand(t[1], "$t0");
        out << "    " << (jump_if_true ? "bne " : "beq ") << reg << ", $zero, " << asm_label(t[3]) << "\n";
        return;
    }
    if (t[0] == "return") {
        if (t.size() >= 2) {
            int fk = fp_kind(note);
            if (fk) {
                load_fp(t[1], "$f0", fk);   // FP return value in $f0
            } else {
                load_operand(t[1], "$v0");
            }
        }
        if (!at_last_instr) out << "    j " << lp << "ret" << func_idx << "\n";
        return;
    }
    if (t[0] == "param") { pending_params.push_back(strip_commas(t[1])); return; }
    if (t[0] == "call") {   // call f, n   (no result)
        emit_call(strip_commas(t[1]), 0, "", "");
        return;
    }
    if (t[0] == "copy") { emit_copy(t); return; }

    // store through pointer:  *X = Y
    if (t[0].size() && t[0][0] == '*') {
        std::string addr = t[0].substr(1);
        // rhs is everything after '='
        std::string rhs = trim(text.substr(text.find('=') + 1));
        int w = width_of_type(note);
        if (w == 8) {   // double: store both words through the pointer
            load_fp(strip_commas(rhs), "$f0", 2);
            load_operand(addr, "$t1");
            out << "    s.d $f0, 0($t1)\n";
            return;
        }
        if (fp_kind(note) == 1 && is_float_literal(strip_commas(rhs))) {
            load_fp(strip_commas(rhs), "$f0", 1);
            load_operand(addr, "$t1");
            out << "    s.s $f0, 0($t1)\n";
            return;
        }
        const char *st = (w == 1) ? "sb" : (w == 2) ? "sh" : "sw";
        if (!pending.empty() && strip_commas(rhs) == pending) {       // value forwarded in $t2
            pending.clear();
            load_operand(addr, "$t1");
            out << "    " << st << " $t2, 0($t1)\n";
            return;
        }
        if (!pending.empty() && strip_commas(addr) == pending) {      // address forwarded in $t2
            pending.clear();
            load_operand(rhs, "$t0");
            out << "    " << st << " $t0, 0($t2)\n";
            return;
        }
        load_operand(rhs, "$t0");
        load_operand(addr, "$t1");
        out << "    " << st << " $t0, 0($t1)\n";
        return;
    }

    // assignment: DST = RHS
    if (t.size() >= 2 && t[1] == "=") {
        std::string dst = t[0];
        std::string rhs = trim(text.substr(text.find('=') + 1));
        std::vector<std::string> r = split_ws(rhs);

        // call with result
        if (!r.empty() && r[0] == "call") {
            emit_call(strip_commas(r[1]), 0, dst, note);
            return;
        }
        // address-of
        if (rhs.size() && rhs[0] == '&') {
            addr_of(rhs.substr(1), "$t2");
            store_result("$t2", dst);
            return;
        }
        // load through pointer
        if (rhs.size() && rhs[0] == '*') {
            std::string base = "$t1";
            if (!pending.empty() && strip_commas(rhs.substr(1)) == pending) {
                pending.clear();
                base = "$t2";                       // address forwarded from the previous instruction
            } else {
                load_operand(rhs.substr(1), "$t1");
            }
            int w = width_of_type(note);
            if (w == 8) {   // double: load both words
                out << "    l.d $f0, 0(" << base << ")\n";
                store_fp("$f0", dst, 2);
                return;
            }
            bool uns = note.find("unsigned") != std::string::npos;
            const char *ld = (w == 1) ? (uns ? "lbu" : "lb")
                           : (w == 2) ? (uns ? "lhu" : "lh") : "lw";
            out << "    " << ld << " $t2, 0(" << base << ")\n";
            store_result("$t2", dst);
            return;
        }
        // cast: (type) operand
        if (rhs.size() && rhs[0] == '(') {
            size_t rp = rhs.find(')');
            std::string ty = trim(rhs.substr(1, rp - 1));
            std::string val = trim(rhs.substr(rp + 1));
            if (fp_kind(ty) > 0 || operand_fp_kind(val) > 0) {
                emit_fp_cast(dst, ty, val);
                return;
            }
            load_operand(val, "$t2");
            if (ty == "char") out << "    sll $t2, $t2, 24\n    sra $t2, $t2, 24\n";
            else if (ty == "unsigned char") out << "    andi $t2, $t2, 0xff\n";
            else if (ty == "short") out << "    sll $t2, $t2, 16\n    sra $t2, $t2, 16\n";
            else if (ty == "unsigned short") out << "    andi $t2, $t2, 0xffff\n";
            else if (ty == "bool") out << "    sltu $t2, $zero, $t2\n";
            // int/unsigned int/long/pointer: 4-byte, no change
            store_result("$t2", dst);
            return;
        }
        // unary: OP operand
        if (r.size() == 2 && (r[0] == "-" || r[0] == "!" || r[0] == "~")) {
            if (r[0] == "-" && operand_fp_kind(r[1]) > 0) {   // FP negation
                int k = operand_fp_kind(r[1]);
                load_fp(r[1], "$f4", k);
                out << "    neg." << (k == 2 ? "d" : "s") << " $f0, $f4\n";
                store_fp("$f0", dst, k);
                return;
            }
            if (r[0] == "!" && operand_fp_kind(r[1]) > 0) {   // !x on a float/double
                int k = operand_fp_kind(r[1]);
                int id = uid++;
                load_fp(r[1], "$f4", k);
                out << "    mtc1 $zero, $f6\n";
                if (k == 2) out << "    cvt.d.w $f6, $f6\n";
                out << "    li $t2, 1\n    c.eq." << (k == 2 ? "d" : "s") << " $f4, $f6\n";
                out << "    bc1t " << lp << "nz" << id << "\n    li $t2, 0\n" << lp << "nz" << id << ":\n";
                store_result("$t2", dst);
                return;
            }
            load_operand(r[1], "$t0");
            if (r[0] == "-") out << "    subu $t2, $zero, $t0\n";
            else if (r[0] == "!") out << "    sltiu $t2, $t0, 1\n";
            else out << "    nor $t2, $t0, $zero\n";
            store_result("$t2", dst);
            return;
        }
        // binary: a OP b
        if (r.size() == 3) {
            emit_binop(dst, r[0], r[1], r[2], note);
            return;
        }
        // copy: DST = operand
        if (r.size() == 1) {
            // FP literal (e.g. `d = 3.14159 ; double`) or FP copy
            if (fp_kind(note) > 0 && (is_float_literal(r[0]) || is_int_literal(r[0]) ||
                                      fp_kind(note) == 2)) {
                load_fp(r[0], "$f0", fp_kind(note));
                store_fp("$f0", dst, fp_kind(note));
                return;
            }
            load_operand(r[0], "$t2");
            store_result("$t2", dst);
            return;
        }
        note_unsupported("rhs '" + rhs + "'");
        return;
    }

    note_unsupported("instruction '" + text + "'");
}

// ---------------------------------------------------------------------------
// Emit a full function: prologue, argument copy-in, body, epilogue.
// Comment: >30 lines because it covers the whole frame protocol.
// ---------------------------------------------------------------------------
void Backend::emit_function(const Function *f) {
    build_frame(f);
    pending_params.clear();

    if (rt) out << "\n# @fn " << sym(f->name);
    out << "\n" << sym(f->name) << ":\n";
    // prologue
    out << "    move $t8, $fp\n";
    out << "    move $t9, $sp\n";
    if (frame_size <= 32768) out << "    addiu $sp, $sp, -" << frame_size << "\n";
    else out << "    li $t3, " << frame_size << "\n    subu $sp, $sp, $t3\n";   // frame > 32 KB
    out << "    move $fp, $t9\n";
    out << "    sw $ra, -4($fp)\n";
    out << "    sw $t8, -8($fp)\n";

    // large global arrays: allocate (zero-filled) heap memory before anything runs
    if (!rt && f->name == "main" && !heap_globals.empty()) {
        out << "    move $t3, $a0\n";                      // keep argc
        for (const auto &hg : heap_globals) {
            out << "    li $a0, " << ((hg.second + 7) & ~7) << "\n    li $v0, 9\n    syscall\n";
            out << "    la $t0, " << sym(hg.first) << "\n    sw $v0, 0($t0)\n";
        }
        out << "    move $a0, $t3\n";
    }
    // spim's start-up code passes argc in $a0 and argv in $a1
    if (!rt && f->name == "main") {
        const char *areg[] = {"$a0", "$a1", "$a2"};
        int k = 0;
        for (const auto &p : f->params) {
            std::vector<std::string> tk = split_ws(p);
            if (tk.empty() || k >= 3 || tk.back() == "...") continue;
            fp_access("sw", areg[k++], slots[tk.back()].offset);
        }
    }

    // parameters are used in place (their slots are the incoming argument words)
    int in_off = 0;
    for (const auto &p : f->params) {
        std::vector<std::string> tk = split_ws(p);
        if (tk.empty() || tk.back() == "...") continue;
        std::string type;
        for (size_t i = 0; i + 1 < tk.size(); ++i) type += (i ? " " : "") + tk[i];
        in_off += type_is_double(type) ? 8 : 4;
    }
    va_off = in_off;   // first unnamed (variadic) argument

    std::map<std::string, int> uses = count_temp_uses(f);
    pending.clear();
    for (size_t i = 0; i < f->code.size(); ++i) {
        pend_candidate = forwardable_temp(f, i, uses);
        at_last_instr = i + 1 == f->code.size();
        translate(f->code[i]);
        if (!pending.empty() && pending != pend_candidate) pending.clear();
    }
    at_last_instr = false;
    pend_candidate.clear();
    pending.clear();

    // shared epilogue
    out << lp << "ret" << func_idx << ":\n";
    out << "    lw $ra, -4($fp)\n";
    out << "    lw $t8, -8($fp)\n";
    out << "    move $sp, $fp\n";
    out << "    move $fp, $t8\n";
    out << "    jr $ra\n";
    if (rt) out << "# @endfn\n";
}

}  // namespace

bool runtime_provides(const std::string &name) {
    static std::set<std::string> exports;
    if (exports.empty()) {
        std::istringstream is(LIBFNS);
        std::string line;
        while (std::getline(is, line))
            if (line.rfind("R_", 0) == 0 && line.size() > 3 && line.back() == ':')
                exports.insert(line.substr(2, line.size() - 3));
        exports.insert("");
    }
    return exports.count(name) > 0;
}

bool emit_mips(const Module &mod, std::ostream &out,
               std::vector<std::string> &unsupported, bool runtime_mode) {
    Backend b(mod, out, unsupported, runtime_mode);
    b.run();
    return !mod.funcs.empty();
}

}  // namespace fns
