// ===========================================================================
// optimize.cpp - machine-independent optimisation of the three-address code.
//
// Runs on every function after IR generation and before MIPS translation
// (`fnsc -O0` turns it off):
//   * constant folding      t = 3 * 4            ->  t = 12
//                           ifFalse 1 goto L     ->  (removed)
//   * constant propagation  n = 4; t = n * k     ->  t = 4 * k
//   * copy propagation      t = a; u = t + 1     ->  u = a + 1
//                           t = a + b; s = t     ->  s = a + b
//   * strength reduction    t = i * 8            ->  t = i << 3
//                           unsigned u / 4, u % 4 -> u >> 2, u & 3
//                           x * 1, x * 0, x + 0, x / 1, x % 1  ->  x, 0, x, x, 0
// followed by removal of temporaries that are no longer read.
//
// The back end decides each operand's width, signedness and integer/float
// kind from the operand's own type, so a replacement is made only when it
// keeps that type: a literal stands only for a 4-byte integer variable (and
// not for an unsigned one in a comparison, where a literal compares as
// signed), a copy source must have exactly the type of the copy.  Propagation is limited to
// one basic block (a label forgets everything) and to locals, parameters and
// temporaries whose address is never taken, which no call or store through a
// pointer can change.  Folding reproduces the back end's 32-bit arithmetic and
// leaves division by zero, INT_MIN / -1 and out-of-range shifts to run time.
// ===========================================================================
#include "optimize.hpp"

#include <cstdint>
#include <map>
#include <set>
#include <sstream>

namespace fns {
namespace {

std::vector<std::string> words(const std::string &s) {
    std::vector<std::string> v;
    std::istringstream is(s);
    std::string t;
    while (is >> t) v.push_back(t);
    return v;
}

std::string join(const std::vector<std::string> &w, size_t from = 0) {
    std::string s;
    for (size_t i = from; i < w.size(); ++i) s += (i > from ? " " : "") + w[i];
    return s;
}

std::string bare(std::string s) {   // operand without its trailing comma or */& prefix
    if (!s.empty() && s.back() == ',') s.pop_back();
    if (!s.empty() && (s[0] == '*' || s[0] == '&')) s = s.substr(1);
    return s;
}

bool is_lit(const std::string &s) {
    size_t i = (!s.empty() && (s[0] == '-' || s[0] == '+')) ? 1 : 0;
    if (i >= s.size() || s.size() > 18) return false;
    for (; i < s.size(); ++i)
        if (!isdigit((unsigned char)s[i])) return false;
    return true;
}

bool fits32(const std::string &s) {
    long long v = std::stoll(s);
    return v >= INT32_MIN && v <= INT32_MAX;
}

int32_t lit(const std::string &s) { return (int32_t)std::stoll(s); }   // as `li` loads it

bool is_temp(const std::string &s) {
    if (s.size() < 2 || s[0] != 't') return false;
    for (size_t i = 1; i < s.size(); ++i)
        if (!isdigit((unsigned char)s[i])) return false;
    return true;
}

bool is_label(const Instr &in) {
    return !in.text.empty() && in.text.back() == ':' && in.text.find(' ') == std::string::npos;
}

bool is_def(const std::vector<std::string> &w) {
    return w.size() >= 3 && w[1] == "=" && w[0][0] != '*';
}

bool fp_type(const std::string &t) {
    if (t.find('*') != std::string::npos || t.find('[') != std::string::npos) return false;
    return t == "double" || t == "float" || t.find(" double") != std::string::npos ||
           t.find(" float") != std::string::npos;
}

// Plain 4-byte integer types: the only results folded or strength-reduced.
bool word_int(const std::string &t) {
    return t == "int" || t == "long" || t == "unsigned int" || t == "unsigned long";
}

// Types whose value lives in one scalar slot (no aggregates, arrays, references).
bool scalar(const std::string &t) {
    static const std::set<std::string> base = {"int", "long", "unsigned int", "unsigned long",
        "char", "signed char", "unsigned char", "short", "unsigned short", "bool",
        "float", "double", "ptr"};
    if (base.count(t)) return true;
    return !t.empty() && t.back() == '*' && t.find('&') == std::string::npos &&
           t.find('[') == std::string::npos;
}

bool is_cmp(const std::string &op) {
    return op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=";
}

// 32-bit evaluation of `a op b`, as the MIPS back end computes it.
bool fold_binary(const std::string &op, int32_t a, int32_t b, bool uns, int32_t &r) {
    uint32_t ua = (uint32_t)a, ub = (uint32_t)b;
    if (op == "+") r = (int32_t)(ua + ub);
    else if (op == "-") r = (int32_t)(ua - ub);
    else if (op == "*") r = (int32_t)(ua * ub);
    else if (op == "&") r = (int32_t)(ua & ub);
    else if (op == "|") r = (int32_t)(ua | ub);
    else if (op == "^") r = (int32_t)(ua ^ ub);
    else if (op == "/" || op == "%") {
        if (b == 0 || (!uns && a == INT32_MIN && b == -1)) return false;
        if (uns) r = (int32_t)(op == "/" ? ua / ub : ua % ub);
        else r = op == "/" ? a / b : a % b;
    } else if (op == "<<" || op == ">>") {
        if (b < 0 || b > 31) return false;
        if (op == "<<") r = (int32_t)(ua << b);
        else r = uns ? (int32_t)(ua >> b) : (a >> b);
    }
    else if (op == "==") r = a == b;
    else if (op == "!=") r = a != b;
    else if (op == "<") r = a < b;
    else if (op == ">") r = a > b;
    else if (op == "<=") r = a <= b;
    else if (op == ">=") r = a >= b;
    else return false;
    return true;
}

class FuncOpt {
public:
    FuncOpt(Function &f, const std::map<std::string, std::string> &globals, OptStats &st)
        : f_(f), globals_(globals), st_(st) {}
    void run();

private:
    Function &f_;
    const std::map<std::string, std::string> &globals_;
    OptStats &st_;
    std::map<std::string, std::string> type_;   // params, locals and temporaries
    std::set<std::string> addr_;                // names whose address is taken

    void scan();
    std::string type_of(const std::string &n) const;
    bool tracked(const std::string &n) const;
    bool params_until_call(size_t i) const;
    bool substitute(std::vector<std::string> &w, const std::string &note,
                    const std::map<std::string, std::string> &val, bool param_ok);
    bool fold(std::vector<std::string> &w, const std::string &note, bool &drop);
    bool reduce(std::vector<std::string> &w, const std::string &note);
    bool forward();
    bool merge();
    bool sweep();
    std::map<std::string, int> count_uses() const;
};

// Types of every name the function owns, and the names whose address is taken.
void FuncOpt::scan() {
    for (const std::string &p : f_.params) {            // "int a", "Vec& v"
        size_t sp = p.rfind(' ');
        if (sp != std::string::npos) type_[p.substr(sp + 1)] = p.substr(0, sp);
    }
    for (const std::string &l : f_.locals) {            // "nums : int[5] (20)"
        size_t c = l.find(" : "), sz = l.rfind(" (");
        if (c != std::string::npos && sz != std::string::npos && sz > c)
            type_[l.substr(0, c)] = l.substr(c + 3, sz - c - 3);
    }
    for (const Instr &in : f_.code) {
        std::vector<std::string> w = words(in.text);
        if (is_def(w) && is_temp(w[0])) {               // a temp's type is its note
            auto it = type_.find(w[0]);
            if (it == type_.end()) type_[w[0]] = in.note;
            else if (it->second != in.note) it->second = "?";
        }
        for (const std::string &tok : w)
            if (tok.size() > 1 && tok[0] == '&') addr_.insert(bare(tok));
    }
}

std::string FuncOpt::type_of(const std::string &n) const {
    auto it = type_.find(n);
    if (it != type_.end()) return it->second;
    auto g = globals_.find(n);
    return g != globals_.end() ? g->second : "";
}

// A name whose value only changes by an assignment to it in this function.
bool FuncOpt::tracked(const std::string &n) const {
    auto it = type_.find(n);
    return it != type_.end() && !addr_.count(n) && scalar(it->second);
}

// `param` operands are read by the following `call`: a replacement at the
// `param` is valid only if nothing but other params comes in between.
bool FuncOpt::params_until_call(size_t i) const {
    for (size_t j = i + 1; j < f_.code.size(); ++j) {
        std::vector<std::string> w = words(f_.code[j].text);
        if (!w.empty() && w[0] == "param") continue;
        return !w.empty() && (w[0] == "call" || (w.size() > 2 && w[1] == "=" && w[2] == "call"));
    }
    return false;
}

// Replace the operands this instruction reads by their known constant or copy
// source.  Literals go only where the back end reads a plain integer value.
// Comment: >30 lines because it lists, per instruction form, which words are
// operands that are read.
bool FuncOpt::substitute(std::vector<std::string> &w, const std::string &note,
                         const std::map<std::string, std::string> &val, bool param_ok) {
    bool edited = false;
    bool lit_ok = !fp_type(note);
    auto put = [&](size_t k, bool literal_ok) {
        if (k >= w.size()) return;
        std::string tok = w[k], comma, star;
        if (!tok.empty() && tok.back() == ',') { comma = ","; tok.pop_back(); }
        if (!tok.empty() && tok[0] == '*') { star = "*"; tok = tok.substr(1); literal_ok = false; }
        auto it = val.find(tok);
        if (it == val.end()) return;
        bool is_const = is_lit(it->second);
        if (is_const && !literal_ok) return;
        // a literal compares as signed: an unsigned operand of a comparison stays a name
        if (is_const && w.size() == 5 && is_cmp(w[3]) &&
            type_of(tok).find("unsigned") != std::string::npos) return;
        w[k] = star + it->second + comma;
        ++(is_const ? st_.constants : st_.copies);
        edited = true;
    };
    const std::string &h = w[0];
    if (h == "if" || h == "ifFalse") put(1, true);
    else if (h == "return") put(1, lit_ok);
    else if (h == "param") { if (param_ok) put(1, true); }
    else if (h == "call") { if (w.size() > 1 && w[1][0] == '*') put(1, false); }
    else if (h == "copy") { put(1, false); put(2, false); }
    else if (w.size() >= 3 && w[1] == "=") {
        if (h[0] == '*') put(0, false);                         // *p = v
        const std::string &r = w[2];
        if (r == "call") { if (w.size() > 3 && w[3][0] == '*') put(3, false); }
        else if (r[0] == '&') {}                                // address of a name
        else if (r[0] == '(') put(w.size() - 1, lit_ok);        // (type) v
        else if (w.size() == 3) put(2, lit_ok);                 // v, *p
        else if (w.size() == 4) put(3, lit_ok);                 // op v
        else if (w.size() == 5) { put(2, lit_ok); put(4, lit_ok); }   // a op b
    }
    return edited;
}

// Evaluate an instruction whose operands are all literals.  A conditional jump
// on a literal becomes `goto` or disappears (`drop`).
// Comment: >30 lines because it folds jumps, binary, unary and cast forms.
bool FuncOpt::fold(std::vector<std::string> &w, const std::string &note, bool &drop) {
    if ((w[0] == "if" || w[0] == "ifFalse") && w.size() == 4 && is_lit(w[1])) {
        ++st_.folded;
        if ((lit(w[1]) != 0) == (w[0] == "if")) w = {"goto", w[3]};
        else drop = true;
        return true;
    }
    if (!is_def(w) || !word_int(note)) return false;
    bool uns = note.find("unsigned") != std::string::npos;
    int32_t r;
    if (w.size() == 5 && is_lit(w[2]) && is_lit(w[4])) {
        if (is_cmp(w[3]) && !(fits32(w[2]) && fits32(w[4]))) return false;
        if (!fold_binary(w[3], lit(w[2]), lit(w[4]), uns, r)) return false;
    } else if (w.size() == 4 && is_lit(w[3]) && (w[2] == "-" || w[2] == "!" || w[2] == "~")) {
        int32_t a = lit(w[3]);
        r = w[2] == "-" ? (int32_t)(0u - (uint32_t)a) : w[2] == "!" ? (a == 0) : ~a;
    } else if (w[2][0] == '(' && is_lit(w.back())) {             // (int) 5, (unsigned int) -1
        std::string ty = join(w, 2);
        ty = ty.substr(1, ty.find(')') - 1);
        if (!word_int(ty)) return false;
        r = lit(w.back());
    } else {
        return false;
    }
    w = {w[0], "=", std::to_string(r)};
    ++st_.folded;
    return true;
}

// Replace a multiplication, unsigned division or unsigned remainder by a
// power of two with a shift or mask, and drop identities (x*1, x*0, x+0, x-0, x/1, x%1).
// Signed division rounds toward zero, so it stays a `div`.
// Comment: >30 lines because each operator has its own replacement rule.
bool FuncOpt::reduce(std::vector<std::string> &w, const std::string &note) {
    static const std::set<std::string> ops = {"+", "-", "*", "/", "%"};
    if (w.size() != 5 || !is_def(w) || !word_int(note) || !ops.count(w[3])) return false;
    std::string a = w[2], op = w[3], b = w[4];
    if (is_lit(a) == is_lit(b)) return false;           // folded, or no constant
    if (is_lit(a)) {
        if (op != "*" && op != "+") return false;
        std::swap(a, b);                                // constant on the right
    }
    std::string ta = type_of(a);
    if (ta.empty() || ta == "?" || fp_type(ta) || ta.find('[') != std::string::npos) return false;
    if (!fits32(b)) return false;
    uint32_t k = (uint32_t)lit(b);
    bool uns = note.find("unsigned") != std::string::npos;
    bool pow2 = k != 0 && (k & (k - 1)) == 0;
    int log2 = 0;
    while (pow2 && (1u << log2) != k) ++log2;
    std::vector<std::string> r;
    if ((op == "+" || op == "-") && k == 0) r = {a};
    else if (op == "*" && k == 0) r = {"0"};
    else if (op == "*" && k == 1) r = {a};
    else if (op == "*" && pow2) r = {a, "<<", std::to_string(log2)};
    else if (op == "/" && k == 1) r = {a};
    else if (op == "/" && uns && pow2) r = {a, ">>", std::to_string(log2)};
    else if (op == "%" && k == 1) r = {"0"};
    else if (op == "%" && uns && pow2) r = {a, "&", std::to_string(k - 1)};
    else return false;
    w.resize(2);
    w.insert(w.end(), r.begin(), r.end());
    ++st_.reduced;
    return true;
}

// One pass over the code: in each basic block, replace uses by known constants
// and copy sources, then fold and strength-reduce the result.
// Comment: >30 lines because it keeps the per-block table of known values and
// updates it after every definition.
bool FuncOpt::forward() {
    bool changed = false;
    std::map<std::string, std::string> val;   // name -> literal or name it equals
    std::vector<Instr> out;
    for (size_t i = 0; i < f_.code.size(); ++i) {
        Instr in = f_.code[i];
        if (is_label(in)) { val.clear(); out.push_back(in); continue; }
        std::vector<std::string> w = words(in.text);
        if (w.empty()) { out.push_back(in); continue; }
        bool drop = false;
        bool edited = substitute(w, in.note, val, w[0] == "param" && params_until_call(i));
        edited |= fold(w, in.note, drop);
        edited |= reduce(w, in.note);
        if (drop) { ++st_.removed; changed = true; continue; }
        if (edited) { in.text = join(w); changed = true; }
        if (is_def(w)) {                       // forget what the new value invalidates
            const std::string &x = w[0];
            val.erase(x);
            for (auto it = val.begin(); it != val.end();)
                it = it->second == x ? val.erase(it) : std::next(it);
            if (w.size() == 3 && tracked(x) && w[2] != x) {
                const std::string &tx = type_.at(x);
                if (is_lit(w[2]) && fits32(w[2]) && word_int(tx)) val[x] = w[2];
                else if (tracked(w[2]) && type_.at(w[2]) == tx) val[x] = w[2];
            }
        }
        out.push_back(in);
    }
    f_.code.swap(out);
    return changed;
}

// How many times each temporary is read.
std::map<std::string, int> FuncOpt::count_uses() const {
    std::map<std::string, int> uses;
    for (const Instr &in : f_.code) {
        std::vector<std::string> w = words(in.text);
        for (size_t k = is_def(w) ? 2 : 0; k < w.size(); ++k)
            if (is_temp(bare(w[k]))) ++uses[bare(w[k])];
    }
    return uses;
}

// `t = expr; v = t` with t defined and read only there  ->  `v = expr`.
bool FuncOpt::merge() {
    std::map<std::string, int> uses = count_uses(), defs;
    for (const Instr &in : f_.code) {
        std::vector<std::string> w = words(in.text);
        if (is_def(w)) ++defs[w[0]];
    }
    bool changed = false;
    std::vector<Instr> out;
    for (size_t i = 0; i < f_.code.size(); ++i) {
        std::vector<std::string> w = words(f_.code[i].text);
        if (i + 1 < f_.code.size() && is_def(w) && is_temp(w[0]) && w[2] != "call" &&
            defs[w[0]] == 1 && uses[w[0]] == 1 && scalar(f_.code[i].note)) {
            std::vector<std::string> n = words(f_.code[i + 1].text);
            if (n.size() == 3 && is_def(n) && n[2] == w[0] && f_.code[i + 1].note == f_.code[i].note) {
                out.push_back({n[0] + " = " + join(w, 2), f_.code[i].note});
                ++st_.copies;
                ++i;
                changed = true;
                continue;
            }
        }
        out.push_back(f_.code[i]);
    }
    f_.code.swap(out);
    return changed;
}

// Delete definitions of temporaries nobody reads (calls stay) and self-copies.
bool FuncOpt::sweep() {
    std::map<std::string, int> uses = count_uses();
    bool changed = false;
    std::vector<Instr> out;
    for (const Instr &in : f_.code) {
        std::vector<std::string> w = words(in.text);
        bool dead = is_def(w) && ((is_temp(w[0]) && !uses[w[0]] && w[2] != "call") ||
                                  (w.size() == 3 && w[2] == w[0]));
        if (dead) { ++st_.removed; changed = true; continue; }
        out.push_back(in);
    }
    f_.code.swap(out);
    return changed;
}

void FuncOpt::run() {
    scan();
    for (int round = 0; round < 10; ++round) {
        bool changed = merge();
        changed |= forward();
        changed |= sweep();
        if (!changed) break;
    }
}

}   // namespace

OptStats optimize(Module &mod) {
    std::map<std::string, std::string> globals;      // "total : int (4) = 0"
    for (const std::string &g : mod.globals) {
        size_t c = g.find(" : "), sz = g.find(" (", c == std::string::npos ? 0 : c);
        if (c != std::string::npos && sz != std::string::npos)
            globals[g.substr(0, c)] = g.substr(c + 3, sz - c - 3);
    }
    OptStats st;
    for (Function *f : mod.funcs) FuncOpt(*f, globals, st).run();
    return st;
}

}
