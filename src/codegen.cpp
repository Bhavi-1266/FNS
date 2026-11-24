#include "codegen.hpp"

namespace fns { Node *first_return_value(Node *n); }

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <sstream>

namespace fns {

namespace {

std::string itos(long v) { return std::to_string(v); }

size_t string_literal_size(const std::string &literal) {
    if (literal.size() < 2) return 1;
    size_t count = 0;
    for (size_t i = 1; i + 1 < literal.size(); ++i) {
        if (literal[i] != '\\') { ++count; continue; }
        ++i;
        if (i + 1 >= literal.size()) break;
        if (literal[i] == 'x') {
            while (i + 1 < literal.size() - 1 && std::isxdigit(static_cast<unsigned char>(literal[i + 1]))) ++i;
        } else if (literal[i] >= '0' && literal[i] <= '7') {
            for (int n = 1; n < 3 && i + 1 < literal.size() - 1 && literal[i + 1] >= '0' && literal[i + 1] <= '7'; ++n) ++i;
        }
        ++count;
    }
    return count + 1; // terminating null byte
}

} // namespace

// ============================================================================
// Emission helpers
// ============================================================================

void CodeGen::emit(const std::string &text, const std::string &note) {
    if (!cur_) return;
    cur_->code.push_back(Instr{text, note});
}

void CodeGen::emit_label(const std::string &l) { emit(l + ":"); }

std::string CodeGen::new_temp() { return "t" + itos(++temp_counter_); }

std::string CodeGen::new_label() { return "L" + itos(++label_counter_); }

void CodeGen::error(int line, const std::string &msg) {
    if (line <= 0) line = cur_line_;
    mod_.errors.push_back("line " + itos(line) + ": " + msg);
}

void CodeGen::unsupported(int line, const std::string &what) {
    mod_.notes.push_back("line " + itos(line) + ": unsupported: " + what);
    emit("; unsupported: " + what);
}

int CodeGen::string_index(const std::string &lit) {
    for (size_t i = 0; i < mod_.strings.size(); ++i)
        if (mod_.strings[i] == lit) return (int)i;
    mod_.strings.push_back(lit);
    return (int)mod_.strings.size() - 1;
}

// ============================================================================
// Types
// ============================================================================

TypeSpec CodeGen::int_type() {
    TypeSpec t;
    t.base = Base::Int;
    return t;
}

// Resolve typedef names, generated tags of anonymous aggregates and constant-expression
// array bounds into a concrete type.
// Comment: >30 lines because it handles typedef chains, class/enum names and bound evaluation.
TypeSpec CodeGen::resolve(const TypeSpec &in) {
    TypeSpec t = in;
    for (int &d : t.dims) {
        if (d > DIM_EXPR_BASE) continue;          // a constant-expression bound
        size_t k = (size_t)(DIM_EXPR_BASE - d);
        auto it = dim_values_.find(k);
        if (it == dim_values_.end()) {
            long v = 0;
            Node *e = k < g_dim_exprs.size() ? g_dim_exprs[k] : nullptr;
            if (!eval_const_int(e, v) || v <= 0) {
                error(e ? e->line : 0, "array size must be a positive integer constant expression");
                v = 1;
            }
            it = dim_values_.emplace(k, (int)v).first;
        }
        d = it->second;
    }
    if (t.name.empty() && t.agg_def && t.agg_def->type && !t.agg_def->type->name.empty())
        t.name = t.agg_def->type->name;   // anonymous struct/union/enum: use the generated tag
    if (t.base == Base::Named) {
        auto td = typedefs_.find(t.name);
        if (td != typedefs_.end()) {
            TypeSpec r = resolve(td->second);
            r.ptr += t.ptr;
            r.ref = r.ref || t.ref;
            std::vector<int> dims = t.dims;
            dims.insert(dims.end(), r.dims.begin(), r.dims.end());
            r.dims = dims;
            r.is_static = t.is_static;
            r.is_const = r.is_const || t.is_const;
            return r;
        }
        auto ci = classes_.find(t.name);
        if (ci != classes_.end()) {
            t.base = ci->second->kind;
        } else if (enums_.count(t.name)) {
            t.base = Base::Enum;
        }
    }
    return t;
}

bool CodeGen::is_pointer(const TypeSpec &t) const { return (t.dims.empty() && t.ptr > 0) || t.decayed; }
bool CodeGen::is_array(const TypeSpec &t) const { return !t.dims.empty(); }

bool CodeGen::is_float(const TypeSpec &t) const {
    return t.dims.empty() && t.ptr == 0 && (t.base == Base::Float || t.base == Base::Double);
}

bool CodeGen::is_aggregate(const TypeSpec &t) const {
    return !t.ref && t.dims.empty() && t.ptr == 0 &&
           (t.base == Base::Struct || t.base == Base::Class || t.base == Base::Union);
}

ClassInfo *CodeGen::class_of(const TypeSpec &t) { return class_of(t.name); }

ClassInfo *CodeGen::class_of(const std::string &name) {
    if (name.empty()) return nullptr;
    auto it = classes_.find(name);
    if (it != classes_.end()) return it->second;
    auto td = typedefs_.find(name);
    if (td != typedefs_.end() && td->second.ptr == 0 && td->second.dims.empty()) return class_of(resolve(td->second));
    return nullptr;
}

// Size in bytes of a type on the MIPS32 target (char 1, short 2, int/long/pointer 4,
// double 8, arrays, structs/classes/unions from their layout).
// Comment: >30 lines because every base type has its own case.
int CodeGen::size_of(const TypeSpec &t) {
    if (t.decayed) return 4;
    if (!t.dims.empty()) {
        TypeSpec e = t;
        e.dims.erase(e.dims.begin());
        int n = t.dims[0] < 0 ? 0 : t.dims[0];
        return n * size_of(e);
    }
    if (t.ptr > 0 || t.ref) return 4;
    switch (t.base) {
        case Base::Void: return 0;
        case Base::Bool:
        case Base::Char: return 1;
        case Base::Short: return 2;
        case Base::Int:
        case Base::Long:
        case Base::Float:
        case Base::Enum:
        case Base::Func:
        case Base::Lambda:
        case Base::Auto: return 4;
        case Base::Double: return 8;
        case Base::Named: {
            TypeSpec r = resolve(t);
            if (r.base == Base::Named) {
                error(0, "unknown type '" + t.name + "'");
                return 4;
            }
            return size_of(r);
        }
        case Base::Struct:
        case Base::Class:
        case Base::Union: {
            ClassInfo *ci = class_of(t);
            return ci ? ci->size : 4;
        }
    }
    return 4;
}

int CodeGen::align_of(const TypeSpec &t) {
    if (!t.dims.empty()) return align_of(elem_type(t));
    if (t.ptr > 0 || t.ref) return 4;
    if (is_aggregate(t)) return 4;
    int s = size_of(t);
    return s >= 4 ? 4 : (s < 1 ? 1 : s);
}

TypeSpec CodeGen::elem_type(const TypeSpec &t) {
    TypeSpec e = t;
    e.ref = false;
    e.decayed = false;
    if (!e.dims.empty()) {
        e.dims.erase(e.dims.begin());
    } else if (e.ptr > 0) {
        e.ptr--;
    }
    return e;
}

TypeSpec CodeGen::pointer_to(const TypeSpec &t) {
    TypeSpec p = t;
    p.ref = false;
    p.decayed = false;
    if (!p.dims.empty()) {
        p.dims.erase(p.dims.begin());
    }
    p.ptr++;
    return p;
}

TypeSpec CodeGen::promote(const TypeSpec &a, const TypeSpec &b) {
    auto rank = [&](const TypeSpec &t) {
        if (is_pointer(t) || is_array(t)) return 6;
        switch (t.base) {
            case Base::Double: return 5;
            case Base::Float: return 4;
            case Base::Long: return 3;
            default: return 2;
        }
    };
    TypeSpec r = rank(a) >= rank(b) ? a : b;
    r.ref = false;
    if (is_array(r)) r = pointer_to(r);
    if (!is_pointer(r) && !is_float(r) && r.base != Base::Long) r = int_type();
    if (r.base == Base::Int && (a.is_unsigned || b.is_unsigned)) r.is_unsigned = true;
    return r;
}

std::string CodeGen::type_str(const TypeSpec &in) {
    TypeSpec t = resolve(in);
    if (t.decayed) return type_str(pointer_to(t));
    std::string s;
    if (t.is_unsigned) s += "unsigned ";
    switch (t.base) {
        case Base::Void: s += "void"; break;
        case Base::Bool: s += "bool"; break;
        case Base::Char: s += "char"; break;
        case Base::Short: s += "short"; break;
        case Base::Int: s += "int"; break;
        case Base::Long: s += "long"; break;
        case Base::Float: s += "float"; break;
        case Base::Double: s += "double"; break;
        case Base::Auto: s += "auto"; break;
        case Base::Named: s += t.name; break;
        case Base::Struct: s += "struct " + t.name; break;
        case Base::Union: s += "union " + t.name; break;
        case Base::Enum: s += "enum " + t.name; break;
        case Base::Class: s += t.name; break;
        case Base::Func: s += "fn"; break;
        case Base::Lambda: s += "lambda"; break;
    }
    for (int d : t.dims) s += d < 0 ? "[]" : "[" + itos(d) + "]";
    for (int i = 0; i < t.ptr; ++i) s += "*";
    if (t.ref) s += t.rref ? "&&" : "&";
    return s;
}

// ============================================================================
// Symbols
// ============================================================================

void CodeGen::push_scope() {
    Scope s;
    s.func_depth = (int)fn_stack_.size();
    s.id = ++scope_ids_;
    scopes_.push_back(s);
}

void CodeGen::pop_scope() { scopes_.pop_back(); }

// The ids of the current function's open scopes, outermost first.
std::vector<int> CodeGen::scope_chain() const {
    std::vector<int> chain;
    for (size_t i = fn_scope_depth_; i < scopes_.size(); ++i) chain.push_back(scopes_[i].id);
    return chain;
}

// Insert, before each recorded goto, the destructor calls of the blocks it leaves:
// the scopes of the goto that are not also scopes of its label (innermost first).
void CodeGen::patch_gotos(Function *f) {
    for (auto it = goto_fixes_.rbegin(); it != goto_fixes_.rend(); ++it) {
        auto lc = label_chains_.find(it->label);
        if (lc == label_chains_.end()) continue;
        size_t common = 0;
        while (common < it->chain.size() && common < lc->second.size() && it->chain[common] == lc->second[common])
            ++common;
        std::vector<Instr> calls;
        for (size_t level = it->chain.size(); level-- > common;)
            calls.insert(calls.end(), it->cleanup[level].begin(), it->cleanup[level].end());
        f->code.insert(f->code.begin() + (long)it->at, calls.begin(), calls.end());
    }
}

Symbol *CodeGen::lookup(const std::string &name) {
    for (int i = (int)scopes_.size() - 1; i >= 0; --i) {
        auto it = scopes_[i].syms.find(name);
        if (it != scopes_[i].syms.end()) return &it->second;
    }
    return nullptr;
}

// User names that look like IR temporaries (t1) or string labels (str0)
// would be ambiguous in the IR; they get a "_v" suffix.
static bool reserved_ir_name(const std::string &name) {
    size_t p = 0;
    if (name.size() > 1 && name[0] == 't') p = 1;
    else if (name.size() > 3 && name.compare(0, 3, "str") == 0) p = 3;
    else return name == "__va_args";
    for (size_t i = p; i < name.size(); ++i)
        if (!isdigit((unsigned char)name[i])) return false;
    return true;
}

std::string CodeGen::unique_local(const std::string &raw) {
    std::string name = reserved_ir_name(raw) ? raw + "_v" : raw;
    if (used_names_.empty()) return name;
    std::set<std::string> &used = used_names_.back();
    std::string n = name;
    int k = 0;
    while (used.count(n)) n = name + "_" + itos(++k);
    used.insert(n);
    return n;
}

Symbol &CodeGen::declare(const std::string &name, const TypeSpec &t, Symbol::Kind kind) {
    if (scopes_.back().syms.count(name))
        error(0, "redeclaration of '" + name + "'");
    Symbol s;
    s.kind = kind;
    s.name = name;
    s.irname = scopes_.size() <= 1 ? (reserved_ir_name(name) ? name + "_v" : name) : unique_local(name);
    s.type = t;
    s.func_depth = scopes_.back().func_depth;
    s.is_global = scopes_.size() <= 1;
    scopes_.back().syms[name] = s;
    return scopes_.back().syms[name];
}

FuncInfo *CodeGen::find_function(const std::string &name) {
    auto it = functions_.find(name);
    return it == functions_.end() ? nullptr : it->second;
}

FuncInfo *CodeGen::find_method(ClassInfo *ci, const std::string &name) {
    for (ClassInfo *c = ci; c; c = c->base) {
        auto it = c->methods.find(name);
        if (it != c->methods.end()) return it->second;
    }
    return nullptr;
}

const Field *CodeGen::find_field(ClassInfo *ci, const std::string &name) {
    if (!ci) return nullptr;
    for (const Field &f : ci->fields)
        if (f.name == name) return &f;
    return nullptr;
}

// Access of a member declared in `owner` with `access` when it is named in the derived
// class `naming`: a private base makes it private (or hides an already private member,
// 3 = inaccessible), a protected base makes public members protected.
int CodeGen::access_in(ClassInfo *naming, ClassInfo *owner, int access) const {
    std::vector<ClassInfo *> path;
    for (ClassInfo *c = naming; c && c != owner; c = c->base) path.push_back(c);
    for (auto it = path.rbegin(); it != path.rend(); ++it) {
        if (access == 1 || access == 3) return 3;
        if ((*it)->base_access != 0) access = (*it)->base_access;
    }
    return access;
}

// Whether the current code may use a member whose access, as a member of `naming`, is `access`.
bool CodeGen::allowed(int access, ClassInfo *naming, ClassInfo *object_type) const {
    if (access == 0) return true;
    if (access == 3 || !cur_class_) return false;
    if (access == 1) return cur_class_ == naming;
    if (!derives_from(cur_class_, naming)) return false;
    return !object_type || cur_class_ == naming || derives_from(object_type, cur_class_);
}

// C++ member access: the member is usable if it is accessible as a member of the naming
// class, or of a base on the way to `owner` that is itself accessible from the naming class.
bool CodeGen::can_access(int access, ClassInfo *owner, ClassInfo *object_type) const {
    if (!owner) return access == 0;
    ClassInfo *naming = object_type ? object_type : cur_class_;
    if (!naming || !derives_from(naming, owner)) naming = owner;
    for (ClassInfo *c = naming; c; c = c->base) {
        if (allowed(access_in(c, owner, access), c, object_type) &&
            (c == naming || allowed(access_in(naming, c, 0), naming, nullptr)))
            return true;
        if (c == owner) break;
    }
    return false;
}

// Derived-to-base conversion (pointer, reference) needs an accessible base.
bool CodeGen::base_accessible(int line, ClassInfo *derived, ClassInfo *base) {
    if (!derived || !base || derived == base || can_access(0, base, derived)) return true;
    error(line, "'" + base->name + "' is an inaccessible base of '" + derived->name + "'");
    return false;
}

FuncInfo *CodeGen::external(const std::string &name) {
    FuncInfo *fi = find_function(name);
    if (fi) return fi;
    fi = new FuncInfo;
    fi->name = fi->irname = name;
    fi->is_external = true;
    fi->variadic = true;
    fi->ret = int_type();
    static const char *ptr_returning[] = {"malloc", "calloc", "realloc", "fopen", "strcpy",
                                          "strcat", "memcpy", "memset", "fgets", "__fns_new", nullptr};
    for (int i = 0; ptr_returning[i]; ++i) {
        if (name == ptr_returning[i]) {
            fi->ret.base = Base::Void;
            fi->ret.ptr = 1;
        }
    }
    if (name == "free" || name == "exit") fi->ret.base = Base::Void;
    functions_[name] = fi;
    mod_.externs.push_back(name);
    return fi;
}

// ============================================================================
// Values
// ============================================================================

std::string CodeGen::load(const std::string &addr, const TypeSpec &t) {
    std::string r = new_temp();
    emit(r + " = *" + addr, type_str(t));
    return r;
}

std::string CodeGen::offset_addr(const std::string &base, int off, const std::string &note) {
    if (off == 0) return base;
    std::string r = new_temp();
    emit(r + " = " + base + " + " + itos(off), note);
    return r;
}

std::string CodeGen::rvalue(const Val &v) {
    switch (v.k) {
        case Val::RVal: return v.place;
        case Val::Var:
            if (v.type.decayed) return v.place;
            if (is_array(v.type) || is_aggregate(v.type)) {
                std::string r = new_temp();
                emit(r + " = &" + v.place, type_str(pointer_to(v.type)));
                return r;
            }
            return v.place;
        case Val::Addr:
            if (v.bit_width) return load_bits(v);
            if (is_array(v.type) || is_aggregate(v.type)) return v.place;
            return load(v.place, v.type);
        case Val::Func: return v.fn->irname;
        case Val::Lambda: return v.lam->fn->irname;
        default: return v.place.empty() ? "0" : v.place;
    }
}

std::string CodeGen::addr_of(const Val &v) {
    switch (v.k) {
        case Val::Var: {
            if (v.type.decayed) return v.place;
            std::string r = new_temp();
            emit(r + " = &" + v.place, type_str(pointer_to(v.type)));
            return r;
        }
        case Val::Addr:
            if (v.bit_width) error(cur_line_, "cannot take the address of a bit-field");
            return v.place;
        case Val::Func: return v.fn->irname;
        default: return v.place;
    }
}

void CodeGen::store(const Val &lhs, const std::string &v, const TypeSpec &vt) {
    (void)vt;
    if (lhs.bit_width) {
        store_bits(lhs, v);
    } else if (lhs.k == Val::Var) {
        emit(lhs.place + " = " + v, type_str(lhs.type));
    } else if (lhs.k == Val::Addr) {
        emit("*" + lhs.place + " = " + v, type_str(lhs.type));
    } else {
        error(0, "assignment to non-lvalue");
    }
}

// Read a bit-field: load its unit, shift the field to the top, then back down
// (arithmetic shift for a signed field, so the value is sign-extended).
std::string CodeGen::load_bits(const Val &v) {
    std::string unit = load(v.place, v.type);
    int up = 32 - v.bit_offset - v.bit_width;
    std::string x = up ? emit_binop(unit, "<<", itos(up), int_type()) : unit;
    TypeSpec rt = int_type();
    rt.is_unsigned = v.type.is_unsigned;
    return emit_binop(x, ">>", itos(32 - v.bit_width), rt);
}

// Write a bit-field: keep the unit's other bits and insert the low bits of `v`.
void CodeGen::store_bits(const Val &lhs, const std::string &v) {
    unsigned mask = (lhs.bit_width >= 32 ? 0xffffffffu : (1u << lhs.bit_width) - 1) << lhs.bit_offset;
    std::string kept = emit_binop(load(lhs.place, lhs.type), "&", itos((int)~mask), int_type());
    std::string part = emit_binop(v, "<<", itos(lhs.bit_offset), int_type());
    part = emit_binop(part, "&", itos((int)mask), int_type());
    emit("*" + lhs.place + " = " + emit_binop(kept, "|", part, int_type()), type_str(lhs.type));
}

// The member `f` of the object whose member address is `addr`, as an assignable value.
Val CodeGen::field_val(const std::string &addr, const Field &f) {
    Val v;
    v.k = Val::Addr;
    v.place = addr;
    v.type = f.type;
    v.bit_width = f.bit_width;
    v.bit_offset = f.bit_offset;
    return v;
}

std::string CodeGen::convert(const std::string &place, const TypeSpec &from, const TypeSpec &to) {
    TypeSpec f = resolve(from), t = resolve(to);
    if (t.base == Base::Auto || t.base == Base::Void) return place;
    if (f.base == t.base && f.name == t.name && f.ptr == t.ptr && f.ref == t.ref &&
        f.dims == t.dims && f.is_unsigned == t.is_unsigned)
        return place;
    std::string r = new_temp();
    emit(r + " = (" + type_str(t) + ") " + place, type_str(t));
    return r;
}

std::string CodeGen::emit_binop(const std::string &a, const std::string &op, const std::string &b,
                                const TypeSpec &t) {
    std::string r = new_temp();
    emit(r + " = " + a + " " + op + " " + b, type_str(t));
    return r;
}

// ============================================================================
// Module-level passes
// ============================================================================

// Generate the whole module: pass 1 declares every top-level item, pass 2
// generates the function bodies, then __global_fini (object destruction at
// exit) and __global_init (dynamic global initialisation) are wired into main.
// Comment: >30 lines because it assembles the module-level functions.
void CodeGen::generate(Node *program) {
    push_scope();
    ginit_ = new Function;
    ginit_->name = "__global_init";
    ginit_->ret = "void";
    used_names_.push_back({});

    cur_ = ginit_;
    for (Node *n : program->kids) declare_toplevel(n);
    cur_ = nullptr;

    gen_pending_bodies();

    if (!static_objs_.empty()) {
        // __global_fini: destroy global and static-local objects in reverse order
        Function *fini = new Function;
        fini->name = "__global_fini";
        fini->ret = "void";
        Function *saved = cur_;
        cur_ = fini;
        int saved_tc = temp_counter_;
        temp_counter_ = 0;
        for (auto it = static_objs_.rbegin(); it != static_objs_.rend(); ++it) {
            size_t br = it->name.find('[');
            std::string a = new_temp();
            emit(a + " = &" + it->name.substr(0, br), "ptr");
            if (br != std::string::npos) {
                for_each_element(a, it->cls, std::atoi(it->name.c_str() + br + 1), true);
            } else {
                emit("param " + a);
                emit("call " + it->cls->dtor->irname + ", 1");
            }
        }
        emit("return");
        cur_ = saved;
        temp_counter_ = saved_tc;
        mod_.funcs.push_back(fini);
        external("__fns_atexit");
        uses_atexit_ = true;
    }
    if (uses_atexit_) {
        // static objects are destroyed by the library's exit list (registered as they are
        // constructed; the globals' __global_fini first): run it before main returns
        external("__fns_run_atexit");
        for (Function *f : mod_.funcs) {
            if (f->name != "main") continue;
            for (size_t i = 0; i < f->code.size(); ++i)
                if (f->code[i].text.rfind("return", 0) == 0) {
                    f->code.insert(f->code.begin() + i, Instr{"call __fns_run_atexit, 0", ""});
                    ++i;
                }
            if (!static_objs_.empty())
                f->code.insert(f->code.begin(), {Instr{"param __global_fini", ""}, Instr{"param 0", ""},
                                                 Instr{"call __fns_atexit, 2", ""}});
        }
    }
    if (!ginit_->code.empty()) {
        ginit_->code.push_back(Instr{"return", ""});
        mod_.funcs.insert(mod_.funcs.begin(), ginit_);
        for (Function *f : mod_.funcs) {
            if (f->name == "main") {
                f->code.insert(f->code.begin(), Instr{"call __global_init, 0", ""});
            }
        }
    }
}

// Pass 1 over one top-level item: register types, functions (including out-of-class
// member definitions), globals and typedefs before any body is generated.
// Comment: >30 lines because it dispatches every kind of top-level declaration.
void CodeGen::declare_toplevel(Node *n) {
    if (!n) return;
    switch (n->kind) {
        case NK::Preproc:
        case NK::Empty:
            return;
        case NK::AggDef:
            process_aggregate(n);
            return;
        case NK::EnumDef:
            process_enum(n);
            return;
        case NK::Typedef:
            typedefs_[n->str] = *n->type;
            if (n->type->agg_def) declare_toplevel(n->type->agg_def);
            return;
        case NK::FuncDef:
        case NK::FuncDecl:
            if (!n->str2.empty()) {            // R Class::method(...) { ... } outside the class
                ClassInfo *ci = class_of(n->str2);
                if (!ci) error(n->line, "'" + n->str2 + "' is not a class");
                else declare_function(n, ci);
                return;
            }
            declare_function(n, nullptr);
            return;
        case NK::DeclList:
            for (Node *d : n->kids) declare_toplevel(d);
            return;
        case NK::VarDecl:
            if (n->flags & F_STATIC_DEF) define_static_member(n);
            else declare_global_var(n, "");
            return;
        default:
            return;
    }
}

// `int Counter::count = 0;` outside the class body: attach the initializer to the
// global that the class layout already created for the static member.
void CodeGen::define_static_member(Node *n) {
    if (n->line > 0) cur_line_ = n->line;
    ClassInfo *ci = class_of(n->str2);
    const Field *f = ci ? find_field(ci, n->str) : nullptr;
    if (!f || !f->is_static || f->owner != ci) {
        error(n->line, "'" + n->str2 + "::" + n->str + "' is not a static data member");
        return;
    }
    if (!same_type(resolve(*n->type), f->type)) {
        error(n->line, "definition of '" + n->str2 + "::" + n->str + "' does not match its declaration");
        return;
    }
    if (n->kids.empty()) return;
    Node *init = n->kids[0];
    std::string prefix = f->irname + " : ";
    for (std::string &g : mod_.globals) {
        if (g.rfind(prefix, 0) != 0) continue;
        if (g.find(" = ") != std::string::npos) {
            error(n->line, "redefinition of '" + n->str2 + "::" + n->str + "'");
            return;
        }
        long value;
        if (!is_aggregate(f->type) && f->type.dims.empty() && eval_const_int(init, value)) {
            g += " = " + itos(value);
            return;
        }
        if (init->kind == NK::FloatLit) {
            g += " = " + gen_literal(init).place;
            return;
        }
        Symbol s;
        s.name = n->str;
        s.irname = f->irname;
        s.type = f->type;
        s.is_global = true;
        Function *saved = cur_;
        cur_ = ginit_;
        gen_var_init(s, f->type, init);
        cur_ = saved;
        return;
    }
}

// Evaluate an integer constant expression (literals, enumerators, const ints, sizeof,
// scoped enumerators, unary/binary/conditional operators). Returns false if not constant.
// Comment: >30 lines because it covers every operator allowed in a constant expression.
bool CodeGen::eval_const_int(Node *n, long &value) {
    if (!n) return false;
    if (n->kind == NK::IntLit) {
        std::string text = n->str;
        while (!text.empty() && (text.back() == 'u' || text.back() == 'U' || text.back() == 'l' || text.back() == 'L')) text.pop_back();
        char *end = nullptr;
        value = std::strtol(text.c_str(), &end, 0);
        return end && *end == '\0';
    }
    if (n->kind == NK::BoolLit) { value = n->str == "1"; return true; }
    if (n->kind == NK::CharLit) {
        Val c = gen_literal(n);
        value = c.cval;
        return true;
    }
    if (n->kind == NK::SizeofType && n->type) { value = size_of(resolve(*n->type)); return true; }
    if (n->kind == NK::Scope && !n->kids.empty() && n->kids[0]->kind == NK::TypeName &&
        enums_.count(n->kids[0]->str)) {                 // Color::Red
        Symbol *e = lookup(n->str);
        if (!e || e->kind != Symbol::EnumConst || e->type.name != n->kids[0]->str) return false;
        value = e->value;
        return true;
    }
    if (n->kind == NK::Ident) {
        Symbol *s = lookup(n->str);
        if (!s || (s->kind != Symbol::EnumConst && !s->const_int)) return false;
        value = s->value;
        return true;
    }
    if (n->kind == NK::Unary && n->kids.size() == 1) {
        long a;
        if (!eval_const_int(n->kids[0], a)) return false;
        if (n->str == "+") value = a;
        else if (n->str == "-") value = -a;
        else if (n->str == "~") value = ~a;
        else if (n->str == "!") value = !a;
        else return false;
        return true;
    }
    if (n->kind == NK::Cond && n->kids.size() == 3) {
        long cond;
        return eval_const_int(n->kids[0], cond) && eval_const_int(n->kids[cond ? 1 : 2], value);
    }
    if (n->kind != NK::Binary || n->kids.size() != 2) return false;
    long a, b;
    if (!eval_const_int(n->kids[0], a) || !eval_const_int(n->kids[1], b)) return false;
    if (n->str == "+") value = a + b;
    else if (n->str == "-") value = a - b;
    else if (n->str == "*") value = a * b;
    else if (n->str == "/") { if (!b) return false; value = a / b; }
    else if (n->str == "%") { if (!b) return false; value = a % b; }
    else if (n->str == "<<") { if (b < 0 || b >= 32) return false; value = a << b; }
    else if (n->str == ">>") { if (b < 0 || b >= 32) return false; value = a >> b; }
    else if (n->str == "&") value = a & b;
    else if (n->str == "|") value = a | b;
    else if (n->str == "^") value = a ^ b;
    else if (n->str == "==") value = a == b;
    else if (n->str == "!=") value = a != b;
    else if (n->str == "<") value = a < b;
    else if (n->str == ">") value = a > b;
    else if (n->str == "<=") value = a <= b;
    else if (n->str == ">=") value = a >= b;
    else if (n->str == "&&") value = a && b;
    else if (n->str == "||") value = a || b;
    else return false;
    return true;
}

void CodeGen::process_enum(Node *n) {
    // `typedef enum {...} E;` reaches here twice for the same body
    if (!enum_nodes_done_.insert(n).second) return;
    std::string name = n->str.empty() ? "anon_enum_" + itos(++anon_counter_) : n->str;
    if (n->str.empty() && n->type) n->type->name = name;
    enums_.insert(name);
    long v = 0;
    for (Node *e : n->kids) {
        if (e->line > 0) cur_line_ = e->line;
        if (!e->kids.empty() && !eval_const_int(e->kids[0], v))
            error(e->line, "enumerator value must be an integer constant expression");
        TypeSpec t;
        t.base = Base::Enum;
        t.name = name;
        Symbol &s = declare(e->str, t, Symbol::EnumConst);
        s.value = v++;
    }
}

void CodeGen::process_aggregate(Node *n) {
    std::string name = n->str.empty() ? "anon_" + itos(++anon_counter_) : n->str;
    ClassInfo *ci = classes_.count(name) ? classes_[name] : new ClassInfo;
    if (ci->laid_out) {
        // `typedef struct Node {...} Node;` reaches here twice for the same body
        if (ci->def_line != n->line) error(n->line, "redefinition of '" + name + "'");
        return;
    }
    ci->laid_out = true;
    ci->name = name;
    ci->kind = n->type->base;
    ci->def_line = n->line;
    classes_[name] = ci;
    if (n->str.empty()) n->type->name = name;
    layout_class(ci, n);
}

// Lay out a struct/union/class: inherit base fields and vtable, place the vptr, assign
// field offsets and access levels, declare methods, and create implicit ctor/dtor if needed.
// Comment: >30 lines because it implements the whole object layout model.
void CodeGen::layout_class(ClassInfo *ci, Node *def) {
    if (def->line > 0) cur_line_ = def->line;
    if (!def->str2.empty()) {
        auto b = classes_.find(def->str2);
        if (b != classes_.end()) ci->base = b->second, ci->base_access = def->access;
        else error(def->line, "unknown base class " + def->str2);
    }

    int off = 0;
    if (ci->base) {
        ci->fields = ci->base->fields;
        ci->vtable = ci->base->vtable;
        ci->has_vptr = ci->base->has_vptr;
        ci->vptr_offset = ci->base->vptr_offset;
        off = ci->base->size;
    }

    bool any_virtual = false;
    for (Node *m : def->kids) {
        if ((m->kind == NK::FuncDef || m->kind == NK::FuncDecl) && (m->flags & F_VIRTUAL)) any_virtual = true;
        if ((m->kind == NK::FuncDef || m->kind == NK::FuncDecl) && ci->base) {
            FuncInfo *base_method = (m->flags & F_DTOR) ? ci->base->dtor : find_method(ci->base, m->str);
            if (base_method && base_method->is_virtual) any_virtual = true;
        }
    }
    if (any_virtual && !ci->has_vptr) {
        ci->has_vptr = true;
        off = (off + 3) & ~3;
        ci->vptr_offset = off;
        off += 4;
    }

    // Fields retain the access section and declaring class, including when inherited.
    int current_access = ci->kind == Base::Class ? 1 : 0;
    int bitpos = -1;                    // bit position while consecutive bit-fields are packed
    for (Node *m : def->kids) {
        if (m->kind == NK::Access) {
            current_access = m->access;
            continue;
        }
        if (m->kind == NK::AggDef) { process_aggregate(m); continue; }   // nested type definition
        if (m->kind == NK::EnumDef) { process_enum(m); continue; }
        if (m->kind != NK::DeclList) continue;
        for (Node *d : m->kids) {
            if (d->kind == NK::AggDef) { process_aggregate(d); continue; }  // struct {...} member;
            if (d->kind == NK::EnumDef) { process_enum(d); continue; }
            if (d->kind != NK::VarDecl) continue;
            if (d->flags & F_BITFIELD) { layout_bitfield(ci, d, current_access, off, bitpos); continue; }
            if (bitpos >= 0 && !(d->flags & F_STATIC)) { off = (bitpos + 7) / 8; bitpos = -1; }
            Field f;
            f.name = d->str;
            f.type = resolve(*d->type);
            f.access = current_access;
            f.owner = ci;
            for (const Field &existing : ci->fields)
                if (existing.owner == ci && existing.name == f.name)
                    error(d->line, "duplicate member '" + f.name + "' in " + ci->name);
            if (is_aggregate(f.type) && class_of(f.type) == ci)
                error(d->line, "member '" + f.name + "' has incomplete type '" + ci->name + "'");
            else if (!f.type.dims.empty() && is_aggregate(elem_type(f.type)) && class_of(elem_type(f.type)) == ci)
                error(d->line, "member '" + f.name + "' has incomplete type '" + ci->name + "'");
            if (f.type.base == Base::Void && f.type.ptr == 0 && f.type.dims.empty() && !f.type.ref)
                error(d->line, "member '" + f.name + "' has incomplete type 'void'");
            f.is_static = (d->flags & F_STATIC) != 0;
            f.irname = ci->name + "_" + f.name;
            if (!f.is_static && !d->kids.empty()) f.init = d->kids[0];
            if (f.is_static) {
                declare_global_var(d, ci->name + "_", false);
            } else if (ci->kind == Base::Union) {
                f.offset = 0;
                ci->size = std::max(ci->size, size_of(f.type));
            } else {
                int a = align_of(f.type);
                off = (off + a - 1) / a * a;
                f.offset = off;
                off += size_of(f.type);
            }
            ci->fields.push_back(f);
        }
    }
    if (bitpos >= 0) off = (bitpos + 7) / 8;
    if (ci->kind != Base::Union) ci->size = (off + 3) & ~3;
    else ci->size = (ci->size + 3) & ~3;
    if (ci->size == 0) ci->size = 4;

    // methods
    current_access = ci->kind == Base::Class ? 1 : 0;
    for (Node *m : def->kids) {
        if (m->kind == NK::Access) {
            current_access = m->access;
            continue;
        }
        if (m->kind != NK::FuncDef && m->kind != NK::FuncDecl) continue;
        m->access = current_access;
        declare_function(m, ci);
    }

    // implicit default constructor when the object needs runtime setup
    bool needs_ctor = ci->has_vptr || (ci->base && ci->base->ctor);
    for (const Field &f : ci->fields) {
        if (f.is_static) continue;
        if (f.type.ref) needs_ctor = true;
        if (f.init && f.owner == ci) needs_ctor = true;
        ClassInfo *fc = is_aggregate(f.type) ? class_of(f.type) : nullptr;
        if (fc && fc->ctor) needs_ctor = true;
    }
    if (!ci->ctor && needs_ctor) {
        FuncInfo *fi = new FuncInfo;
        fi->name = ci->name;
        fi->irname = ci->name + "_" + ci->name;
        fi->ret.base = Base::Void;
        fi->is_ctor = true;
        fi->cls = ci;
        fi->access = 0; // implicitly-declared constructors are public in this subset
        fi->defined = true;
        ci->ctor = fi;
        ci->methods[ci->name] = fi;
        pending_.push_back(fi);
    }
    bool needs_dtor = ci->base && ci->base->dtor;
    for (const Field &f : ci->fields) {
        if (f.is_static) continue;
        ClassInfo *fc = is_aggregate(f.type) ? class_of(f.type) : nullptr;
        if (fc && fc->dtor) needs_dtor = true;
    }
    if (!ci->dtor && needs_dtor) {
        FuncInfo *fi = new FuncInfo;
        fi->name = "~" + ci->name;
        fi->irname = ci->name + "__dtor";
        fi->ret.base = Base::Void;
        fi->is_dtor = true;
        fi->cls = ci;
        fi->access = 0;
        if (ci->base && ci->base->dtor && ci->base->dtor->is_virtual) {
            fi->is_virtual = true;
            fi->vindex = ci->base->dtor->vindex;
            if (fi->vindex >= 0) ci->vtable[fi->vindex] = fi;
        }
        fi->defined = true;
        ci->dtor = fi;
        ci->methods[fi->name] = fi;
        pending_.push_back(fi);
    }
    if (ci->has_vptr) {
        std::string line = "vtable_" + ci->name + ": ";
        for (size_t i = 0; i < ci->vtable.size(); ++i) {
            if (i) line += ", ";
            FuncInfo *f = ci->vtable[i];
            line += f->is_pure ? "__pure_virtual" : f->irname;
        }
        if (ci->vtable.empty()) line += "(empty)";
        mod_.vtables.push_back(line);
    }
}

// Declare or define a function, method, constructor or destructor: pair prototypes with
// definitions, create overloads, attach out-of-class definitions, assign vtable slots,
// record default arguments, and check conflicting redefinitions.
// Comment: >30 lines because of overloading, virtual dispatch and C/C++ differences.
void CodeGen::declare_function(Node *n, ClassInfo *cls) {
    std::string name = n->str;
    bool is_ctor = (n->flags & F_CTOR) != 0;
    bool is_dtor = (n->flags & F_DTOR) != 0;
    std::string irname = name;
    if (cls) irname = is_dtor ? cls->name + "__dtor" : cls->name + "_" + name;

    bool out_of_class = cls && !n->str2.empty();
    // Signature of this declaration, used to pair a prototype with its
    // definition and to tell overloads apart.
    std::vector<TypeSpec> sig;
    bool sig_variadic = false;
    for (Node *p : n->kids[0]->kids) {
        if (p->kind == NK::Ellipsis) { sig_variadic = true; continue; }
        TypeSpec pt = decay_param(resolve(open_first_dim(*p->type)));
        if (pt.base == Base::Void && pt.ptr == 0 && p->str.empty()) continue;
        sig.push_back(pt);
    }
    auto same_sig = [&](FuncInfo *c) {
        if (c->params.size() != sig.size() || c->variadic != sig_variadic) return false;
        for (size_t i = 0; i < sig.size(); ++i)
            if (!same_type(c->params[i], sig[i])) return false;
        return true;
    };

    FuncInfo *head = nullptr;
    if (cls) {
        auto it = cls->methods.find(is_dtor ? "~" + name : name);
        if (it != cls->methods.end()) head = it->second;
    } else {
        head = find_function(name);
        if (head && head->is_external) {
            head->is_external = false;
            mod_.externs.erase(std::remove(mod_.externs.begin(), mod_.externs.end(), name), mod_.externs.end());
        }
    }
    FuncInfo *fi = nullptr;
    FuncInfo *overload_of = nullptr;     // set when this declaration starts a new overload
    if (head) {
        for (FuncInfo *c = head; c; c = c->next_overload)
            if (same_sig(c)) { fi = c; break; }
        if (!fi && (is_dtor || head->is_lib))
            fi = head;   // destructor / user replacement of a library function
        if (!fi && head->is_external) fi = head;
        if (!fi && !cplusplus_ && !cls) fi = head;   // C has no overloading: diagnosed as a conflict below
        if (!fi) overload_of = head;
    }
    if (out_of_class && !fi) {
        error(n->line, "no member function '" + name + "' with this signature is declared in class '" +
                           cls->name + "'");
        return;
    }
    if (!fi) {
        fi = new FuncInfo;
        fi->name = name;
        fi->irname = irname;
        fi->cls = cls;
        fi->is_ctor = is_ctor;
        fi->is_dtor = is_dtor;
        fi->is_static = cls && !is_ctor && !is_dtor && (n->flags & F_STATIC);
        if (n->type) fi->ret = resolve(*n->type);
        else fi->ret.base = Base::Void;
        for (Node *p : n->kids[0]->kids) {
            if (p->kind == NK::Ellipsis) { fi->variadic = true; continue; }
            TypeSpec pt = decay_param(resolve(open_first_dim(*p->type)));
            if (pt.base == Base::Void && pt.ptr == 0 && p->str.empty()) continue;
            fi->params.push_back(pt);
            fi->pnames.push_back(p->str.empty() ? "arg" + itos(fi->pnames.size()) : p->str);
        }
        if (overload_of) {
            int k = 1;
            FuncInfo *last = overload_of;
            while (last->next_overload) { last = last->next_overload; ++k; }
            last->next_overload = fi;
            fi->irname = irname + "__" + itos(k);
        }
        if (cls) {
            if (!overload_of) cls->methods[is_dtor ? "~" + name : name] = fi;
            if (is_ctor && !overload_of) cls->ctor = fi;
            if (is_dtor) cls->dtor = fi;
            FuncInfo *base_m = cls->base
                ? (is_dtor ? cls->base->dtor : find_method(cls->base, name))
                : nullptr;
            if (base_m && !is_dtor) {            // override only the base overload with this signature
                FuncInfo *match = nullptr;
                for (FuncInfo *b = base_m; b; b = b->next_overload)
                    if (b->params.size() == fi->params.size()) {
                        bool same = true;
                        for (size_t i = 0; i < fi->params.size(); ++i)
                            if (!same_type(b->params[i], fi->params[i])) same = false;
                        if (same) { match = b; break; }
                    }
                base_m = match;
            }
            if ((n->flags & F_VIRTUAL) || (base_m && base_m->is_virtual)) {
                fi->is_virtual = true;
                if (base_m && base_m->vindex >= 0) {
                    fi->vindex = base_m->vindex;
                    cls->vtable[fi->vindex] = fi;
                } else {
                    fi->vindex = (int)cls->vtable.size();
                    cls->vtable.push_back(fi);
                }
            }
        } else {
            if (!overload_of) functions_[name] = fi;
            if (n->kind == NK::FuncDecl && lib_protos_.count(name) && !overload_of) fi->is_lib = true;
        }
    }
    if (cls && !out_of_class) fi->access = n->access;
    {   // default arguments (usually on the prototype, possibly on the definition)
        size_t k = 0;
        for (Node *p : n->kids[0]->kids) {
            if (p->kind == NK::Ellipsis) continue;
            if (!p->kids.empty()) {
                if (fi->defaults.size() <= k) fi->defaults.resize(k + 1, nullptr);
                fi->defaults[k] = p->kids[0];
            }
            ++k;
        }
    }
    if (n->flags & F_PURE) fi->is_pure = true;
    if (n->kind == NK::FuncDef) {
        if (fi->defined) {
            error(n->line, "redefinition of function '" + irname + "'");
            return;
        }
        // A user definition of a library name (e.g. their own strlen) replaces
        // the built-in prototype instead of conflicting with it.
        bool replaces_library = fi->is_lib;
        fi->is_lib = false;
        // A definition after a prototype: the signatures must agree, and the
        // definition's parameter names are the ones the body uses.
        std::vector<TypeSpec> def_params;
        std::vector<std::string> def_names;
        bool def_variadic = false;
        for (Node *p : n->kids[0]->kids) {
            if (p->kind == NK::Ellipsis) { def_variadic = true; continue; }
            TypeSpec pt = decay_param(resolve(open_first_dim(*p->type)));
            if (pt.base == Base::Void && pt.ptr == 0 && p->str.empty()) continue;
            def_params.push_back(pt);
            def_names.push_back(p->str.empty() ? "arg" + itos(def_names.size()) : p->str);
        }
        bool conflict = def_params.size() != fi->params.size() || def_variadic != fi->variadic;
        for (size_t i = 0; !conflict && i < def_params.size(); ++i)
            if (!same_type(def_params[i], fi->params[i])) conflict = true;
        if (n->type && !same_type(resolve(*n->type), fi->ret)) conflict = true;
        if (replaces_library) { conflict = false; if (n->type) fi->ret = resolve(*n->type); }
        if (conflict) error(n->line, "conflicting declaration of function '" + name + "'");
        fi->params = def_params;
        fi->pnames = def_names;
        fi->variadic = def_variadic;
        fi->defined = true;
        fi->def = n;
        pending_.push_back(fi);
    }
}

// Declare a global (or static local / static member) variable: constant initialisers go
// into .data, others into __global_init; objects with destructors are queued for __global_fini.
// Comment: >30 lines because of array-bound inference, const tracking and initialiser kinds.
void CodeGen::declare_global_var(Node *n, const std::string &prefix, bool register_symbol, bool construct) {
    if (n->line > 0) cur_line_ = n->line;
    TypeSpec t = resolve(*n->type);
    std::string irname = prefix + n->str;
    if (reserved_ir_name(irname)) irname += "_v";
    Node *init = n->kids.empty() ? nullptr : n->kids[0];

    if (!t.dims.empty() && t.dims[0] < 0 && !t.decayed && init) {
        if (init->kind == NK::InitList) t.dims[0] = inferred_bound(t, init);
        else if (init->kind == NK::StrLit && t.base == Base::Char)
            t.dims[0] = static_cast<int>(string_literal_size(init->str));
    }
    if (!t.dims.empty() && t.dims[0] < 0 && !t.decayed)
        error(n->line, "array bound cannot be inferred from this initializer");

    if (t.base == Base::Auto && init) t = type_of_expr(init);

    Symbol s;
    s.name = n->str;
    s.irname = irname;
    s.type = t;
    s.is_global = true;
    s.func_depth = 0;
    long cv = 0;
    if (t.is_const && is_integer(t) && t.dims.empty() && !t.ptr && init && eval_const_int(init, cv)) {
        s.const_int = true;
        s.value = cv;
    }
    if (register_symbol) {
        Scope &target = scopes_[prefix.empty() ? 0 : scopes_.size() - 1];
        if (target.syms.count(n->str)) error(n->line, "redeclaration of '" + n->str + "'");
        target.syms[n->str] = s;
    }
    if (t.base == Base::Void && t.ptr == 0 && t.dims.empty())
        error(n->line, "variable '" + n->str + "' has incomplete type 'void'");
    if (!t.dims.empty() && size_of(elem_type(t)) == 0)
        error(n->line, "array '" + n->str + "' has elements of incomplete type");

    std::string decl = irname + " : " + type_str(t) + " (" + itos(size_of(t)) + ")";
    bool emitted_const = init && literal_init(init, t);
    if (emitted_const && init->kind == NK::InitList) {
        std::string vals;
        for (Node *k : init->kids) vals += (vals.empty() ? "" : ", ") + gen_literal(k).place;
        decl += " = {" + vals + "}";
    } else if (emitted_const && init->kind == NK::StrLit) {
        decl += " = str" + itos(string_index(init->str));
    } else if (emitted_const) {
        decl += " = " + gen_literal(init).place;
    }
    mod_.globals.push_back(decl);

    {   // a global object whose class has a destructor is destroyed when main returns
        ClassInfo *gc = (is_aggregate(t) && t.dims.empty() && !t.ptr && !t.ref) ? class_of(t) : nullptr;
        if (gc && gc->dtor && construct) static_objs_.push_back({irname, gc});
        // global array of objects: default-construct each element, destroy at exit
        TypeSpec et = is_array(t) ? resolve(elem_type(t)) : t;
        ClassInfo *ec = (is_array(t) && t.dims.size() == 1 && t.dims[0] > 0 && is_aggregate(et)) ? class_of(et) : nullptr;
        if (ec && construct && !init) {
            if (ec->ctor) {
                Function *saved = cur_;
                cur_ = ginit_;
                std::string a = new_temp();
                emit(a + " = &" + irname, type_str(pointer_to(et)));
                for_each_element(a, ec, t.dims[0], false);
                cur_ = saved;
            }
            if (ec->dtor) static_objs_.push_back({irname + "[" + itos(t.dims[0]) + "]", ec});
        }
    }
    if (!construct) {
        // constructed by the caller (static local object)
    } else if (init && !emitted_const) {
        Function *saved = cur_;
        cur_ = ginit_;
        gen_var_init(s, t, init);
        cur_ = saved;
    } else if (!init && is_aggregate(t)) {
        ClassInfo *ci = class_of(t);
        if (ci && ci->ctor) {
            Function *saved = cur_;
            cur_ = ginit_;
            std::string a = new_temp();
            emit(a + " = &" + irname, type_str(pointer_to(t)));
            call_ctor(ci, a, nullptr);
            cur_ = saved;
        }
    }
}

// Whether a global initialiser is written into .data as it is: a literal, a list of
// literals for a scalar array, or a string literal for a pointer.
bool CodeGen::literal_init(Node *init, const TypeSpec &t) {
    auto literal = [](Node *k) { return k->kind == NK::IntLit || k->kind == NK::FloatLit || k->kind == NK::CharLit; };
    if (literal(init) || init->kind == NK::BoolLit || init->kind == NK::Nullptr) return true;
    if (init->kind == NK::InitList && !is_aggregate(t)) {
        for (Node *k : init->kids)
            if (!literal(k)) return false;
        return true;
    }
    return init->kind == NK::StrLit && is_pointer(t);
}

// Place a bit-field `T name : w` as gcc does: in the next free bits of a unit the size
// of T, starting a new unit when it would straddle one (or for a zero-width field).
void CodeGen::layout_bitfield(ClassInfo *ci, Node *d, int access, int &off, int &bitpos) {
    Field f;
    f.name = d->str;
    f.type = resolve(*d->type);
    f.access = access;
    f.owner = ci;
    f.irname = ci->name + "_" + f.name;
    long w = 0;
    int unit = std::max(1, size_of(f.type)) * 8;
    if (!is_integer(f.type) || f.type.ptr || !f.type.dims.empty()) {
        error(d->line, "bit-field '" + f.name + "' must have an integer type");
        unit = 32;
    }
    if (!eval_const_int(d->kids[0], w) || w < 0 || w > unit || (w == 0 && !f.name.empty())) {
        error(d->line, "invalid width for bit-field '" + f.name + "'");
        w = 1;
    }
    if (ci->kind == Base::Union) {
        ci->size = std::max(ci->size, unit / 8);
    } else {
        if (bitpos < 0) bitpos = off * 8;
        if (w == 0 || bitpos / unit != (bitpos + (int)w - 1) / unit) bitpos = (bitpos + unit - 1) / unit * unit;
        f.offset = bitpos / unit * (unit / 8);
        f.bit_offset = bitpos % unit;
        bitpos += (int)w;
    }
    f.bit_width = (int)w;
    if (!f.name.empty()) ci->fields.push_back(f);
}

void CodeGen::gen_pending_bodies() {
    for (size_t i = 0; i < pending_.size(); ++i) gen_function(pending_[i]);
}

// Generate the IR for one function: parameters (incl. `this`), constructor prologue
// (base ctor, vptr, member initialisers), body, destructor epilogue and the implicit return.
// Comment: >30 lines because constructors and destructors add fixed prologue/epilogue steps.
void CodeGen::gen_function(FuncInfo *fi) {
    Function *f = new Function;
    f->name = fi->irname;
    f->ret = type_str(fi->ret);

    Function *saved_cur = cur_;
    FuncInfo *saved_fn = cur_fn_;
    ClassInfo *saved_cls = cur_class_;
    cur_ = f;
    cur_fn_ = fi;
    cur_class_ = fi->cls;
    fn_stack_.push_back(f);
    temp_stack_.push_back(temp_counter_);
    temp_counter_ = 0;
    used_names_.push_back({});
    push_scope();
    size_t saved_fn_depth = fn_scope_depth_;
    fn_scope_depth_ = scopes_.size() - 1;

    if (fi->cls && !fi->is_static) {
        TypeSpec tt;
        tt.base = fi->cls->kind;
        tt.name = fi->cls->name;
        tt.ptr = 1;
        Symbol &s = declare("this", tt);
        s.irname = "this";
        f->params.push_back(type_str(tt) + " this");
    }
    if (fi->def && fi->def->line > 0) cur_line_ = fi->def->line;
    for (size_t i = 0; i < fi->params.size(); ++i) {
        TypeSpec pt = fi->params[i];
        if (is_aggregate(pt)) pt.ref = true;   // aggregates arrive by address
        Symbol &s = declare(fi->pnames[i], pt);
        f->params.push_back(type_str(pt) + " " + s.irname);
    }
    if (fi->variadic) f->params.push_back("...");
    if (fi->deduce_ret && fi->def && fi->def->kids.size() > 2 && !first_return_value(fi->def->kids[2])) {
        fi->ret = TypeSpec();                  // lambda without `-> T` and without `return expr;`
        fi->ret.base = Base::Void;
        fi->deduce_ret = false;
        f->ret = "void";
    }

    std::map<std::string, int> saved_labels = labels_defined_;
    std::vector<std::pair<std::string, int>> saved_gotos = gotos_;
    std::vector<GotoFix> saved_fixes = goto_fixes_;
    std::map<std::string, std::vector<int>> saved_chains = label_chains_;
    goto_fixes_.clear();
    label_chains_.clear();
    labels_defined_.clear();
    gotos_.clear();

    Node *def = fi->def;
    if (def && def->line > 0) cur_line_ = def->line;
    else if (fi->cls && fi->cls->def_line > 0) cur_line_ = fi->cls->def_line;
    Node *ctor_inits = fi->is_ctor && def && def->kids.size() > 1 && def->kids[1]->kind == NK::CtorInit ? def->kids[1] : nullptr;
    Node *delegate = nullptr;               // `C(...) : C(args)`: another constructor does the work
    if (ctor_inits)
        for (Node *item : ctor_inits->kids)
            if (item->str == fi->cls->name) delegate = item;
    if (delegate) {
        if (ctor_inits->kids.size() != 1)
            error(delegate->line, "a delegating constructor cannot have other initializers");
        call_ctor(fi->cls, "this", delegate);
    } else if (fi->is_ctor) {
        ClassInfo *ci = fi->cls;
        Node *init_list = ctor_inits;
        Node *base_init = nullptr;
        if (init_list && ci->base) {
            for (Node *item : init_list->kids)
                if (item->str == ci->base->name) base_init = item;
        }
        if (ci->base && ci->base->ctor) {
            Node empty_args;
            empty_args.kind = NK::DeclList;
            call_ctor(ci->base, "this", base_init ? base_init : &empty_args);
        } else if (base_init) {
            error(base_init->line, "base class has no constructor");
        }
        if (ci->has_vptr) {
            std::string vt = new_temp();
            emit(vt + " = &vtable_" + ci->name, "ptr");
            std::string a = offset_addr("this", ci->vptr_offset);
            emit("*" + a + " = " + vt, "ptr");
        }
        for (const Field &fld : ci->fields) {
            if (fld.owner != ci || fld.is_static) continue;
            Node *member_init = nullptr;
            if (init_list) {
                for (Node *item : init_list->kids)
                    if (item->str == fld.name) { member_init = item; break; }
            }
            std::string a = offset_addr("this", fld.offset, type_str(pointer_to(fld.type)));
            ClassInfo *fc = is_aggregate(fld.type) ? class_of(fld.type) : nullptr;
            if (fld.type.ref) {
                if (!member_init) {
                    error(0, "reference member '" + fld.name + "' requires an initializer");
                } else if (member_init->kids.size() != 1) {
                    error(member_init->line, "reference member initializer requires one lvalue");
                } else {
                    Val reference = gen_expr(member_init->kids[0]);
                    if (reference.k != Val::Var && reference.k != Val::Addr)
                        error(member_init->line, "reference member must bind to an lvalue");
                    else
                        emit("*" + a + " = " + addr_of(reference), type_str(pointer_to(fld.type)));
                }
            } else if (fc && fc->ctor) {
                Node empty_args;
                empty_args.kind = NK::DeclList;
                Node explicit_args;
                explicit_args.kind = NK::DeclList;
                explicit_args.kids = member_init ? member_init->kids : std::vector<Node *>{};
                call_ctor(fc, a, member_init ? &explicit_args : &empty_args);
            } else if (!member_init && fld.init && !is_aggregate(fld.type) && fld.type.dims.empty()) {
                Val v = gen_expr(fld.init);            // default member initializer
                if (check_assignable(fld.init->line, fld.type, v, "initialization"))
                    store(field_val(a, fld), convert(rvalue(v), v.type, fld.type), fld.type);
            } else if (!member_init && fld.init && fld.init->kind == NK::InitList) {
                init_aggregate(a, fld.type, fld.init);
            } else if (member_init) {
                if (member_init->kids.empty()) {
                    zero_initialize(a, fld.type);
                } else if (is_aggregate(fld.type)) {
                    error(member_init->line, "aggregate member initializer requires a constructor");
                } else if (member_init->kids.size() == 1) {
                    Val v = gen_expr(member_init->kids[0]);
                    store(field_val(a, fld), convert(rvalue(v), v.type, fld.type), fld.type);
                } else {
                    error(member_init->line, "too many values in member initializer");
                }
            }
        }
        if (init_list) {
            for (Node *item : init_list->kids) {
                if (ci->base && item == base_init) continue;
                const Field *fld = find_field(ci, item->str);
                if (!fld || fld->owner != ci || fld->is_static)
                    error(item->line, "unknown member " + item->str + " in initializer list");
            }
        }
    }

    if (fi->is_dtor && fi->cls && fi->cls->has_vptr) {
        // inside a destructor the object is of the destructor's own class again,
        // so virtual calls made by it (and by base destructors) do not reach the
        // already-destroyed derived part
        std::string vt = new_temp();
        emit(vt + " = &vtable_" + fi->cls->name, "ptr");
        emit("*" + offset_addr("this", fi->cls->vptr_offset) + " = " + vt, "ptr");
    }
    if (def && def->kids.size() > 2 && def->kids[2]->kind == NK::Block) gen_block(def->kids[2], false);

    if (fi->is_dtor && fi->cls) {
        for (auto it = fi->cls->fields.rbegin(); it != fi->cls->fields.rend(); ++it) {
            if (it->owner != fi->cls || it->is_static) continue;
            ClassInfo *member_cls = is_aggregate(it->type) ? class_of(it->type) : nullptr;
            if (!member_cls || !member_cls->dtor) continue;
            if (!can_access(member_cls->dtor->access, member_cls))
                error(0, "member destructor of '" + member_cls->name + "' is not accessible here");
            std::string a = offset_addr("this", it->offset, type_str(pointer_to(it->type)));
            emit("param " + a);
            emit("call " + member_cls->dtor->irname + ", 1");
        }
    }

    if (fi->is_dtor && fi->cls && fi->cls->base && fi->cls->base->dtor) {
        if (!can_access(fi->cls->base->dtor->access, fi->cls->base))
            error(0, "base destructor of '" + fi->cls->base->name + "' is not accessible here");
        emit("param this");
        emit("call " + fi->cls->base->dtor->irname + ", 1");
    }

    if (f->code.empty() || f->code.back().text.rfind("return", 0) != 0) {
        emit_scope_dtors(fn_scope_depth_);
        if (fi->ret.base == Base::Void && fi->ret.ptr == 0) emit("return");
        else if (fi->name == "main") emit("return 0");
        else emit("return");
    }

    for (auto &g : gotos_)
        if (!labels_defined_.count(g.first)) error(g.second, "goto to undefined label '" + g.first + "'");
    patch_gotos(f);
    labels_defined_ = saved_labels;
    gotos_ = saved_gotos;
    goto_fixes_ = saved_fixes;
    label_chains_ = saved_chains;

    pop_scope();
    fn_scope_depth_ = saved_fn_depth;
    used_names_.pop_back();
    temp_counter_ = temp_stack_.back();
    temp_stack_.pop_back();
    fn_stack_.pop_back();
    cur_ = saved_cur;
    cur_fn_ = saved_fn;
    cur_class_ = saved_cls;
    mod_.funcs.push_back(f);
}

// ============================================================================
// Statements
// ============================================================================

void CodeGen::gen_block(Node *n, bool new_scope) {
    if (new_scope) push_scope();
    for (Node *s : n->kids) gen_stmt(s);
    if (new_scope) {
        bool ends_in_jump = !cur_->code.empty() &&
            (cur_->code.back().text.rfind("return", 0) == 0 || cur_->code.back().text.rfind("goto", 0) == 0);
        if (!ends_in_jump) emit_scope_dtors(scopes_.size() - 1);
        pop_scope();
    }
}

// Destroy the by-value argument copies made while evaluating the statement
// just finished (C++ destroys them at the end of the full-expression).
void CodeGen::flush_temp_dtors() {
    for (auto it = temp_dtors_.rbegin(); it != temp_dtors_.rend(); ++it) {
        std::string a = new_temp();
        emit(a + " = &" + it->first, "ptr");
        emit("param " + a);
        emit("call " + it->second->dtor->irname + ", 1");
    }
    temp_dtors_.clear();
}

void CodeGen::gen_stmt(Node *n) {
    gen_stmt_inner(n);
    if (!temp_dtors_.empty()) flush_temp_dtors();
}

// Generate IR for one statement (dispatch on the statement kind).
// Comment: >30 lines because it dispatches every statement form.
void CodeGen::gen_stmt_inner(Node *n) {
    if (!n) return;
    if (n->line > 0) cur_line_ = n->line;
    switch (n->kind) {
        case NK::Block: gen_block(n, true); break;
        case NK::Empty: break;
        case NK::DeclList:
            for (Node *d : n->kids) {
                if (d->kind == NK::VarDecl) gen_local_decl(d);
                else if (d->kind == NK::AggDef) process_aggregate(d);
                else if (d->kind == NK::EnumDef) process_enum(d);
                else if (d->kind == NK::Typedef) typedefs_[d->str] = *d->type;
            }
            break;
        case NK::VarDecl: gen_local_decl(n); break;
        case NK::AggDef: process_aggregate(n); break;
        case NK::EnumDef: process_enum(n); break;
        case NK::Typedef:
            typedefs_[n->str] = *n->type;
            if (n->type->agg_def) gen_stmt(n->type->agg_def);
            break;
        case NK::ExprStmt: {
            Node *e = n->kids[0];
            if (e->kind == NK::PostInc || e->kind == NK::PostDec) gen_incdec(e->kids[0], e->kind == NK::PostInc ? "+" : "-", true);
            else gen_expr(e);
            break;
        }
        case NK::If: gen_if(n); break;
        case NK::For: gen_for(n); break;
        case NK::While: gen_while(n); break;
        case NK::DoWhile: gen_do(n, false); break;
        case NK::DoUntil: gen_do(n, true); break;
        case NK::Switch: gen_switch(n); break;
        case NK::Break:
            if (loops_.empty()) error(n->line, "break outside loop");
            else { emit_scope_dtors(loop_depth_.back()); emit("goto " + loops_.back().first); }
            break;
        case NK::Continue: {
            bool found = false;
            for (int i = (int)loops_.size() - 1; i >= 0; --i) {
                if (!loops_[i].second.empty()) {
                    emit_scope_dtors(loop_depth_[i]);
                    emit("goto " + loops_[i].second);
                    found = true;
                    break;
                }
            }
            if (!found) error(n->line, "continue outside loop");
            break;
        }
        case NK::Goto: {
            gotos_.push_back({n->str, n->line});
            GotoFix fix{n->str, 0, scope_chain(), {}};
            bool any = false;
            for (size_t level = fn_scope_depth_; level < scopes_.size(); ++level) {
                size_t mark = cur_->code.size();             // generate each level's cleanup now,
                emit_level_dtors(level, "");                 // keep it aside until the label is known
                fix.cleanup.emplace_back(cur_->code.begin() + (long)mark, cur_->code.end());
                cur_->code.resize(mark);
                any = any || !fix.cleanup.back().empty();
            }
            fix.at = cur_->code.size();
            emit("goto " + user_label(n->str));
            if (any) goto_fixes_.push_back(fix);
            break;
        }
        case NK::Label:
            if (labels_defined_.count(n->str)) error(n->line, "duplicate label '" + n->str + "'");
            labels_defined_[n->str] = n->line;
            label_chains_[n->str] = scope_chain();
            emit_label(user_label(n->str));
            gen_stmt(n->kids[0]);
            break;
        case NK::Return: gen_return(n); break;
        default:
            unsupported(n->line, "statement kind " + itos((int)n->kind));
    }
}

// Declare a local variable: static locals, auto/lambda deduction, array bounds, const
// ints, initialisation, and registration of objects for destruction at scope exit.
// Comment: >30 lines because each declaration kind needs its own handling.
void CodeGen::gen_local_decl(Node *n) {
    if (n->line > 0) cur_line_ = n->line;
    if (!(n->flags & F_STATIC) && !n->type->dims.empty() && n->type->dims[0] <= DIM_EXPR_BASE && !n->type->ref) {
        Node *bound = g_dim_exprs[(size_t)(DIM_EXPR_BASE - n->type->dims[0])];
        long cv = 0;
        if (!eval_const_int(bound, cv)) { gen_vla(n, bound); return; }
    }
    TypeSpec t = resolve(*n->type);
    Node *init = n->kids.empty() ? nullptr : n->kids[0];

    if (n->flags & F_STATIC) {
        ClassInfo *sc = (is_aggregate(t) && t.dims.empty() && !t.ptr && !t.ref) ? class_of(t) : nullptr;
        TypeSpec et = is_array(t) ? resolve(elem_type(t)) : t;
        ClassInfo *ec = (t.dims.size() == 1 && t.dims[0] > 0 && is_aggregate(et) && !init) ? class_of(et) : nullptr;
        if (ec && !ec->ctor && !ec->dtor) ec = nullptr;
        if ((sc && (sc->ctor || sc->dtor)) || ec || (init && !literal_init(init, t))) {
            // initialised the first time control passes here (guarded by a hidden
            // flag); an object's destructor is then registered to run at exit
            declare_global_var(n, cur_fn_->irname + "_", true, false);
            Symbol *sym = lookup(n->str);
            std::string guard = sym->irname + "__guard";
            mod_.globals.push_back(guard + " : int (4) = 0");
            std::string g = new_temp(), skip = new_label();
            emit(g + " = " + guard, "int");
            emit("if " + g + " goto " + skip);
            emit(guard + " = 1", "int");
            if (ec) {                          // array of objects: construct (and register) each element
                std::string a = new_temp();
                emit(a + " = &" + sym->irname, type_str(pointer_to(et)));
                for_each_element(a, ec, t.dims[0], false, ec->dtor != nullptr);
                uses_atexit_ = uses_atexit_ || ec->dtor;
            } else {
                gen_var_init(*sym, t, init);
            }
            if (sc && sc->dtor) {
                std::string a = new_temp();
                emit(a + " = &" + sym->irname, type_str(pointer_to(t)));
                emit_call(external("__fns_atexit"), "__fns_atexit", {sc->dtor->irname, a}, false);
                uses_atexit_ = true;
            }
            emit_label(skip);
            return;
        }
        declare_global_var(n, cur_fn_->irname + "_");
        return;
    }

    if (t.base == Base::Auto && init) {
        if (init->kind == NK::Lambda) {
            Val lv = gen_lambda(init);
            Symbol &s = declare(n->str, lv.type, Symbol::Lambda);
            s.lam = lv.lam;
            for (auto &c : lv.lam->caps) (void)c;
            return;
        }
        t = type_of_expr(init);
        t.ref = false;
    }

    if (!t.dims.empty() && t.dims[0] < 0 && !t.decayed && init) {
        if (init->kind == NK::InitList) t.dims[0] = inferred_bound(t, init);
        else if (init->kind == NK::StrLit && t.base == Base::Char)
            t.dims[0] = static_cast<int>(string_literal_size(init->str));
    }
    if (!t.dims.empty() && t.dims[0] < 0 && !t.decayed) {
        error(n->line, "array bound cannot be inferred from this initializer");
        return;
    }

    if (t.base == Base::Void && t.ptr == 0 && t.dims.empty() && !t.ref)
        error(n->line, "variable '" + n->str + "' has incomplete type 'void'");
    else if (!t.dims.empty() && size_of(elem_type(t)) == 0)
        error(n->line, "array '" + n->str + "' has elements of incomplete type");
    Symbol &s = declare(n->str, t);
    long cv = 0;
    if (t.is_const && is_integer(t) && t.dims.empty() && !t.ptr && init && eval_const_int(init, cv)) {
        s.const_int = true;                       // usable in array bounds: const int N = 4;
        s.value = cv;
    }
    TypeSpec stored = t;
    if (t.ref) { stored = pointer_to(t); stored.ptr = t.ptr + 1; stored.ref = false; stored.dims.clear(); }
    cur_->locals.push_back(s.irname + " : " + type_str(t) + " (" + itos(size_of(stored)) + ")");
    gen_var_init(s, t, init);
    // a local object whose class has a destructor is destroyed when its scope ends
    ClassInfo *oc = (!t.ref && t.ptr == 0 && t.dims.empty() && is_aggregate(t)) ? class_of(t) : nullptr;
    if (oc && oc->dtor) scopes_.back().dtors.push_back({s.irname, oc});
    TypeSpec et = is_array(t) ? resolve(elem_type(t)) : t;
    ClassInfo *ec = (is_array(t) && t.dims.size() == 1 && t.dims[0] > 0 && is_aggregate(et)) ? class_of(et) : nullptr;
    if (ec && ec->dtor) scopes_.back().dtors.push_back({s.irname + "[" + itos(t.dims[0]) + "]", ec});
}

// A variable-length array `T a[n]...` (only the first bound may vary): a pointer to
// storage from malloc, freed when the scope ends; sizeof reads a hidden size local.
void CodeGen::gen_vla(Node *n, Node *bound) {
    TypeSpec t = resolve(open_first_dim(*n->type));
    t.decayed = true;
    if (!n->kids.empty()) error(n->line, "a variable-length array cannot be initialized");
    Val cnt = gen_expr(bound);
    if (!is_integer(cnt.type) || cnt.type.ptr || !cnt.type.dims.empty())
        error(n->line, "array size must have an integer type");
    std::string count = convert(rvalue(cnt), cnt.type, int_type());
    std::string bytes = emit_binop(count, "*", itos(size_of(elem_type(t))), int_type());
    Symbol &s = declare(n->str, t);
    s.vla_size = unique_local(n->str + "__size");
    cur_->locals.push_back(s.vla_size + " : int (4)");
    cur_->locals.push_back(s.irname + " : " + type_str(t) + " (4)");
    emit(s.vla_size + " = " + bytes, "int");
    Val mem = emit_call(external("malloc"), "malloc", {bytes}, false);
    emit(s.irname + " = " + mem.place, type_str(t));
    scopes_.back().dtors.push_back({s.irname, nullptr});
}

// Is the expression a named object (variable, member, element, dereference)?
// std::move(x) (lexed as __fns_move): x as an rvalue, which may bind to T&& and moves.
bool CodeGen::is_move_call(Node *n) const {
    return n && n->kind == NK::Call && n->kids[0]->kind == NK::Ident && n->kids[0]->str == "__fns_move" &&
           n->kids[1] && n->kids[1]->kids.size() == 1;
}

// The move constructor T(T&&) of a class, if any.
FuncInfo *CodeGen::move_ctor_of(ClassInfo *ci) {
    for (FuncInfo *c = ci->ctor; c; c = c->next_overload) {
        TypeSpec p = c->params.empty() ? TypeSpec() : resolve(c->params[0]);
        if (c->params.size() == 1 && p.rref && p.ptr == 0 && class_of(p) == ci) return c;
    }
    return nullptr;
}

bool CodeGen::is_lvalue_node(Node *n) const {
    if (!n) return false;
    switch (n->kind) {
        case NK::Ident: case NK::Member: case NK::Arrow: case NK::Index: return true;
        case NK::Unary: return n->str == "*";
        default: return false;
    }
}

// `c ? a : b` where both branches are lvalues of the same type is itself an
// lvalue (C++): the result is the address of the chosen branch.  Otherwise
// this is the ordinary conditional expression.
Val CodeGen::gen_cond_lvalue(Node *n) {
    TypeSpec ta = type_of_expr(n->kids[1]), tb = type_of_expr(n->kids[2]);
    if (!is_lvalue_node(n->kids[1]) || !is_lvalue_node(n->kids[2]) || !same_type(ta, tb))
        return gen_expr(n);
    std::string res = new_temp(), lelse = new_label(), lend = new_label();
    std::string c = cond_value(n->kids[0]);
    emit("ifFalse " + c + " goto " + lelse);
    Val a = gen_expr(n->kids[1]);
    emit(res + " = " + addr_of(a), type_str(pointer_to(a.type)));
    emit("goto " + lend);
    emit_label(lelse);
    Val b = gen_expr(n->kids[2]);
    emit(res + " = " + addr_of(b), type_str(pointer_to(b.type)));
    emit_label(lend);
    Val v;
    v.k = Val::Addr;
    v.place = res;
    v.type = a.type;
    v.type.ref = false;
    return v;
}

// A temporary used to initialise a variable (or returned) becomes that object:
// it is no longer destroyed at the end of the statement (copy elision).
void CodeGen::adopt_temp(const Val &v) {
    if (v.temp_obj.empty()) return;
    for (auto it = temp_dtors_.begin(); it != temp_dtors_.end(); ++it)
        if (it->first == v.temp_obj) { temp_dtors_.erase(it); return; }
}

// True when returning now would run destructors (local objects or argument copies).
bool CodeGen::has_pending_dtors() const {
    if (!temp_dtors_.empty()) return true;
    for (size_t i = fn_scope_depth_; i < scopes_.size(); ++i)
        if (!scopes_[i].dtors.empty()) return true;
    return false;
}

// Call the default constructor (forward order) or the destructor (reverse
// order) of each of the `count` objects starting at address `base`; with
// `at_exit`, each constructed object's destructor is registered to run at exit.
void CodeGen::for_each_element(const std::string &base, ClassInfo *ci, int count, bool destroy, bool at_exit) {
    TypeSpec ot;
    ot.base = ci->kind;
    ot.name = ci->name;
    std::string i = new_temp(), top = new_label(), done = new_label();
    emit(i + " = " + (destroy ? itos(count - 1) : "0"), "int");
    emit_label(top);
    std::string c = new_temp();
    emit(c + " = " + i + (destroy ? " < 0" : " >= " + itos(count)), "int");
    emit("if " + c + " goto " + done);
    std::string off = new_temp(), p = new_temp();
    emit(off + " = " + i + " * " + itos(ci->size), "int");
    emit(p + " = " + base + " + " + off, type_str(pointer_to(ot)));
    if (destroy) {
        emit("param " + p);
        emit("call " + ci->dtor->irname + ", 1");
    } else {
        if (ci->ctor) call_ctor(ci, p, nullptr);
        if (at_exit) emit_call(external("__fns_atexit"), "__fns_atexit", {ci->dtor->irname, p}, false);
    }
    emit(i + " = " + i + (destroy ? " - 1" : " + 1"), "int");
    emit("goto " + top);
    emit_label(done);
}

// Run the destructors of the local objects in scopes_[depth..] (innermost
// first, reverse declaration order).  `keep` names an object that must not be
// destroyed (a local returned by value).
void CodeGen::emit_scope_dtors(size_t depth, const std::string &keep) {
    for (size_t i = scopes_.size(); i-- > depth;) emit_level_dtors(i, keep);
}

// Destroy the objects of scopes_[level] (reverse declaration order).
void CodeGen::emit_level_dtors(size_t level, const std::string &keep) {
    auto &d = scopes_[level].dtors;
    for (auto it = d.rbegin(); it != d.rend(); ++it) {
        if (it->first == keep) continue;
        size_t br = it->first.find('[');
        if (br != std::string::npos) {                  // an array of objects
            std::string name = it->first.substr(0, br);
            int count = std::atoi(it->first.c_str() + br + 1);
            std::string a = new_temp();
            emit(a + " = &" + name, "ptr");
            for_each_element(a, it->second, count, true);
            continue;
        }
        if (!it->second) {                              // a variable-length array's storage
            emit_call(external("free"), "free", {it->first}, false);
            continue;
        }
        TypeSpec ot;
        ot.base = it->second->kind;
        ot.name = it->second->name;
        std::string a = new_temp();
        emit(a + " = &" + it->first, type_str(pointer_to(ot)));
        emit("param " + a);
        emit("call " + it->second->dtor->irname + ", 1");
    }
}

// Initialise a variable: references, direct/list initialisation, constructor calls,
// copy constructors, aggregate brace lists, strings and plain expressions.
// Comment: >30 lines because C and C++ have many initialisation forms.
void CodeGen::gen_var_init(const Symbol &sym, const TypeSpec &t, Node *init) {
    Val target;
    target.k = Val::Var;
    target.place = sym.irname;
    target.type = t;
    target.type.ref = false;

    ClassInfo *ci = is_aggregate(t) ? class_of(t) : nullptr;

    if (!init) {
        if (t.ref) {
            error(0, "reference variable requires an initializer");
            return;
        }
        if (ci && ci->ctor) {
            std::string a = addr_of(target);
            call_ctor(ci, a, nullptr);
        }
        // T arr[N]; default-constructs every element
        TypeSpec et = is_array(t) ? resolve(elem_type(t)) : t;
        ClassInfo *ec = (is_array(t) && t.dims.size() == 1 && is_aggregate(et)) ? class_of(et) : nullptr;
        if (ec && ec->ctor && t.dims[0] > 0) for_each_element(addr_of(target), ec, t.dims[0], false);
        return;
    }

    if (t.ref) {
        Val v = init->kind == NK::Cond ? gen_cond_lvalue(init) : gen_expr(init);
        std::string a;
        TypeSpec referent = t;
        referent.ref = false;
        TypeSpec vt = v.type;
        vt.ref = false;
        bool types_match = same_type(referent, vt) ||
            (is_aggregate(referent) && is_aggregate(vt) && derives_from(class_of(vt), class_of(referent)));
        if ((v.k == Val::Var || v.k == Val::Addr) && !types_match && !t.is_const) {
            error(init->line, "reference of type '" + type_str(t) + "' cannot bind to an object of type '" + type_str(vt) + "'");
            return;
        }
        if (t.rref && is_lvalue_node(init)) {
            error(init->line, "cannot bind rvalue reference of type '" + type_str(t) + "' to lvalue of type '" + type_str(vt) + "'");
            return;
        }
        if ((v.k == Val::Var || v.k == Val::Addr) && types_match) {
            if (is_aggregate(vt)) base_accessible(init->line, class_of(vt), class_of(referent));
            a = addr_of(v);
        } else if (t.is_const || t.rref) {           // a temporary holds the value
            if (!check_assignable(init->line, referent, v, "reference initialization")) return;
            TypeSpec value_type = t;
            value_type.ref = value_type.rref = false;
            std::string tmp = unique_local("ref_tmp");
            cur_->locals.push_back(tmp + " : " + type_str(value_type) + " (" + itos(size_of(value_type)) + ")");
            emit(tmp + " = " + convert(rvalue(v), v.type, value_type), type_str(value_type));
            a = new_temp();
            emit(a + " = &" + tmp, type_str(pointer_to(value_type)));
        } else {
            error(init->line, "non-const reference must bind to an lvalue");
            return;
        }
        emit(sym.irname + " = " + a, type_str(pointer_to(t)));
        return;
    }

    // Direct- and list-initialisation: T x(args); T x{args};
    if (init->kind == NK::InitList && (init->flags & (F_CTOR | F_VALUE_INIT))) {
        bool paren = (init->flags & F_CTOR) != 0;
        if (ci && ci->ctor) {                                 // construct in place
            std::string a = addr_of(target);
            if (init->kids.empty() && !ci->ctor->def) zero_initialize(a, t);
            call_ctor(ci, a, init);
            return;
        }
        if (init->kids.size() == 1 && !is_array(t) && (!ci || paren)) {
            gen_var_init(sym, t, init->kids[0]);              // int x(5); Point q(p);
            return;
        }
        if (paren) {
            error(init->line, "too many values in initializer of '" + sym.name + "'");
            return;
        }
        if (init->kids.empty() && !is_aggregate(t) && !is_array(t)) {
            emit(sym.irname + " = 0", type_str(t));           // int x{};
            return;
        }
    }

    if (init->kind == NK::InitList) {
        std::string base = addr_of(target);
        init_aggregate(base, t, init);
        return;
    }

    if (init->kind == NK::StrLit && is_array(t)) {
        init_string(addr_of(target), t, init);
        return;
    }

    if (ci && init->kind == NK::Call && init->kids[0]->kind == NK::TypeName && init->kids[0]->str == t.name) {
        std::string a = addr_of(target);
        Node *args = init->kids[1];
        if (args && args->kids.empty() && ci->ctor && !ci->ctor->def)
            zero_initialize(a, t);
        call_ctor(ci, a, args);
        return;
    }

    if (ci && ci->ctor && init->kind != NK::InitList && !(init->kind == NK::Call && init->kids[0]->kind == NK::TypeName)) {
        TypeSpec it = type_of_expr(init);
        if (!(is_aggregate(it) && it.ptr == 0)) {
            // V g = 7;  an implicit converting constructor V(int)
            Node args;
            args.kind = NK::DeclList;
            args.line = init->line;
            args.kids = {init};
            call_ctor(ci, addr_of(target), &args);
            return;
        }
    }
    FuncInfo *cc = !ci || init->kind == NK::InitList ? nullptr
                 : is_lvalue_node(init) ? copy_ctor_of(ci)
                 : is_move_call(init) ? (move_ctor_of(ci) ? move_ctor_of(ci) : copy_ctor_of(ci)) : nullptr;
    if (cc) {
        TypeSpec it = type_of_expr(init);
        if (is_aggregate(it) && it.ptr == 0 && class_of(it) && derives_from(class_of(it), ci)) {
            Val src = gen_expr(init);              // T b = a; / T b = std::move(a);
            std::string a = addr_of(target);
            emit("param " + a);
            emit("param " + addr_of(src));
            emit("call " + cc->irname + ", 2");
            return;
        }
    }
    Val v = gen_expr(init);
    if (ci) adopt_temp(v);
    if (t.base == Base::Func && v.k == Val::Lambda && v.lam && !v.lam->caps.empty())
        error(init->line, "capturing lambda cannot convert to a function pointer");
    if (is_array(t) && !t.decayed) {
        error(init->line, "array must be initialized with a brace-enclosed list or string literal");
        return;
    }
    if (!check_assignable(init->line, t, v, "initialization")) return;
    if (is_aggregate(t)) {
        std::string dst = addr_of(target);
        std::string src = addr_of(v);
        emit("copy " + dst + ", " + src + ", " + itos(size_of(t)), type_str(t));
        return;
    }
    std::string r = convert(rvalue(v), v.type, t);
    emit(sym.irname + " = " + r, type_str(t));
}

void CodeGen::init_string(const std::string &base, const TypeSpec &t, Node *lit) {
    int idx = string_index(lit->str);
    size_t literal_size = string_literal_size(lit->str);
    size_t bound = t.dims.empty() || t.dims[0] < 0 ? literal_size : static_cast<size_t>(t.dims[0]);
    if (t.dims.size() != 1 || t.base != Base::Char || t.ptr != 0) {
        error(lit->line, "string literal can only initialize a char array");
        return;
    }
    // C (not C++) allows the terminating NUL to be dropped: char s[3] = "abc";
    if (literal_size > bound && !(literal_size == bound + 1 && !cplusplus_))
        error(lit->line, "string literal of " + itos(static_cast<long>(literal_size)) +
              " bytes does not fit in char[" + itos(static_cast<long>(bound)) + "]");
    size_t copied = std::min(literal_size, bound);
    zero_initialize(base, t);
    if (copied)
        emit("copy " + base + ", str" + itos(idx) + ", " + itos(static_cast<long>(copied)), "char[]");
}

void CodeGen::init_aggregate(const std::string &base, const TypeSpec &t, Node *list) {
    if (t.ref) {
        error(list->line, "a reference cannot be initialized with a nested aggregate list");
        return;
    }
    zero_initialize(base, t);
    size_t idx = 0;
    fill_aggregate(base, t, list, idx, true);
    if (idx < list->kids.size()) {
        ClassInfo *ci = is_array(t) ? nullptr : class_of(t);
        error(list->line, is_array(t) ? "too many initializers for array"
                          : (ci && ci->kind == Base::Union) ? "too many initializers for union"
                          : "too many initializers for aggregate");
    }
}

// True when the un-braced initializer `k` starts a sub-aggregate of type `t`
// whose braces were omitted (C brace elision), e.g. {1, 2, 3, 4} for int[2][2].
bool CodeGen::needs_elision(const TypeSpec &t_in, Node *k) {
    TypeSpec t = resolve(t_in);
    if (k->kind == NK::InitList || t.ref) return false;
    if (is_array(t))
        return !(k->kind == NK::StrLit && resolve(elem_type(t)).base == Base::Char && t.dims.size() == 1);
    if (is_aggregate(t)) {
        TypeSpec kt = type_of_expr(k);
        return !(is_aggregate(kt) && class_of(kt) == class_of(t));
    }
    return false;
}

// Number of scalar leaves in an object (used to infer `int a[][3] = {1,2,3,4}`).
int CodeGen::scalar_leaves(const TypeSpec &t_in) {
    TypeSpec t = resolve(t_in);
    if (is_array(t)) {
        int n = (!t.dims.empty() && t.dims[0] > 0) ? t.dims[0] : 1;
        return n * scalar_leaves(elem_type(t));
    }
    ClassInfo *ci = is_aggregate(t) ? class_of(t) : nullptr;
    if (!ci) return 1;
    int n = 0;
    for (const Field &f : ci->fields) {
        if (f.is_static) continue;
        n += scalar_leaves(f.type);
        if (ci->kind == Base::Union) break;
    }
    return n > 0 ? n : 1;
}

// Bound of `T a[] = {...}`: one element per braced item, or with brace
// elision as many elements as the flat list fills.
int CodeGen::inferred_bound(const TypeSpec &t, Node *init) {
    TypeSpec et = elem_type(t);
    bool designated = false;
    long pos = 0, bound = 0;                       // `[i] = v` moves the position
    for (Node *k : init->kids) {
        if (k->kind == NK::Designator && k->kids[1]->kind == NK::Index) { designated = true; eval_const_int(k->kids[1]->kids[0], pos); }
        bound = std::max(bound, ++pos);
    }
    if (designated) return static_cast<int>(bound);
    bool flat = !init->kids.empty();
    for (Node *k : init->kids) if (!needs_elision(et, k)) flat = false;
    if (!flat) return static_cast<int>(init->kids.size());
    int leaves = scalar_leaves(et);
    return static_cast<int>((init->kids.size() + leaves - 1) / leaves);
}

// Initialise the object at `base` from list->kids[idx...].  `braced` is true
// when `list` is the object's own brace list; otherwise the braces were elided
// and only as many items as the object holds are consumed.
// Comment: >30 lines because arrays, structs and unions each walk their
// elements/members, sharing init_member for the individual items.
void CodeGen::fill_aggregate(const std::string &base, const TypeSpec &t, Node *list, size_t &idx,
                             bool braced) {
    size_t n = list->kids.size(), start = idx;
    // a designator belongs to this list when it is braced; an elided sub-object
    // ends at the next designator after its first item
    auto designator = [&]() -> Node * {
        Node *d = idx < n && list->kids[idx]->kind == NK::Designator ? list->kids[idx] : nullptr;
        return d && (braced || idx != start) ? d : nullptr;
    };
    if (is_array(t)) {
        TypeSpec et = elem_type(t);
        int es = size_of(et);
        size_t limit = (!t.dims.empty() && t.dims[0] >= 0) ? static_cast<size_t>(t.dims[0]) : n;
        for (size_t i = 0; idx < n; ++i) {
            if (Node *d = designator()) {
                long at = -1;
                if (!braced) return;
                if (d->kids[1]->kind != NK::Index || !eval_const_int(d->kids[1]->kids[0], at) || at < 0 || (size_t)at >= limit) {
                    error(d->line, d->kids[1]->kind != NK::Index ? "field designator in an array initializer"
                                   : "array designator index is not a constant inside the array bounds");
                    ++idx;
                    continue;
                }
                i = (size_t)at;
            }
            if (i >= limit) break;
            std::string a = offset_addr(base, (int)i * es, type_str(pointer_to(et)));
            if (!designated_member(a, et, list, idx)) init_member(a, et, list, idx);
        }
        return;
    }
    ClassInfo *ci = class_of(t);
    if (!ci) {                                      // scalar in braces: int x = {5};
        if (idx < n) init_member(base, t, list, idx);
        return;
    }
    size_t fi = 0;
    bool first = true;
    while (idx < n) {
        if (Node *d = designator()) {             // `.name = v`: continue from that member
            if (!braced) break;
            if (d->kids[1]->kind != NK::Member) {
                error(d->line, "array designator in a struct initializer");
                ++idx;
                continue;
            }
            size_t at = 0;
            const std::string &name = d->kids[1]->str;
            while (at < ci->fields.size() && (ci->fields[at].name != name || ci->fields[at].is_static)) ++at;
            if (at == ci->fields.size()) {
                error(d->line, "no member '" + name + "' in '" + ci->name + "'");
                ++idx;
                continue;
            }
            fi = at;
            if (ci->kind == Base::Union) first = true;   // a later designator picks another member
        }
        while (fi < ci->fields.size() && ci->fields[fi].is_static) ++fi;
        if (fi >= ci->fields.size()) break;
        if (ci->kind == Base::Union && !first) break;
        first = false;
        const Field &f = ci->fields[fi++];
        std::string a = offset_addr(base, f.offset, type_str(pointer_to(f.type)));
        if (f.type.ref) {
            Node *k = list->kids[idx++];
            if (k->kind == NK::Designator) k = k->kids[0];
            Val v = gen_expr(k);
            if (v.k != Val::Var && v.k != Val::Addr)
                error(k->line, "reference member must bind to an lvalue");
            else
                emit("*" + a + " = " + addr_of(v), type_str(pointer_to(f.type)));
            continue;
        }
        if (f.bit_width) {                         // a bit-field takes one scalar value
            Node *k = list->kids[idx++];
            if (k->kind == NK::Designator) k = k->kids[0];
            Val v = gen_expr(k);
            if (check_assignable(k->line, f.type, v, "initialization"))
                store(field_val(a, f), convert(rvalue(v), v.type, f.type), f.type);
            continue;
        }
        if (!designated_member(a, f.type, list, idx)) init_member(a, f.type, list, idx);
    }
    if (braced)
        for (; fi < ci->fields.size(); ++fi)
            if (ci->fields[fi].type.ref && !ci->fields[fi].is_static)
                error(list->line, "reference member '" + ci->fields[fi].name + "' requires an initializer");
}

// `.a.b = v` / `[i][j] = v`: after the first step chose the member or element at
// `a`, follow the remaining steps to the sub-object and initialise only that.
bool CodeGen::designated_member(const std::string &a_in, const TypeSpec &t_in, Node *list, size_t &idx) {
    Node *d = list->kids[idx];
    if (d->kind != NK::Designator || d->kids.size() < 3) return false;
    std::string a = a_in;
    TypeSpec t = resolve(t_in);
    for (size_t s = 2; s < d->kids.size(); ++s) {
        Node *step = d->kids[s];
        long at = -1;
        if (step->kind == NK::Index && is_array(t) && eval_const_int(step->kids[0], at) && at >= 0 && at < t.dims[0]) {
            t = resolve(elem_type(t));
            a = offset_addr(a, (int)at * size_of(t), type_str(pointer_to(t)));
        } else if (step->kind == NK::Member && class_of(t) && find_field(class_of(t), step->str)) {
            const Field *f = find_field(class_of(t), step->str);
            t = resolve(f->type);
            a = offset_addr(a, f->offset, type_str(pointer_to(t)));
        } else {
            error(d->line, "invalid designator in initializer");
            ++idx;
            return true;
        }
    }
    init_member(a, t, list, idx);
    return true;
}

// One element or member from list->kids[idx]: a nested brace list, a string
// for a char array, an elided sub-aggregate, or a single expression.
void CodeGen::init_member(const std::string &a, const TypeSpec &t, Node *list, size_t &idx) {
    Node *k = list->kids[idx];
    if (k->kind == NK::Designator) k = k->kids[0];      // the position was set by fill_aggregate
    if (k->kind == NK::InitList) {
        ++idx;
        size_t j = 0;
        fill_aggregate(a, t, k, j, true);
        if (j < k->kids.size())
            error(k->line, is_array(t) ? "too many initializers for array" : "too many initializers for aggregate");
        return;
    }
    if (k->kind == NK::StrLit && is_array(t) && resolve(elem_type(t)).base == Base::Char && t.dims.size() == 1) {
        ++idx;
        init_string(a, t, k);
        return;
    }
    if (needs_elision(t, k)) {
        fill_aggregate(a, t, list, idx, false);
        return;
    }
    ++idx;
    Val v = gen_expr(k);
    if (!check_assignable(k->line, t, v, "initialization")) return;
    if (is_aggregate(t)) {
        emit("copy " + a + ", " + addr_of(v) + ", " + itos(size_of(t)), type_str(t));
        adopt_temp(v);                     // {Tok(5)}: the element is the temporary
        return;
    }
    emit("*" + a + " = " + convert(rvalue(v), v.type, t), type_str(t));
}

void CodeGen::zero_initialize(const std::string &base, const TypeSpec &t) {
    if (is_array(t)) {
        TypeSpec e = elem_type(t);
        if (t.dims.empty() || t.dims[0] < 0) return;
        int stride = size_of(e);
        for (int i = 0; i < t.dims[0]; ++i) {
            zero_initialize(offset_addr(base, i * stride, type_str(pointer_to(e))), e);
        }
        return;
    }
    if (is_aggregate(t)) {
        ClassInfo *ci = class_of(t);
        if (!ci || ci->fields.empty()) return;
        if (ci->kind == Base::Union) {
            const Field &f = ci->fields.front();
            zero_initialize(offset_addr(base, f.offset, type_str(pointer_to(f.type))), f.type);
            return;
        }
        for (const Field &f : ci->fields)
            zero_initialize(offset_addr(base, f.offset, type_str(pointer_to(f.type))), f.type);
        return;
    }
    emit("*" + base + " = 0", type_str(t));
}

void CodeGen::gen_if(Node *n) {
    std::string lelse = new_label();
    std::string c = cond_value(n->kids[0]);
    emit("ifFalse " + c + " goto " + lelse);
    gen_stmt(n->kids[1]);
    if (n->kids.size() > 2) {
        std::string lend = new_label();
        emit("goto " + lend);
        emit_label(lelse);
        gen_stmt(n->kids[2]);
        emit_label(lend);
    } else {
        emit_label(lelse);
    }
}

// for (T x : arr) / for (auto &x : arr) over an array of known size.
// Comment: >30 lines because it builds the hidden index loop, binds the loop
// variable by value or by reference, and wires break/continue.
void CodeGen::gen_range_for(Node *n) {
    Node *decl = n->kids[0];
    push_scope();
    Val r = gen_expr(n->kids[1]);
    TypeSpec rt = resolve(r.type);
    rt.ref = false;
    if (!is_array(rt) || rt.dims[0] <= 0) {
        error(n->line, "range-based for needs an array with a known size");
        pop_scope();
        return;
    }
    TypeSpec et = elem_type(rt);
    int count = rt.dims[0], es = size_of(et);
    std::string base = unique_local("range_base"), idx = unique_local("range_i");
    cur_->locals.push_back(base + " : " + type_str(pointer_to(et)) + " (4)");
    cur_->locals.push_back(idx + " : int (4)");
    emit(base + " = " + addr_of(r), type_str(pointer_to(et)));
    emit(idx + " = 0", "int");
    std::string lcond = new_label(), lstep = new_label(), lend = new_label();
    emit_label(lcond);
    std::string c = emit_binop(idx, "<", itos(count), int_type());
    emit("ifFalse " + c + " goto " + lend);
    std::string off = emit_binop(idx, "*", itos(es), int_type());
    std::string ea = emit_binop(base, "+", off, pointer_to(et));
    TypeSpec vt = resolve(*decl->type);
    if (vt.base == Base::Auto) {
        bool ref = vt.ref, cst = vt.is_const;
        vt = et;
        vt.ref = ref;
        vt.is_const = vt.is_const || cst;
    }
    Symbol &s = declare(decl->str, vt);
    TypeSpec stored = vt;
    if (vt.ref) { stored = pointer_to(et); }
    cur_->locals.push_back(s.irname + " : " + type_str(vt) + " (" + itos(vt.ref ? 4 : size_of(vt)) + ")");
    if (vt.ref) {
        emit(s.irname + " = " + ea, type_str(pointer_to(et)));
    } else if (is_aggregate(vt)) {
        std::string d = new_temp();
        emit(d + " = &" + s.irname, type_str(pointer_to(vt)));
        emit("copy " + d + ", " + ea + ", " + itos(size_of(vt)), type_str(vt));
    } else {
        Val ev;
        ev.k = Val::Addr;
        ev.place = ea;
        ev.type = et;
        emit(s.irname + " = " + convert(rvalue(ev), et, vt), type_str(vt));
    }
    loops_.push_back({lend, lstep});
    loop_depth_.push_back(scopes_.size());
    gen_stmt(n->kids[3]);
    loops_.pop_back();
    loop_depth_.pop_back();
    emit_label(lstep);
    emit(idx + " = " + idx + " + 1", "int");
    emit("goto " + lcond);
    emit_label(lend);
    pop_scope();
}

// Generate a classic for loop (init; cond; step) with break/continue labels.
// Comment: >30 lines because the step expression has several lowered forms.
void CodeGen::gen_for(Node *n) {
    if (n->flags & F_ARRAY) { gen_range_for(n); return; }
    push_scope();
    gen_stmt(n->kids[0]);
    std::string lcond = new_label(), lstep = new_label(), lend = new_label();
    emit_label(lcond);
    if (n->kids[1]->kind != NK::Empty) {
        std::string c = cond_value(n->kids[1]);
        emit("ifFalse " + c + " goto " + lend);
    }
    loops_.push_back({lend, lstep});
    loop_depth_.push_back(scopes_.size());
    gen_stmt(n->kids[3]);
    loops_.pop_back();
    loop_depth_.pop_back();
    emit_label(lstep);
    Node *step = n->kids[2];
    if (step->kind == NK::PostInc || step->kind == NK::PostDec) gen_incdec(step->kids[0], step->kind == NK::PostInc ? "+" : "-", true);
    else if (step->kind == NK::Comma) {
        Node *last = step->kids[1];
        if (last->kind == NK::PostInc || last->kind == NK::PostDec) {
            Node *a = step->kids[0];
            if (a->kind == NK::PostInc || a->kind == NK::PostDec) gen_incdec(a->kids[0], a->kind == NK::PostInc ? "+" : "-", true);
            else gen_expr(a);
            gen_incdec(last->kids[0], last->kind == NK::PostInc ? "+" : "-", true);
        } else gen_expr(step);
    }
    else if (step->kind != NK::Empty) gen_expr(step);
    emit("goto " + lcond);
    emit_label(lend);
    pop_scope();
}

void CodeGen::gen_while(Node *n) {
    std::string lcond = new_label(), lend = new_label();
    emit_label(lcond);
    std::string c = cond_value(n->kids[0]);
    emit("ifFalse " + c + " goto " + lend);
    loops_.push_back({lend, lcond});
    loop_depth_.push_back(scopes_.size());
    gen_stmt(n->kids[1]);
    loops_.pop_back();
    loop_depth_.pop_back();
    emit("goto " + lcond);
    emit_label(lend);
}

void CodeGen::gen_do(Node *n, bool until) {
    std::string lbody = new_label(), lcond = new_label(), lend = new_label();
    emit_label(lbody);
    loops_.push_back({lend, lcond});
    loop_depth_.push_back(scopes_.size());
    gen_stmt(n->kids[0]);
    loops_.pop_back();
    loop_depth_.pop_back();
    emit_label(lcond);
    std::string c = cond_value(n->kids[1]);
    if (until) emit("ifFalse " + c + " goto " + lbody);
    else emit("if " + c + " goto " + lbody);
    emit_label(lend);
}

// Generate a switch as a chain of comparisons followed by the labelled case bodies
// (fallthrough preserved, duplicate labels diagnosed).
// Comment: >30 lines because case collection and body emission are separate passes.
void CodeGen::gen_switch(Node *n) {
    Val switch_value = gen_expr(n->kids[0]);
    TypeSpec switch_type = switch_value.type;
    bool integral_switch = switch_type.ptr == 0 && switch_type.dims.empty() &&
        (switch_type.base == Base::Bool || switch_type.base == Base::Char ||
         switch_type.base == Base::Short || switch_type.base == Base::Int ||
         switch_type.base == Base::Long || switch_type.base == Base::Enum);
    if (!integral_switch) error(n->line, "switch expression must have an integer or enum type");
    TypeSpec promoted_type = promote(switch_type, int_type());
    std::string sw = convert(rvalue(switch_value), switch_type, promoted_type);
    std::string lend = new_label();
    std::vector<std::string> labels;
    std::string ldefault;
    std::set<long> case_values;
    bool saw_default = false;
    for (size_t i = 1; i < n->kids.size(); ++i) {
        Node *c = n->kids[i];
        std::string l = new_label();
        labels.push_back(l);
        if (c->flags & F_DEFAULT) {
            if (saw_default) error(c->line, "duplicate default label in switch");
            saw_default = true;
            ldefault = l;
            continue;
        }
        long case_value = 0;
        if (!eval_const_int(c->kids[0], case_value)) {
            error(c->line, "case label is not an integer constant expression");
            continue;
        }
        if (!case_values.insert(case_value).second)
            error(c->line, "duplicate case value " + itos(case_value));
        std::string v = convert(itos(case_value), int_type(), promoted_type);
        std::string t = emit_binop(sw, "==", v, int_type());
        emit("if " + t + " goto " + l);
    }
    emit("goto " + (ldefault.empty() ? lend : ldefault));
    loops_.push_back({lend, ""});
    push_scope();                              // the whole switch body is one scope
    loop_depth_.push_back(scopes_.size() - 1); // break destroys the objects built so far
    std::string crossed;                       // C++: a later case may not skip an initialisation
    for (size_t i = 1; i < n->kids.size(); ++i) {
        if (!crossed.empty() && cplusplus_)
            error(n->kids[i]->line, "jump to case label crosses initialization of '" + crossed + "'");
        emit_label(labels[i - 1]);
        gen_block(n->kids[i]->kids[1], false);
        for (Node *st : n->kids[i]->kids[1]->kids) {
            std::vector<Node *> decls = st->kind == NK::DeclList ? st->kids : std::vector<Node *>{st};
            for (Node *d : decls) {
                if (d->kind != NK::VarDecl || (d->flags & F_STATIC) || !crossed.empty()) continue;
                ClassInfo *dc = class_of(resolve(*d->type));
                if (!d->kids.empty() || (dc && dc->ctor && d->type->ptr == 0)) crossed = d->str;
            }
        }
    }
    loops_.pop_back();
    loop_depth_.pop_back();
    emit_scope_dtors(scopes_.size() - 1);      // falling off the end of the last case
    pop_scope();
    emit_label(lend);
}

// Generate a return: type checks, lambda return-type deduction, reference returns,
// destruction of temporaries and local objects, then the return instruction.
// Comment: >30 lines because of the many return forms and checks.
void CodeGen::gen_return(Node *n) {
    bool void_fn = cur_fn_->ret.base == Base::Void && cur_fn_->ret.ptr == 0 && !cur_fn_->ret.ref;
    if (n->kids.empty()) {
        if (cur_fn_->ret.ref) {
            error(n->line, "reference-returning function requires a return value");
            emit("return 0", type_str(pointer_to(cur_fn_->ret)));
            return;
        }
        if (!void_fn && cur_fn_->name != "main")
            error(n->line, "return without a value in a function returning '" + type_str(cur_fn_->ret) + "'");
        emit_scope_dtors(fn_scope_depth_);
        emit("return");
        return;
    }
    Val v = (cur_fn_->ret.ref && n->kids[0]->kind == NK::Cond) ? gen_cond_lvalue(n->kids[0])
                                                               : gen_expr(n->kids[0]);
    if (cur_fn_->deduce_ret) {
        // lambda without `-> T`: its return type is that of the first `return expr;`
        TypeSpec t = v.type;
        t.ref = false;
        if (is_array(t)) t = pointer_to(t);
        if (t.base == Base::Lambda || (t.base == Base::Void && t.ptr == 0)) t = int_type();
        cur_fn_->ret = t;
        cur_fn_->deduce_ret = false;
        cur_->ret = type_str(t);
        void_fn = false;
    }
    if (void_fn) {
        TypeSpec vt = v.type;
        if (!(vt.base == Base::Void && vt.ptr == 0)) {
            error(n->line, "return with a value in a function returning void");
            emit("return");
            return;
        }
    }
    if (!void_fn && !check_assignable(n->line, cur_fn_->ret, v, "return")) {
        emit("return 0", type_str(cur_fn_->ret));
        return;
    }
    if (cur_fn_->ret.base == Base::Func && v.k == Val::Lambda && v.lam && !v.lam->caps.empty())
        error(n->line, "capturing lambda cannot convert to a function pointer");
    if (cur_fn_->ret.ref) {
        if (v.k != Val::Var && v.k != Val::Addr) {
            error(n->line, "function returning a reference must return an lvalue");
            emit("return 0", type_str(pointer_to(cur_fn_->ret)));
            return;
        }
        std::string ra = addr_of(v);
        emit_scope_dtors(fn_scope_depth_);
        emit("return " + ra, type_str(pointer_to(cur_fn_->ret)));
        return;
    }
    std::string r = is_aggregate(v.type) ? addr_of(v) : convert(rvalue(v), v.type, cur_fn_->ret);
    adopt_temp(v);
    if (is_aggregate(v.type) && v.k != Val::Var && v.temp_obj.empty() && has_pending_dtors()) {
        // a returned temporary lives in a dead callee frame: save it before the
        // destructor calls below can overwrite it
        std::string tmp = unique_local("ret_obj");
        cur_->locals.push_back(tmp + " : " + type_str(v.type) + " (" + itos(size_of(v.type)) + ")");
        std::string a = new_temp();
        emit(a + " = &" + tmp, type_str(pointer_to(v.type)));
        emit("copy " + a + ", " + r + ", " + itos(size_of(v.type)), type_str(v.type));
        r = a;
    }
    // The returned local object is handed to the caller, not destroyed (as with
    // C++ named return value optimisation).
    flush_temp_dtors();
    emit_scope_dtors(fn_scope_depth_, (v.k == Val::Var && is_aggregate(v.type)) ? v.place : "");
    emit("return " + r, type_str(cur_fn_->ret));
}

// ============================================================================
// Expressions
// ============================================================================

TypeSpec CodeGen::type_of_expr(Node *n) {
    Function *saved = cur_;
    Function scratch;
    cur_ = &scratch;
    int saved_temp = temp_counter_;
    size_t saved_strings = mod_.strings.size();
    size_t saved_errors = mod_.errors.size();
    size_t saved_notes = mod_.notes.size();
    std::vector<std::string> saved_externs = mod_.externs;
    std::map<std::string, FuncInfo *> saved_functions = functions_;
    bool saved_sizeof = in_sizeof_;
    size_t saved_tdtors = temp_dtors_.size();
    in_sizeof_ = true;
    Val v = gen_expr(n);
    temp_dtors_.resize(saved_tdtors);
    in_sizeof_ = saved_sizeof;
    mod_.errors.resize(saved_errors);
    mod_.notes.resize(saved_notes);
    mod_.strings.resize(saved_strings);
    mod_.externs = saved_externs;
    functions_ = std::move(saved_functions);
    temp_counter_ = saved_temp;
    cur_ = saved;
    TypeSpec t = v.type;
    if (v.k == Val::Func) { t = TypeSpec(); t.base = Base::Func; t.ptr = 1; }
    if (v.k == Val::Lambda) { t = TypeSpec(); t.base = Base::Lambda; }
    return t;
}

// Lower a literal (integer, float, char with escapes, bool, nullptr, string) to an operand.
// Comment: >30 lines because each literal kind is decoded differently.
Val CodeGen::gen_literal(Node *n) {
    Val v;
    v.k = Val::RVal;
    v.is_const = true;
    switch (n->kind) {
        case NK::IntLit: {
            std::string s = n->str;
            while (!s.empty() && (s.back() == 'u' || s.back() == 'U' || s.back() == 'l' || s.back() == 'L')) s.pop_back();
            v.cval = strtol(s.c_str(), nullptr, 0);
            v.place = itos(v.cval);
            v.type = int_type();
            if (n->str.find('L') != std::string::npos || n->str.find('l') != std::string::npos) v.type.base = Base::Long;
            if (n->str.find('u') != std::string::npos || n->str.find('U') != std::string::npos) v.type.is_unsigned = true;
            break;
        }
        case NK::FloatLit: {
            std::string s = n->str;
            bool f = false;
            while (!s.empty() && (s.back() == 'f' || s.back() == 'F' || s.back() == 'l' || s.back() == 'L')) {
                if (s.back() == 'f' || s.back() == 'F') f = true;
                s.pop_back();
            }
            v.place = f ? s + "f" : s;          // the suffix tells the backend it is a single
            v.type.base = f ? Base::Float : Base::Double;
            break;
        }
        case NK::CharLit: {
            std::string s = n->str.substr(1, n->str.size() - 2);
            long c = 0;
            if (s.size() >= 2 && s[0] == '\\') {
                switch (s[1]) {
                    case 'n': c = 10; break;
                    case 't': c = 9; break;
                    case 'r': c = 13; break;
                    case 'a': c = 7; break;
                    case 'b': c = 8; break;
                    case 'f': c = 12; break;
                    case 'v': c = 11; break;
                    case '\\': c = 92; break;
                    case '\'': c = 39; break;
                    case '"': c = 34; break;
                    case 'x': c = std::strtol(s.c_str() + 2, nullptr, 16) & 255; break;   // '\x41'
                    default:
                        if (s[1] >= '0' && s[1] <= '7') c = std::strtol(s.c_str() + 1, nullptr, 8) & 255;  // '\101', '\0'
                        else c = (unsigned char)s[1];
                }
                if (c > 127) c -= 256;            // char is signed
            } else if (!s.empty()) {
                c = (unsigned char)s[0];
            }
            v.cval = c;
            v.place = itos(c);
            v.type.base = Base::Char;
            break;
        }
        case NK::BoolLit:
            v.place = n->str;
            v.cval = n->str == "1";
            v.type.base = Base::Bool;
            break;
        case NK::Nullptr:
            v.place = "0";
            v.type.base = Base::Void;
            v.type.ptr = 1;
            break;
        case NK::StrLit:
            v.place = "str" + itos(string_index(n->str));
            v.type.base = Base::Char;
            v.type.ptr = 1;
            v.is_const = false;
            break;
        default: break;
    }
    return v;
}

// Resolve an identifier: locals, globals, enumerators, lambda captures (creating the
// hidden capture parameter), implicit this->member, methods and functions.
// Comment: >30 lines because of the lookup order and lambda capture handling.
Val CodeGen::gen_ident(Node *n) {
    const std::string &name = n->str;
    Val v;
    if (name == "NULL") {
        v.k = Val::RVal;
        v.place = "0";
        v.type.base = Base::Void;
        v.type.ptr = 1;
        v.is_const = true;
        return v;
    }
    Symbol *s = lookup(name);
    if (s) {
        if (s->kind == Symbol::EnumConst) {
            v.k = Val::RVal;
            v.place = itos(s->value);
            v.cval = s->value;
            v.is_const = true;
            v.type = s->type;
            return v;
        }
        if (s->kind == Symbol::Lambda) {
            v.k = Val::Lambda;
            v.lam = s->lam;
            v.type.base = Base::Lambda;
            return v;
        }
        int cur_depth = (int)fn_stack_.size();
        if (cur_lambda_ && !s->is_global && s->func_depth < cur_depth) {
            // capture from the enclosing function
            LambdaInfo *lam = cur_lambda_;
            bool has_default = false;
            bool default_by_ref = false;
            bool explicitly_captured = false;
            bool explicit_by_ref = false;
            size_t start = 0;
            while (start <= lam->mode.size()) {
                size_t comma = lam->mode.find(',', start);
                std::string token = lam->mode.substr(start, comma == std::string::npos ? std::string::npos : comma - start);
                if (token == "&" || token == "=") {
                    has_default = true;
                    default_by_ref = token == "&";
                } else {
                    bool by_reference = !token.empty() && token[0] == '&';
                    std::string captured_name = by_reference ? token.substr(1) : token;
                    if (captured_name == name) {
                        explicitly_captured = true;
                        explicit_by_ref = by_reference;
                    }
                }
                if (comma == std::string::npos) break;
                start = comma + 1;
            }
            if (!explicitly_captured && !has_default)
                error(n->line, "lambda uses uncaptured variable '" + name + "'");
            bool by_ref = explicitly_captured ? explicit_by_ref : default_by_ref;
            LambdaInfo::Cap cap;
            cap.name = name;
            cap.by_ref = by_ref;
            cap.type = s->type;
            cap.holder = lam->fn->irname + "_cap_" + name;
            lam->caps.push_back(cap);
            // a mutable lambda receives the address of its own copy (kept by the creator)
            bool by_addr = by_ref || s->type.ref || lam->is_mutable;
            TypeSpec pt = by_addr ? pointer_to(s->type) : s->type;
            if (s->type.ref) { pt = s->type; pt.ref = false; pt.ptr++; }
            Symbol &ps = scopes_[scopes_.size() - 1].syms[name] = Symbol();
            ps.kind = Symbol::Var;
            ps.name = name;
            ps.irname = "cap_" + name;
            ps.type = pt;
            if (by_addr) ps.type.ref = true, ps.type.ptr--;
            else if (ps.type.ptr == 0 && ps.type.dims.empty()) ps.type.is_const = true;   // copy in a non-mutable lambda
            ps.func_depth = cur_depth;
            cur_->params.push_back(type_str(pt) + " cap_" + name);
            lam->fn->params.push_back(pt);
            lam->fn->pnames.push_back("cap_" + name);
            s = &ps;
        }
        if (s->type.ref) {
            v.k = Val::Addr;
            v.place = s->irname;
            v.type = s->type;
            v.type.ref = false;
            return v;
        }
        v.k = Val::Var;
        v.place = s->irname;
        v.type = s->type;
        return v;
    }
    if (cur_class_) {
        const Field *f = find_field(cur_class_, name);
        if (f) {
            if (!can_access(f->access, f->owner))
                error(n->line, "member '" + name + "' is not accessible here");
            if (f->is_static) {
                v.k = Val::Var;
                v.place = f->irname;
            } else {
                if (cur_fn_ && cur_fn_->is_static)
                    error(n->line, "non-static member '" + name + "' used in a static method");
                v.k = Val::Addr;
                std::string field_addr = offset_addr("this", f->offset, type_str(pointer_to(f->type)));
                if (f->type.ref) {
                    v.place = new_temp();
                    emit(v.place + " = *" + field_addr, type_str(pointer_to(f->type)));
                } else {
                    v.place = field_addr;
                }
                v.bit_width = f->bit_width;
                v.bit_offset = f->bit_offset;
            }
            v.type = f->type;
            v.type.ref = false;
            return v;
        }
        FuncInfo *m = find_method(cur_class_, name);
        if (m) {
            if (!can_access(m->access, m->cls))
                error(n->line, "member '" + name + "' is not accessible here");
            v.k = Val::Method;
            v.fn = m;
            if (!m->is_static) {
                if (cur_fn_ && cur_fn_->is_static)
                    error(n->line, "non-static method '" + name + "' called from a static method");
                v.this_place = "this";
            }
            v.type = m->ret;
            return v;
        }
    }
    FuncInfo *fi = find_function(name);
    if (fi) {
        v.k = Val::Func;
        v.fn = fi;
        v.type.base = Base::Func;
        v.type.ptr = 1;
        v.type.ret = new TypeSpec(fi->ret);
        return v;
    }
    error(n->line, "undeclared identifier '" + name + "'");
    v.k = Val::Var;
    v.place = name;
    v.type = int_type();
    v.bad = true;
    return v;
}

// Generate IR for an expression (dispatch on the expression kind).
// Comment: >30 lines because it dispatches every expression form.
Val CodeGen::gen_expr(Node *n) {
    Val v;
    if (!n) return v;
    switch (n->kind) {
        case NK::IntLit: case NK::FloatLit: case NK::CharLit: case NK::BoolLit: case NK::Nullptr: case NK::StrLit:
            return gen_literal(n);
        case NK::Ident: return gen_ident(n);
        case NK::TypeName: {
            ClassInfo *ci = class_of(n->str);
            v.k = Val::Type;
            v.cls = ci;
            v.type.base = Base::Named;
            v.type.name = n->str;
            v.type = resolve(v.type);
            return v;
        }
        case NK::Binary:
            if (n->str == "&&" || n->str == "||") return gen_logical(n);
            return gen_binary(n);
        case NK::Unary: return gen_unary(n);
        case NK::PostInc: return gen_incdec(n->kids[0], "+", false);
        case NK::PostDec: return gen_incdec(n->kids[0], "-", false);
        case NK::Assign: return gen_assign(n);
        case NK::Cond: return gen_cond(n);
        case NK::Comma: {
            Node *a = n->kids[0];
            if (a->kind == NK::PostInc || a->kind == NK::PostDec) gen_incdec(a->kids[0], a->kind == NK::PostInc ? "+" : "-", true);
            else gen_expr(a);
            return gen_expr(n->kids[1]);
        }
        case NK::Call: return gen_call(n);
        case NK::Index: return gen_index(n);
        case NK::Member: return gen_member(n, false);
        case NK::Arrow: return gen_member(n, true);
        case NK::Scope: {
            Node *lhs = n->kids[0];
            if (lhs->kind == NK::TypeName && enums_.count(lhs->str)) {     // Color::Red
                Symbol *e = lookup(n->str);
                if (!e || e->kind != Symbol::EnumConst || e->type.name != lhs->str) {
                    error(n->line, "'" + n->str + "' is not a member of enum '" + lhs->str + "'");
                    v.k = Val::RVal;
                    v.place = "0";
                    v.type = int_type();
                    return v;
                }
                v.k = Val::RVal;
                v.place = itos(e->value);
                v.cval = e->value;
                v.is_const = true;
                v.type = e->type;
                return v;
            }
            ClassInfo *ci = (lhs->kind == NK::TypeName || lhs->kind == NK::Ident) ? class_of(lhs->str) : nullptr;
            FuncInfo *m = ci ? find_method(ci, n->str) : nullptr;
            if (m) {
                ClassInfo *access_object = m->is_static ? ci : cur_class_;
                if (!can_access(m->access, m->cls, access_object))
                    error(n->line, "member '" + n->str + "' is not accessible here");
                v.k = Val::Method;
                v.fn = m;
                if (!m->is_static) {
                    bool this_is_compatible = false;
                    for (ClassInfo *c = cur_class_; c; c = c->base)
                        if (c == ci) this_is_compatible = true;
                    if (!cur_class_ || !this_is_compatible)
                        error(n->line, "qualified non-static call requires a compatible this object");
                    v.this_place = "this";
                }
                v.type = m->ret;
                v.cls = ci;   // explicit qualification: direct call
                return v;
            }
            const Field *field = ci ? find_field(ci, n->str) : nullptr;
            if (field && field->is_static) {
                if (!can_access(field->access, field->owner, ci))
                    error(n->line, "member '" + n->str + "' is not accessible here");
                v.k = Val::Var;
                v.place = field->irname;
                v.type = field->type;
                return v;
            }
            Symbol *e = ci ? lookup(n->str) : nullptr;      // Outer::VALUE: enumerator of a nested enum
            if (e && e->kind == Symbol::EnumConst) {
                v.k = Val::RVal;
                v.place = itos(e->value);
                v.cval = e->value;
                v.is_const = true;
                v.type = e->type;
                return v;
            }
            unsupported(n->line, "scope resolution " + lhs->str + "::" + n->str);
            v.k = Val::RVal;
            v.place = "0";
            v.type = int_type();
            return v;
        }
        case NK::Cast: {
            Val inner = gen_expr(n->kids[0]);
            TypeSpec to = resolve(*n->type);
            TypeSpec it = inner.type;
            it.ref = false;
            if (is_aggregate(to) || is_aggregate(it)) {
                error(n->line, "cannot cast between aggregate and scalar types");
                v.k = Val::RVal; v.place = "0"; v.type = int_type();
                return v;
            }
            if (to.base == Base::Void && to.ptr == 0) {
                v.k = Val::RVal; v.place = "0"; v.type = to;
                return v;
            }
            std::string r = new_temp();
            emit(r + " = (" + type_str(to) + ") " + rvalue(inner), type_str(to));
            v.k = Val::RVal;
            v.place = r;
            v.type = to;
            return v;
        }
        case NK::SizeofType: {
            TypeSpec t = resolve(*n->type);
            if (size_of(t) == 0) error(n->line, "sizeof applied to an incomplete type");
            v.k = Val::RVal;
            v.cval = size_of(t);
            v.place = itos(v.cval);
            v.is_const = true;
            v.type = int_type();
            return v;
        }
        case NK::SizeofExpr: {
            TypeSpec t;
            if (n->kids[0]->kind == NK::TypeName) {
                t.base = Base::Named;
                t.name = n->kids[0]->str;
                t = resolve(t);
            } else {
                Symbol *vs = n->kids[0]->kind == NK::Ident ? lookup(n->kids[0]->str) : nullptr;
                if (vs && !vs->vla_size.empty()) {      // sizeof a variable-length array: run time
                    v.k = Val::Var;
                    v.place = vs->vla_size;
                    v.type = int_type();
                    return v;
                }
                t = type_of_expr(n->kids[0]);
            }
            v.k = Val::RVal;
            v.cval = size_of(t);
            v.place = itos(v.cval);
            v.is_const = true;
            v.type = int_type();
            return v;
        }
        case NK::New: return gen_new(n);
        case NK::Delete: return gen_delete(n);
        case NK::Lambda: return gen_lambda(n);
        case NK::InitList:
            unsupported(n->line, "brace initializer in expression");
            v.k = Val::RVal; v.place = "0"; v.type = int_type();
            return v;
        default:
            unsupported(n->line, "expression kind " + itos((int)n->kind));
            v.k = Val::RVal; v.place = "0"; v.type = int_type();
            return v;
    }
}

Val CodeGen::gen_logical(Node *n) {
    std::string r = new_temp();
    std::string lfalse = new_label(), lend = new_label();
    bool is_and = n->str == "&&";
    std::string a = cond_value(n->kids[0]);
    if (is_and) {
        emit("ifFalse " + a + " goto " + lfalse);
        std::string b = cond_value(n->kids[1]);
        emit("ifFalse " + b + " goto " + lfalse);
        emit(r + " = 1", "int");
        emit("goto " + lend);
        emit_label(lfalse);
        emit(r + " = 0", "int");
    } else {
        emit("if " + a + " goto " + lfalse);
        std::string b = cond_value(n->kids[1]);
        emit("if " + b + " goto " + lfalse);
        emit(r + " = 0", "int");
        emit("goto " + lend);
        emit_label(lfalse);
        emit(r + " = 1", "int");
    }
    emit_label(lend);
    Val v;
    v.k = Val::RVal;
    v.place = r;
    v.type = int_type();
    return v;
}

// Binary operators: row-pointer and pointer arithmetic, pointer comparisons, usual
// arithmetic conversions and type checks.
// Comment: >30 lines because pointer and arithmetic cases have different rules.
Val CodeGen::gen_binary(Node *n) {
    const std::string &op = n->str;
    Val l = gen_expr(n->kids[0]);
    std::string lv = rvalue(l);
    Val r = gen_expr(n->kids[1]);
    std::string rv = rvalue(r);
    TypeSpec lt = l.type, rt = r.type;
    Val out;
    out.k = Val::RVal;
    // `a + i` on a multi-dimensional array `int a[R][C]` (or on such a result)
    // is the address of row i; its type is the row array int[C].
    {
        auto row_of = [&](const Val &v, TypeSpec &row) {
            TypeSpec t = resolve(v.type);
            if (v.row_ptr && is_array(t)) { row = t; return true; }
            if (t.dims.size() >= 2) { row = elem_type(t); return true; }
            return false;
        };
        TypeSpec row, row2;
        bool left_row = row_of(l, row);
        bool row_cmp = op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=";
        if (left_row && (row_cmp || op == "-") && row_of(r, row2)) {
            // two row pointers: compare the addresses, or count the rows between them
            std::string a = l.row_ptr ? l.place : addr_of(l), b = r.row_ptr ? r.place : addr_of(r);
            out.place = emit_binop(a, op, b, int_type());
            if (op == "-") out.place = emit_binop(out.place, "/", itos(size_of(row)), int_type());
            out.type = int_type();
            return out;
        }
        bool right_row = !left_row && op == "+" && row_of(r, row);
        TypeSpec other = left_row ? rt : lt;
        if ((left_row || right_row) && (op == "+" || op == "-") && other.ptr == 0 && other.dims.empty() &&
            other.base != Base::Float && other.base != Base::Double) {
            std::string idx = left_row ? rv : lv;
            std::string base_addr = left_row ? (l.row_ptr ? l.place : addr_of(l)) : (r.row_ptr ? r.place : addr_of(r));
            idx = emit_binop(convert(idx, other, int_type()), "*", itos(size_of(row)), int_type());
            out.place = emit_binop(base_addr, op, idx, pointer_to(row));
            out.type = row;
            out.row_ptr = true;
            return out;
        }
    }
    if (is_array(lt) && !lt.decayed) lt = pointer_to(lt);
    if (is_array(rt) && !rt.decayed) rt = pointer_to(rt);

    bool cmp = op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=";
    bool lp = is_pointer(lt), rp = is_pointer(rt);
    if ((lt.base == Base::Void && lt.ptr == 0) || (rt.base == Base::Void && rt.ptr == 0)) {
        error(n->line, "void value used as an operand of '" + op + "'");
        out.place = "0";
        out.type = int_type();
        return out;
    }

    auto is_integer = [](const TypeSpec &t) {
        return t.ptr == 0 && t.dims.empty() &&
               (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short ||
                t.base == Base::Int || t.base == Base::Long || t.base == Base::Enum);
    };
    auto is_numeric = [&](const TypeSpec &t) { return is_float(t) || is_integer(t); };

    if (((op == "+" && (lp || rp)) || (op == "-" && lp && !rp)) && !(lp && rp)) {
        TypeSpec index_type = lp ? rt : lt;
        if (!is_integer(index_type)) {
            error(n->line, "pointer arithmetic requires an integer offset");
            out.place = "0";
            out.type = int_type();
            return out;
        }
        // pointer +/- integer, scaled by element size
        TypeSpec pt = lp ? lt : rt;
        int es = size_of(elem_type(pt));
        if (es <= 0) {
            error(n->line, "pointer arithmetic on an incomplete or void type");
            out.place = "0";
            out.type = int_type();
            return out;
        }
        std::string idx = lp ? rv : lv;
        idx = convert(idx, index_type, int_type());
        if (es != 1) idx = emit_binop(idx, "*", itos(es), int_type());
        out.place = lp ? emit_binop(lv, op, idx, pt) : emit_binop(idx, op, rv, pt);
        out.type = pt;
        return out;
    }
    if (op == "-" && lp && rp) {
        int es = size_of(elem_type(lt));
        if (es <= 0) {
            error(n->line, "pointer difference on an incomplete or void type");
            out.place = "0";
            out.type = int_type();
            return out;
        }
        std::string d = emit_binop(lv, "-", rv, int_type());
        if (es != 1) d = emit_binop(d, "/", itos(es), int_type());
        out.place = d;
        out.type = int_type();
        return out;
    }

    if (lp || rp) {
        bool null_compare = cmp && ((lp && r.is_const && r.cval == 0 && is_integer(rt)) ||
                                    (rp && l.is_const && l.cval == 0 && is_integer(lt)));
        if (!(cmp && lp && rp) && !null_compare) {
            error(n->line, "invalid operands for operator '" + op + "'");
            out.place = "0";
            out.type = int_type();
            return out;
        }
        TypeSpec common_ptr = lp ? lt : rt;
        lv = convert(lv, lt, common_ptr);
        rv = convert(rv, rt, common_ptr);
        out.place = emit_binop(lv, op, rv, int_type());
        out.type = int_type();
        return out;
    }
    if (!is_numeric(lt) || !is_numeric(rt)) {
        error(n->line, "operator '" + op + "' requires arithmetic operands");
        out.place = "0";
        out.type = int_type();
        return out;
    }

    TypeSpec common = promote(lt, rt);
    bool integer_only = op == "%" || op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>";
    bool shift = op == "<<" || op == ">>";
    if (integer_only && (is_float(lt) || is_float(rt)))
        error(n->line, "operator '" + op + "' requires integer operands");
    if (shift) common = promote(lt, lt);
    lv = convert(lv, lt, common);
    rv = convert(rv, rt, shift ? int_type() : common);
    out.place = emit_binop(lv, op, rv, cmp ? int_type() : common);
    out.type = cmp ? int_type() : common;
    if (l.is_const && r.is_const) out.is_const = false;
    return out;
}

// Pre/post increment and decrement of variables, elements, members and pointers.
// Comment: >30 lines because the old value must be kept for the postfix forms.
Val CodeGen::gen_incdec(Node *target, const std::string &op, bool prefix) {
    Val lhs = gen_expr(target);
    TypeSpec t = lhs.type;
    if (t.is_const && t.ptr == 0) {
        error(target->line, "increment of const object");
        Val out;
        out.k = Val::RVal;
        out.place = rvalue(lhs);
        out.type = t;
        out.type.ref = false;
        return out;
    }
    std::string step = "1";
    if (is_pointer(t)) step = itos(size_of(elem_type(t)));
    TypeSpec op_type = t;
    if (t.ptr == 0 && (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short || t.base == Base::Enum))
        op_type = int_type();
    Val out;
    out.k = Val::RVal;
    out.type = t;
    out.type.ref = false;
    if (lhs.k == Val::Var) {
        if (!prefix) {
            std::string old = new_temp();
            emit(old + " = " + lhs.place, type_str(t));
            out.place = old;
        }
        std::string old_value = convert(lhs.place, t, op_type);
        std::string nv = emit_binop(old_value, op, step, op_type);
        nv = convert(nv, op_type, t);
        emit(lhs.place + " = " + nv, type_str(t));
        if (prefix) out.place = nv;
    } else if (lhs.k == Val::Addr) {
        std::string old = lhs.bit_width ? load_bits(lhs) : load(lhs.place, t);
        std::string old_value = convert(old, t, op_type);
        std::string nv = emit_binop(old_value, op, step, op_type);
        nv = convert(nv, op_type, t);
        store(lhs, nv, t);
        out.place = prefix ? nv : old;
    } else {
        error(target->line, "increment of non-lvalue");
        out.place = "0";
    }
    return out;
}

// Unary operators: address-of, dereference (including array rows), +, -, !, ~, ++/--.
// Comment: >30 lines because each operator has its own operand rules.
Val CodeGen::gen_unary(Node *n) {
    const std::string &op = n->str;
    Val out;
    out.k = Val::RVal;
    if (op == "++" || op == "--") return gen_incdec(n->kids[0], op == "++" ? "+" : "-", true);
    if (op == "&") {
        Val inner = gen_expr(n->kids[0]);
        if (inner.k == Val::Func) {
            out.place = inner.fn->irname;
            out.type = inner.type;
            return out;
        }
        out.place = addr_of(inner);
        out.type = pointer_to(inner.type);
        if (is_array(inner.type)) { out.type = inner.type; out.type.ptr++; out.type.dims.clear(); }
        return out;
    }
    if (op == "*") {
        Val inner = gen_expr(n->kids[0]);
        if (inner.row_ptr || resolve(inner.type).dims.size() >= 2) {
            // *(a + i) / *a on a multi-dimensional array: the row itself
            out.k = Val::Addr;
            out.place = inner.row_ptr ? inner.place : addr_of(inner);
            out.type = inner.row_ptr ? inner.type : elem_type(resolve(inner.type));
            return out;
        }
        std::string p = rvalue(inner);
        TypeSpec t = inner.type;
        if (is_array(t)) t = pointer_to(t);
        if (!is_pointer(t) && t.base != Base::Func) error(n->line, "dereference of non-pointer");
        else if (is_pointer(t) && t.base == Base::Void && t.ptr == 1) {
            error(n->line, "dereference of a void pointer");
            out.k = Val::RVal;
            out.place = "0";
            out.type = int_type();
            out.bad = true;
            return out;
        }
        if (t.base == Base::Func && t.ptr <= 1) {
            out.k = Val::RVal;
            out.place = p;
            out.type = t;
            return out;
        }
        out.k = Val::Addr;
        out.place = p;
        out.type = elem_type(t);
        return out;
    }
    Val inner = gen_expr(n->kids[0]);
    std::string v = rvalue(inner);
    TypeSpec t = inner.type;
    t.ref = false;
    if (op == "+") {
        if (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short || t.base == Base::Enum) {
            TypeSpec promoted = int_type();
            out.place = convert(v, t, promoted);
            out.type = promoted;
        } else {
            out.place = v;
            out.type = t;
        }
        return out;
    }
    if (op == "-") {
        bool integral = t.ptr == 0 && t.dims.empty() &&
            (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short ||
             t.base == Base::Int || t.base == Base::Long || t.base == Base::Enum);
        if (!is_float(t) && !integral) {
            error(n->line, "unary '-' requires an arithmetic operand");
            out.place = "0";
            out.type = int_type();
            return out;
        }
        TypeSpec rt = is_float(t) ? t : (t.base == Base::Long ? t : int_type());
        if (inner.is_const && !is_float(t)) {
            out.place = itos(-inner.cval);
            out.cval = -inner.cval;
            out.is_const = true;
            out.type = rt;
            return out;
        }
        v = convert(v, t, rt);
        out.place = new_temp();
        emit(out.place + " = - " + v, type_str(rt));
        out.type = rt;
        return out;
    }
    if (op == "!") {
        if (!(is_pointer(t) || is_float(t) || (t.ptr == 0 && t.dims.empty() &&
              (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short ||
               t.base == Base::Int || t.base == Base::Long || t.base == Base::Enum))))
            error(n->line, "logical not requires a scalar operand");
        out.place = new_temp();
        emit(out.place + " = ! " + v, "int");
        out.type = int_type();
        return out;
    }
    if (op == "~") {
        if (t.ptr != 0 || !t.dims.empty() || is_float(t) ||
            !(t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short ||
              t.base == Base::Int || t.base == Base::Long || t.base == Base::Enum)) {
            error(n->line, "bitwise not requires an integer operand");
            out.place = "0";
            out.type = int_type();
            return out;
        }
        TypeSpec promoted = int_type();
        v = convert(v, t, promoted);
        out.place = new_temp();
        emit(out.place + " = ~ " + v, type_str(promoted));
        out.type = promoted;
        return out;
    }
    unsupported(n->line, "unary operator " + op);
    out.place = v;
    out.type = t;
    return out;
}

// Assignment and compound assignment: lvalue and const checks, aggregate copies,
// pointer scaling, conversions; the address is computed once.
// Comment: >30 lines because of the compound-operator and aggregate cases.
Val CodeGen::gen_assign(Node *n) {
    const std::string &op = n->str;
    Val lhs = gen_expr(n->kids[0]);
    if (lhs.k != Val::Var && lhs.k != Val::Addr) {
        error(n->line, "assignment to non-lvalue");
        return lhs;
    }
    TypeSpec lt = lhs.type;
    lt.ref = false;
    if (lt.is_const && lt.ptr == 0) {
        error(n->line, "assignment to const object");
        return lhs;
    }
    Val out;
    out.k = Val::RVal;
    out.type = lt;

    if (op == "=") {
        if (is_array(lt) && !lt.decayed) {
            error(n->line, "cannot assign to an array");
            return lhs;
        }
        if (is_aggregate(lt)) {
            Node *rhs = n->kids[1];
            ClassInfo *ci = class_of(lt);
            if (ci && rhs->kind == NK::Call && rhs->kids[0]->kind == NK::TypeName && rhs->kids[0]->str == lt.name) {
                std::string target = addr_of(lhs);
                Node *args = rhs->kids[1];
                if (args && args->kids.empty() && ci->ctor && !ci->ctor->def)
                    zero_initialize(target, lt);
                call_ctor(ci, target, args);
                out.place = lhs.place;
                return out;
            }
            Val r = gen_expr(rhs);
            if (!check_assignable(n->line, lt, r, "assignment")) return lhs;
            emit("copy " + addr_of(lhs) + ", " + addr_of(r) + ", " + itos(size_of(lt)), type_str(lt));
            out.place = lhs.place;
            return out;
        }
        Val r = gen_expr(n->kids[1]);
        if (lt.base == Base::Func && r.k == Val::Lambda && r.lam && !r.lam->caps.empty())
            error(n->line, "capturing lambda cannot convert to a function pointer");
        if (!check_assignable(n->line, lt, r, "assignment")) return lhs;
        std::string rv = convert(rvalue(r), r.type, lt);
        store(lhs, rv, lt);
        out.place = rv;
        return out;
    }

    if (is_array(lt) && !lt.decayed) {
        error(n->line, "cannot assign to an array");
        return lhs;
    }
    std::string curv = lhs.k == Val::Var ? lhs.place : lhs.bit_width ? load_bits(lhs) : load(lhs.place, lt);
    Val r = gen_expr(n->kids[1]);
    if (r.type.base == Base::Void && r.type.ptr == 0 && r.type.dims.empty()) {
        error(n->line, "void value used in compound assignment");
        return lhs;
    }
    std::string rv = rvalue(r);
    std::string nv;
    if (is_pointer(lt) && (op == "+" || op == "-")) {
        bool integer_offset = r.type.ptr == 0 && r.type.dims.empty() &&
            (r.type.base == Base::Bool || r.type.base == Base::Char || r.type.base == Base::Short ||
             r.type.base == Base::Int || r.type.base == Base::Long || r.type.base == Base::Enum);
        if (!integer_offset) {
            error(n->line, "pointer compound assignment requires an integer offset");
            return lhs;
        }
        int es = size_of(elem_type(lt));
        if (es != 1) rv = emit_binop(rv, "*", itos(es), int_type());
        nv = emit_binop(curv, op, rv, lt);
    } else {
        if (is_pointer(lt) || is_pointer(r.type) || is_aggregate(lt) || is_aggregate(r.type)) {
            error(n->line, "invalid operands for compound assignment");
            return lhs;
        }
        TypeSpec common = promote(lt, r.type);
        bool integer_only = op == "%" || op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>";
        bool shift = op == "<<" || op == ">>";
        if (integer_only && (is_float(lt) || is_float(r.type))) {
            error(n->line, "compound operator '" + op + "=' requires integer operands");
            return lhs;
        }
        if (shift) common = promote(lt, lt);
        std::string a = convert(curv, lt, common);
        std::string b = convert(rv, r.type, shift ? int_type() : common);
        nv = emit_binop(a, op, b, common);
        nv = convert(nv, common, lt);
    }
    store(lhs, nv, lt);
    out.place = nv;
    return out;
}

// Short-circuit && and || and the ?: operator, lowered to jumps into a temporary.
// Comment: >30 lines because the three operators share the jump scheme with differences.
Val CodeGen::gen_cond(Node *n) {
    TypeSpec at = type_of_expr(n->kids[1]);
    TypeSpec bt = type_of_expr(n->kids[2]);
    at.ref = false;
    bt.ref = false;
    if (is_array(at)) at = pointer_to(at);
    if (is_array(bt)) bt = pointer_to(bt);
    auto integer = [](const TypeSpec &t) {
        return t.ptr == 0 && t.dims.empty() &&
               (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short ||
                t.base == Base::Int || t.base == Base::Long || t.base == Base::Enum);
    };
    TypeSpec t;
    bool aggregate_result = false;
    bool void_result = false;
    if (is_aggregate(at) && is_aggregate(bt) && at.base == bt.base && at.name == bt.name) {
        t = at;
        aggregate_result = true;
    } else if ((is_float(at) || integer(at)) && (is_float(bt) || integer(bt))) {
        t = promote(at, bt);
    } else if (is_pointer(at) && is_pointer(bt)) {
        t = at;
    } else if (is_pointer(at) && integer(bt)) {
        long v;
        if (eval_const_int(n->kids[2], v) && v == 0) t = at;
        else error(n->line, "conditional operands have incompatible pointer types");
    } else if (is_pointer(bt) && integer(at)) {
        long v;
        if (eval_const_int(n->kids[1], v) && v == 0) t = bt;
        else error(n->line, "conditional operands have incompatible pointer types");
    } else if (at.base == Base::Void && bt.base == Base::Void) {
        t = at;
        void_result = true;
    } else {
        error(n->line, "conditional operands have incompatible types");
        t = int_type();
    }
    std::string r = new_temp();
    if (aggregate_result) {
        std::string name = unique_local("cond_obj");
        cur_->locals.push_back(name + " : " + type_str(t) + " (" + itos(size_of(t)) + ")");
        emit(r + " = &" + name, type_str(pointer_to(t)));
    }
    std::string lelse = new_label(), lend = new_label();
    std::string c = cond_value(n->kids[0]);
    emit("ifFalse " + c + " goto " + lelse);
    Val a = gen_expr(n->kids[1]);
    if (aggregate_result) {
        emit("copy " + r + ", " + addr_of(a) + ", " + itos(size_of(t)), type_str(t));
    } else if (!void_result) {
        std::string av = convert(rvalue(a), a.type, t);
        emit(r + " = " + av, type_str(t));
    }
    emit("goto " + lend);
    emit_label(lelse);
    Val b = gen_expr(n->kids[2]);
    if (aggregate_result) {
        emit("copy " + r + ", " + addr_of(b) + ", " + itos(size_of(t)), type_str(t));
    } else if (!void_result) {
        std::string bv = convert(rvalue(b), b.type, t);
        emit(r + " = " + bv, type_str(t));
    }
    emit_label(lend);
    Val out;
    out.k = aggregate_result ? Val::Addr : Val::RVal;
    out.place = void_result ? "0" : r;
    out.type = t;
    out.type.ref = false;
    return out;
}

// Evaluate call arguments left to right: default arguments, argument-count checks,
// reference binding, by-value object copies (copy constructor), conversions and
// variadic promotions.
// Comment: >30 lines because each kind of parameter is passed differently.
std::vector<std::string> CodeGen::eval_args(FuncInfo *fi, Node *args_in, int skip) {
    std::vector<std::string> places;
    Node empty_args;
    empty_args.kind = NK::DeclList;
    Node *args = args_in ? args_in : &empty_args;
    // C++ default arguments fill the trailing parameters the call leaves out
    Node full;
    if (fi && !fi->defaults.empty() && args->kids.size() + skip < fi->params.size()) {
        full = *args;
        for (size_t i = full.kids.size() + skip; i < fi->params.size(); ++i) {
            if (i >= fi->defaults.size() || !fi->defaults[i]) break;
            full.kids.push_back(fi->defaults[i]);
        }
        args = &full;
    }
    if (!args_in && args->kids.empty()) return places;
    if (fi && !fi->is_external) {
        size_t count = args->kids.size();
        size_t required = fi->params.size();
        if ((fi->variadic && count < required) || (!fi->variadic && count != required)) {
            error(args->line, (fi->name.empty() ? std::string("function pointer call") : "function '" + fi->name + "'") + " expects " +
                  (fi->variadic ? "at least " : "") + itos(required) +
                  " argument(s), got " + itos(count));
        }
    }
    for (size_t i = 0; i < args->kids.size(); ++i) {
        {   // f(8) where f takes V or const V&: build a V with its converting constructor
            size_t pi = i + skip;
            if (fi && pi < fi->params.size()) {
                TypeSpec pt = resolve(fi->params[pi]);
                bool by_value_or_const_ref = !pt.ref || pt.is_const;
                TypeSpec obj = pt;
                obj.ref = false;
                ClassInfo *pc = (obj.ptr == 0 && obj.dims.empty() && is_aggregate(obj)) ? class_of(obj) : nullptr;
                if (pc && pc->ctor && by_value_or_const_ref) {
                    TypeSpec at = type_of_expr(args->kids[i]);
                    if (!(is_aggregate(at) && at.ptr == 0 && at.dims.empty())) {
                        std::string tmp = unique_local("conv_arg");
                        cur_->locals.push_back(tmp + " : " + type_str(obj) + " (" + itos(size_of(obj)) + ")");
                        std::string addr = new_temp();
                        emit(addr + " = &" + tmp, type_str(pointer_to(obj)));
                        Node one;
                        one.kind = NK::DeclList;
                        one.line = args->kids[i]->line;
                        one.kids = {args->kids[i]};
                        call_ctor(pc, addr, &one);
                        if (pc->dtor) temp_dtors_.push_back({tmp, pc});
                        places.push_back(addr);
                        continue;
                    }
                }
            }
        }
        Val a = gen_expr(args->kids[i]);
        size_t pi = i + skip;
        bool have_param = fi && pi < fi->params.size();
        if (have_param && fi->params[pi].ref) {
            TypeSpec referent = fi->params[pi];
            referent.ref = false;
            TypeSpec at = a.type;
            at.ref = false;
            bool types_match = same_type(referent, at) ||
                (is_aggregate(referent) && is_aggregate(at) && derives_from(class_of(at), class_of(referent)));
            if (fi->params[pi].rref && is_lvalue_node(args->kids[i])) {
                error(args->kids[i]->line, "cannot bind rvalue reference of type '" + type_str(fi->params[pi]) + "' to lvalue of type '" + type_str(at) + "'");
                places.push_back("0");
            } else if ((a.k == Val::Var || a.k == Val::Addr) && !types_match && !fi->params[pi].is_const) {
                error(args->kids[i]->line, "reference parameter of type '" + type_str(fi->params[pi]) + "' cannot bind to an argument of type '" + type_str(at) + "'");
                places.push_back("0");
            } else if ((a.k == Val::Var || a.k == Val::Addr) && types_match) {
                if (is_aggregate(at)) base_accessible(args->kids[i]->line, class_of(at), class_of(referent));
                places.push_back(addr_of(a));
            } else if (fi->params[pi].is_const || fi->params[pi].rref) {
                if (!check_assignable(args->kids[i]->line, referent, a, "argument passing")) { places.push_back("0"); continue; }
                TypeSpec value_type = fi->params[pi];
                value_type.ref = value_type.rref = false;
                std::string tmp = unique_local("ref_arg");
                cur_->locals.push_back(tmp + " : " + type_str(value_type) + " (" + itos(size_of(value_type)) + ")");
                std::string value = convert(rvalue(a), a.type, value_type);
                emit(tmp + " = " + value, type_str(value_type));
                std::string address = new_temp();
                emit(address + " = &" + tmp, type_str(pointer_to(value_type)));
                places.push_back(address);
            } else {
                error(args->kids[i]->line, "non-const reference argument must be an lvalue");
                places.push_back("0");
            }
        } else if (is_aggregate(a.type)) {
            if (have_param && !check_assignable(args->kids[i]->line, fi->params[pi], a, "argument passing")) { places.push_back("0"); continue; }
            if (!a.temp_obj.empty()) {         // a temporary is passed as the argument object itself
                places.push_back(addr_of(a));
                continue;
            }
            std::string copy_name = unique_local("arg_copy");
            cur_->locals.push_back(copy_name + " : " + type_str(a.type) + " (" + itos(size_of(a.type)) + ")");
            std::string copy_addr = new_temp();
            emit(copy_addr + " = &" + copy_name, type_str(pointer_to(a.type)));
            ClassInfo *ac = class_of(a.type);
            // copy constructor only for named objects: a temporary (call result) is
            // moved by a byte copy, like the copy elision C++ compilers perform
            FuncInfo *cc = !ac ? nullptr : is_lvalue_node(args->kids[i]) ? copy_ctor_of(ac)
                         : is_move_call(args->kids[i]) ? (move_ctor_of(ac) ? move_ctor_of(ac) : copy_ctor_of(ac)) : nullptr;
            if (ac && ac->dtor) temp_dtors_.push_back({copy_name, ac});   // destroyed after the statement
            if (cc) {                       // pass by value through the copy constructor
                emit("param " + copy_addr);
                emit("param " + addr_of(a));
                emit("call " + cc->irname + ", 2");
            } else {
                emit("copy " + copy_addr + ", " + addr_of(a) + ", " + itos(size_of(a.type)), type_str(a.type));
            }
            places.push_back(copy_addr);
        } else {
            std::string v = rvalue(a);
            if (have_param) {
                if (a.k == Val::Lambda && fi->params[pi].base == Base::Func &&
                    a.lam && !a.lam->caps.empty())
                    error(args->kids[i]->line, "capturing lambda cannot convert to a function pointer");
                if (!check_assignable(args->kids[i]->line, fi->params[pi], a, "argument passing")) { places.push_back("0"); continue; }
                v = convert(v, a.type, fi->params[pi]);
            } else if (a.type.base == Base::Void && a.type.ptr == 0 && a.type.dims.empty()) {
                error(args->kids[i]->line, "void value used as an argument");
            }
            else if (fi && fi->variadic && a.type.base == Base::Float && a.type.ptr == 0) {
                TypeSpec d; d.base = Base::Double;
                v = convert(v, a.type, d);
            } else if (fi && fi->variadic && a.type.ptr == 0 && a.type.dims.empty() &&
                       (a.type.base == Base::Bool || a.type.base == Base::Char ||
                        a.type.base == Base::Short || a.type.base == Base::Enum)) {
                TypeSpec promoted = int_type();
                v = convert(v, a.type, promoted);
            }
            places.push_back(v);
        }
    }
    return places;
}

// Emit `param`s and the call; a class object returned by value is moved into a
// caller temporary that is destroyed at the end of the statement.
// Comment: >30 lines because of void, scalar, reference and object results.
Val CodeGen::emit_call(FuncInfo *fi, const std::string &callee, const std::vector<std::string> &args,
                       bool indirect) {
    // a prototype that is never defined in this file refers to a library function
    if (fi && !indirect && !fi->defined && !fi->is_external && !fi->cls &&
        std::find(mod_.externs.begin(), mod_.externs.end(), fi->irname) == mod_.externs.end())
        mod_.externs.push_back(fi->irname);
    for (const std::string &a : args) emit("param " + a);
    std::string target = (indirect ? "*" : "") + callee;
    Val out;
    out.k = Val::RVal;
    TypeSpec ret = fi ? fi->ret : int_type();
    out.type = ret;
    bool returns_ref = ret.ref;
    if (returns_ref) out.type.ref = false;
    if (ret.base == Base::Void && ret.ptr == 0 && ret.dims.empty()) {
        emit("call " + target + ", " + itos(args.size()));
        out.place = "0";
    } else {
        out.place = new_temp();
        emit(out.place + " = call " + target + ", " + itos(args.size()),
             type_str(returns_ref ? pointer_to(ret) : ret));
        if (is_aggregate(ret) || returns_ref) out.k = Val::Addr;
        ClassInfo *rc = (!returns_ref && is_aggregate(ret) && ret.ptr == 0) ? class_of(ret) : nullptr;
        if (rc && rc->dtor) {
            // an object returned by value is a temporary of the caller: move it out
            // of the callee's dead frame and destroy it at the end of the statement
            std::string name = unique_local("ret_tmp");
            cur_->locals.push_back(name + " : " + type_str(ret) + " (" + itos(size_of(ret)) + ")");
            std::string a = new_temp();
            emit(a + " = &" + name, type_str(pointer_to(ret)));
            emit("copy " + a + ", " + out.place + ", " + itos(size_of(ret)), type_str(ret));
            out.place = a;
            out.temp_obj = name;
            temp_dtors_.push_back({name, rc});
        }
    }
    return out;
}

// How well an argument of type `arg` fits a parameter of type `param`:
// 3 exact, 2 same category (integer/integer, compatible pointers),
// 1 needs an arithmetic conversion, -1 not convertible.
int CodeGen::conversion_score(const TypeSpec &param_in, const TypeSpec &arg_in) {
    TypeSpec p = resolve(param_in), a = resolve(arg_in);
    p.ref = false;
    a.ref = false;
    if (p.decayed) p = pointer_to(p);
    if (!a.dims.empty()) { a = elem_type(a); a = pointer_to(a); }
    bool scalar_pair = p.ptr == 0 && a.ptr == 0 && p.dims.empty() && a.dims.empty() &&
                       !is_aggregate(p) && !is_aggregate(a);
    if (scalar_pair) {
        if (p.base == a.base && p.is_unsigned == a.is_unsigned && p.name == a.name) return 3;   // exact
        // integral promotion (bool/char/short/enum -> int) and float -> double
        bool small_int = a.base == Base::Bool || a.base == Base::Char || a.base == Base::Short || a.base == Base::Enum;
        if (p.base == Base::Int && !p.is_unsigned && small_int) return 2;
        if (p.base == Base::Double && a.base == Base::Float) return 2;
        if ((is_integer(p) || is_float(p)) && (is_integer(a) || is_float(a))) return 1;      // conversion
    }
    if (same_type(p, a)) return 3;
    bool pp = is_pointer(p) || p.base == Base::Func, ap = is_pointer(a) || a.base == Base::Func;
    if (pp && ap) {
        if (p.base == Base::Void || a.base == Base::Void) return 2;
        ClassInfo *pc = class_of(p), *ac = class_of(a);
        if (pc && ac && derives_from(ac, pc)) return 2;
        return 1;
    }
    if (pp || ap) return (pp && is_integer(a)) ? 0 : -1;
    if (is_aggregate(p) || is_aggregate(a)) {
        ClassInfo *pc = class_of(p), *ac = class_of(a);
        if (pc && ac && derives_from(ac, pc)) return 2;
        return -1;
    }
    if (is_integer(p) && is_integer(a)) return 2;
    if (is_float(p) && is_float(a)) return 2;
    return 1;
}

// Choose the overload of `head` that best matches the call's arguments.
FuncInfo *CodeGen::pick_overload(FuncInfo *head, Node *args, int line) {
    if (!head || !head->next_overload) return head;
    size_t n = args ? args->kids.size() : 0;
    std::vector<TypeSpec> types;
    for (size_t i = 0; i < n; ++i) types.push_back(type_of_expr(args->kids[i]));
    FuncInfo *best = nullptr;
    int best_score = -1000000;
    bool ambiguous = false;
    for (FuncInfo *c = head; c; c = c->next_overload) {
        size_t min_args = c->params.size();
        while (min_args > 0 && min_args - 1 < c->defaults.size() && c->defaults[min_args - 1]) --min_args;
        if (c->variadic ? n < min_args : (n < min_args || n > c->params.size())) continue;
        int score = 0;
        for (size_t i = 0; i < n && i < c->params.size() && score >= 0; ++i) {
            int k = conversion_score(c->params[i], types[i]);
            if (k >= 0 && c->params[i].rref) k = is_lvalue_node(args->kids[i]) ? -1 : k + 1;   // T&& binds rvalues
            score = k < 0 ? -1 : score + k;
        }
        if (score < 0) continue;
        if (c->variadic) score -= 1;
        if (score > best_score) { best = c; best_score = score; ambiguous = false; }
        else if (score == best_score) ambiguous = true;
    }
    if (!best) {
        error(line, "no overload of '" + head->name + "' matches " + itos(n) + " argument(s)");
        return head;
    }
    if (ambiguous) error(line, "call of overloaded '" + head->name + "' is ambiguous");
    return best;
}

// The user-declared copy constructor T(const T&) of a class, if any.
FuncInfo *CodeGen::copy_ctor_of(ClassInfo *ci) {
    for (FuncInfo *c = ci->ctor; c; c = c->next_overload) {
        if (c->params.size() < 1) continue;
        bool rest_default = true;
        for (size_t i = 1; i < c->params.size(); ++i)
            if (i >= c->defaults.size() || !c->defaults[i]) rest_default = false;
        TypeSpec p = resolve(c->params[0]);
        if (rest_default && p.ref && !p.rref && p.ptr == 0 && class_of(p) == ci) return c;
    }
    return nullptr;
}

// Construct the object at `this_place`: pick the constructor overload, check access, or
// zero-fill/set the vptr for classes without a constructor.
// Comment: >30 lines because of the no-constructor and overload paths.
void CodeGen::call_ctor(ClassInfo *ci, const std::string &this_place, Node *args) {
    if (!ci->ctor) {
        if (args && !args->kids.empty())
            error(0, "class '" + ci->name + "' has no matching constructor");
        if (args && args->kids.empty()) {
            TypeSpec t;
            t.base = ci->kind;
            t.name = ci->name;
            zero_initialize(this_place, t);
        }
        if (ci->has_vptr) {
            std::string vt = new_temp();
            emit(vt + " = &vtable_" + ci->name, "ptr");
            emit("*" + offset_addr(this_place, ci->vptr_offset) + " = " + vt, "ptr");
        }
        return;
    }
    FuncInfo *ctor = ci->ctor;
    if (ctor->next_overload) {
        Node none;
        none.kind = NK::DeclList;
        ctor = pick_overload(ci->ctor, args ? args : &none, cur_line_);
    }
    if (!can_access(ctor->access, ci))
        error(0, "constructor of '" + ci->name + "' is not accessible here");
    if (!args && !ctor->params.empty() && (ctor->defaults.empty() || !ctor->defaults[0]))
        error(0, "class '" + ci->name + "' has no default constructor");
    std::vector<std::string> a = eval_args(ctor, args, 0);
    a.insert(a.begin(), this_place);
    emit_call(ctor, ctor->irname, a, false);
}

Val CodeGen::construct_temp(ClassInfo *ci, Node *args) {
    TypeSpec t;
    t.base = ci->kind;
    t.name = ci->name;
    std::string name = unique_local("obj");
    cur_->locals.push_back(name + " : " + type_str(t) + " (" + itos(ci->size) + ")");
    std::string a = new_temp();
    emit(a + " = &" + name, type_str(pointer_to(t)));
    if (args && args->kids.empty() && ci->ctor && !ci->ctor->def)
        zero_initialize(a, t);
    call_ctor(ci, a, args);
    Val v;
    v.k = Val::Addr;
    v.place = a;
    v.type = t;
    if (ci->dtor) {                       // Obj(5) is destroyed at the end of the statement
        temp_dtors_.push_back({name, ci});
        v.temp_obj = name;
    }
    return v;
}

// Generate a call: constructor temporaries, functional casts, va_start, direct and
// overloaded calls, method calls (virtual through the vtable), function pointers, lambdas.
// Comment: >30 lines because every callee kind is lowered differently.
Val CodeGen::gen_call(Node *n) {
    Node *callee = n->kids[0];
    Node *args = n->kids[1];
    Val out;

    if (is_move_call(n)) return gen_expr(args->kids[0]);   // std::move(x): x, used as an rvalue

    // constructor call producing a temporary object
    if (callee->kind == NK::TypeName) {
        ClassInfo *ci = class_of(callee->str);
        if (!ci) {
            TypeSpec t;
            t.base = Base::Named;
            t.name = callee->str;
            t = resolve(t);
            ci = class_of(t);
        }
        if (ci) return construct_temp(ci, args);
        // functional cast on a typedef, e.g. Count(5)
        TypeSpec t;
        t.base = Base::Named;
        t.name = callee->str;
        t = resolve(t);
        Val a = args->kids.empty() ? Val() : gen_expr(args->kids[0]);
        out.k = Val::RVal;
        out.place = args->kids.empty() ? "0" : convert(rvalue(a), a.type, t);
        out.type = t;
        return out;
    }

    // va_start intrinsic: the address of the first unnamed incoming argument
    if (callee->kind == NK::Ident && callee->str == "__builtin_va_start") {
        if (!cur_fn_ || !cur_fn_->variadic)
            error(n->line, "va_start used in a function without '...' parameters");
        out.k = Val::RVal;
        out.place = new_temp();
        out.type.base = Base::Char;
        out.type.ptr = 1;
        emit(out.place + " = &__va_args", "char*");
        return out;
    }

    Val c;
    if (callee->kind == NK::Ident && !lookup(callee->str) &&
        !(cur_class_ && (find_field(cur_class_, callee->str) || find_method(cur_class_, callee->str))) &&
        !find_function(callee->str)) {
        c.k = Val::Func;
        c.fn = external(callee->str);
    } else {
        c = gen_expr(callee);
    }

    if ((c.k == Val::Func || c.k == Val::Method) && c.fn && c.fn->next_overload)
        c.fn = pick_overload(c.fn, args, n->line);
    if (c.k == Val::Func) {
        std::vector<std::string> a = eval_args(c.fn, args, 0);
        return emit_call(c.fn, c.fn->irname, a, false);
    }
    if (c.k == Val::Method) {
        FuncInfo *m = c.fn;
        std::vector<std::string> a = eval_args(m, args, 0);
        if (!m->is_static) a.insert(a.begin(), c.this_place);
        bool direct = c.cls != nullptr;   // Class::method()
        if (m->is_virtual && !m->is_static && !direct) {
            ClassInfo *ci = m->cls;
            std::string vptr_addr = offset_addr(c.this_place, ci->vptr_offset);
            std::string vt = new_temp();
            emit(vt + " = *" + vptr_addr, "ptr");
            std::string slot = offset_addr(vt, m->vindex * 4);
            std::string fp = new_temp();
            emit(fp + " = *" + slot, "fn*");
            return emit_call(m, fp, a, true);
        }
        return emit_call(m, m->irname, a, false);
    }
    if (c.k == Val::Lambda) {
        LambdaInfo *lam = c.lam;
        FuncInfo call_info = *lam->fn;
        size_t capture_count = std::min(lam->caps.size(), call_info.params.size());
        call_info.params.resize(call_info.params.size() - capture_count);
        call_info.pnames.resize(call_info.params.size());
        std::vector<std::string> a = eval_args(&call_info, args, 0);
        for (auto &cap : lam->caps) a.push_back(cap.holder);
        return emit_call(lam->fn, lam->fn->irname, a, false);
    }
    // call through a function pointer
    if (c.type.base != Base::Func) {
        if (!c.bad) error(n->line, "called object is not a function or function pointer");
        out.k = Val::RVal;
        out.place = "0";
        out.type = int_type();
        return out;
    }
    std::string fp = rvalue(c);
    FuncInfo tmp;
    tmp.ret = c.type.ret ? resolve(*c.type.ret) : int_type();
    for (TypeSpec *p : c.type.params) tmp.params.push_back(resolve(*p));
    tmp.variadic = c.type.variadic;
    std::vector<std::string> a = eval_args(&tmp, args, 0);
    Val r = emit_call(&tmp, fp, a, true);
    return r;
}

// Array subscripts a[i] (and pointer subscripts), scaled by the element size.
// Comment: >30 lines because arrays, decayed parameters and pointers differ.
Val CodeGen::gen_index(Node *n) {
    Val base = gen_expr(n->kids[0]);
    std::string ba;
    TypeSpec et;
    if (is_array(base.type)) {
        ba = base.k == Val::Var ? addr_of(base) : base.place;
        et = elem_type(base.type);
    } else if (is_pointer(base.type)) {
        ba = rvalue(base);
        et = elem_type(base.type);
    } else {
        error(n->line, "subscript on non-array");
        ba = rvalue(base);
        et = int_type();
    }
    Val idx = gen_expr(n->kids[1]);
    bool integer_index = idx.type.ptr == 0 && idx.type.dims.empty() &&
        (idx.type.base == Base::Bool || idx.type.base == Base::Char ||
         idx.type.base == Base::Short || idx.type.base == Base::Int ||
         idx.type.base == Base::Long || idx.type.base == Base::Enum);
    if (!integer_index) error(n->kids[1]->line, "array subscript must have an integer type");
    if (size_of(et) <= 0) { error(n->line, "cannot subscript an array of incomplete or void type"); et = int_type(); }
    std::string iv = rvalue(idx);
    int es = size_of(et);
    std::string off = iv;
    if (idx.is_const) {
        off = itos(idx.cval * es);
    } else if (es != 1) {
        off = emit_binop(iv, "*", itos(es), int_type());
    }
    Val out;
    out.k = Val::Addr;
    out.type = et;
    if (off == "0") out.place = ba;
    else out.place = emit_binop(ba, "+", off, pointer_to(et));
    return out;
}

// Member access obj.f / ptr->f: fields at their offset, methods bound to `this`,
// static members, access checks.
// Comment: >30 lines because of fields, methods and static members.
Val CodeGen::gen_member(Node *n, bool arrow) {
    Val obj = gen_expr(n->kids[0]);
    std::string base;
    TypeSpec ot = obj.type;
    ot.ref = false;
    if (arrow) {
        base = rvalue(obj);
        if (is_array(ot)) ot = pointer_to(ot);
        ot = elem_type(ot);
    } else {
        base = addr_of(obj);
    }
    ClassInfo *ci = class_of(ot);
    Val out;
    if (!ci) {
        error(n->line, "member access on non-aggregate '" + n->str + "'");
        out.k = Val::RVal;
        out.place = "0";
        out.type = int_type();
        out.bad = true;
        return out;
    }
    const Field *f = find_field(ci, n->str);
    if (f) {
        if (!can_access(f->access, f->owner, class_of(ot)))
            error(n->line, "member '" + n->str + "' is not accessible here");
        if (f->is_static) {
            out.k = Val::Var;
            out.place = f->irname;
        } else {
            out.k = Val::Addr;
            std::string field_addr = offset_addr(base, f->offset, type_str(pointer_to(f->type)));
            if (f->type.ref) {
                out.place = new_temp();
                emit(out.place + " = *" + field_addr, type_str(pointer_to(f->type)));
            } else {
                out.place = field_addr;
            }
            out.bit_width = f->bit_width;
            out.bit_offset = f->bit_offset;
        }
        out.type = f->type;
        out.type.ref = false;
        return out;
    }
    FuncInfo *m = find_method(ci, n->str);
    if (m) {
        if (!can_access(m->access, m->cls, class_of(ot)))
            error(n->line, "member '" + n->str + "' is not accessible here");
        out.k = Val::Method;
        out.fn = m;
        if (!m->is_static) out.this_place = base;
        out.type = m->ret;
        return out;
    }
    error(n->line, "no member '" + n->str + "' in " + ci->name);
    out.k = Val::RVal;
    out.place = "0";
    out.type = int_type();
    out.bad = true;
    return out;
}

// new T, new T(args), new T[n]: __fns_new (malloc that ends the program like an
// uncaught bad_alloc) plus constructor calls (with an element count header for arrays).
// Comment: >30 lines because scalar, object and array forms differ.
Val CodeGen::gen_new(Node *n) {
    TypeSpec t = resolve(*n->type);
    if (size_of(t) <= 0) error(n->line, "cannot allocate an incomplete or void type");
    FuncInfo *new_fn = external("__fns_new");
    Val out;
    out.k = Val::RVal;
    out.type = pointer_to(t);
    if (n->flags & F_ARRAY) {
        Val cnt = gen_expr(n->kids[0]);
        bool integer_count = cnt.type.ptr == 0 && cnt.type.dims.empty() &&
            (cnt.type.base == Base::Bool || cnt.type.base == Base::Char ||
             cnt.type.base == Base::Short || cnt.type.base == Base::Int ||
             cnt.type.base == Base::Long || cnt.type.base == Base::Enum);
        if (!integer_count) error(n->line, "array allocation count must have an integer type");
        std::string count = convert(rvalue(cnt), cnt.type, int_type());
        Val allocation = emit_call(new_fn, "__fns_new", {count, itos(size_of(t)), "4"}, false);
        emit("*" + allocation.place + " = " + count, "int");
        out.place = offset_addr(allocation.place, 4, type_str(pointer_to(t)));
        ClassInfo *ci = is_aggregate(t) ? class_of(t) : nullptr;
        if (ci && ci->ctor) {
            std::string index = new_temp();
            emit(index + " = 0", "int");
            std::string loop = new_label(), done = new_label();
            emit_label(loop);
            std::string finished = emit_binop(index, ">=", count, int_type());
            emit("if " + finished + " goto " + done);
            std::string offset = emit_binop(index, "*", itos(size_of(t)), int_type());
            std::string element = emit_binop(out.place, "+", offset, pointer_to(t));
            call_ctor(ci, element, nullptr);
            std::string next = emit_binop(index, "+", "1", int_type());
            emit(index + " = " + next, "int");
            emit("goto " + loop);
            emit_label(done);
        }
        return out;
    }
    Val r = emit_call(new_fn, "__fns_new", {"1", itos(size_of(t)), "0"}, false);
    out.place = r.place;
    ClassInfo *ci = is_aggregate(t) ? class_of(t) : nullptr;
    if (ci) {
        Node args;
        args.kind = NK::DeclList;
        args.kids = n->kids;
        if ((n->flags & F_VALUE_INIT) && args.kids.empty() && ci->ctor && !ci->ctor->def)
            zero_initialize(r.place, t);
        call_ctor(ci, r.place, &args);
    } else if (!n->kids.empty()) {
        Val v = gen_expr(n->kids[0]);
        emit("*" + r.place + " = " + convert(rvalue(v), v.type, t), type_str(t));
    } else if (n->flags & F_VALUE_INIT) {
        zero_initialize(r.place, t);
    }
    return out;
}

// delete / delete[]: null check, (virtual) destructor calls in reverse order, free.
// Comment: >30 lines because of the array loop and virtual destructor dispatch.
Val CodeGen::gen_delete(Node *n) {
    Val p = gen_expr(n->kids[0]);
    std::string pv = rvalue(p);
    TypeSpec pt = p.type;
    ClassInfo *ci = is_pointer(pt) ? class_of(elem_type(pt)) : nullptr;
    if (!is_pointer(pt)) error(n->line, "delete requires a pointer operand");
    if ((n->flags & F_ARRAY) && is_pointer(pt) && size_of(elem_type(pt)) <= 0)
        error(n->line, "delete[] requires a complete object type");
    std::string free_ptr = pv;
    FuncInfo *free_fn = external("free");
    bool needs_guard = (n->flags & F_ARRAY) || (ci && ci->dtor);
    std::string lskip;
    if (needs_guard) {
        lskip = new_label();
        emit("ifFalse " + pv + " goto " + lskip);
    }
    auto call_destructor = [&](ClassInfo *target, const std::string &object) {
        if (!target || !target->dtor) return;
        if (target->dtor->is_virtual) {
            std::string vptr_addr = offset_addr(object, target->vptr_offset);
            std::string vt = new_temp();
            emit(vt + " = *" + vptr_addr, "ptr");
            std::string slot = offset_addr(vt, target->dtor->vindex * 4);
            std::string fp = new_temp();
            emit(fp + " = *" + slot, "fn*");
            emit_call(target->dtor, fp, {object}, true);
        } else {
            emit("param " + object);
            emit("call " + target->dtor->irname + ", 1");
        }
    };
    if (n->flags & F_ARRAY) {
        free_ptr = emit_binop(pv, "-", "4", pointer_to(elem_type(pt)));
        if (ci && ci->dtor) {
            if (!can_access(ci->dtor->access, ci))
                error(n->line, "destructor of '" + ci->name + "' is not accessible here");
            std::string count = load(free_ptr, int_type());
            std::string index = new_temp();
            emit(index + " = " + count, "int");
            std::string loop = new_label(), done = new_label();
            emit_label(loop);
            std::string finished = emit_binop(index, "<=", "0", int_type());
            emit("if " + finished + " goto " + done);
            std::string previous = emit_binop(index, "-", "1", int_type());
            emit(index + " = " + previous, "int");
            std::string offset = emit_binop(index, "*", itos(size_of(elem_type(pt))), int_type());
            std::string object = emit_binop(pv, "+", offset, pointer_to(elem_type(pt)));
            call_destructor(ci, object);
            emit("goto " + loop);
            emit_label(done);
        }
    } else if (ci && ci->dtor) {
        if (!can_access(ci->dtor->access, ci))
            error(n->line, "destructor of '" + ci->name + "' is not accessible here");
        call_destructor(ci, pv);
    }
    emit_call(free_fn, "free", {free_ptr}, false);
    if (needs_guard) emit_label(lskip);
    Val out;
    out.k = Val::RVal;
    out.place = "0";
    out.type.base = Base::Void;
    return out;
}

// An array parameter's first bound is ignored (it decays to a pointer), so it may be
// any expression, e.g. another parameter: void f(int n, int a[n]).
TypeSpec CodeGen::open_first_dim(TypeSpec t) {
    if (!t.dims.empty() && !t.ref) t.dims[0] = -1;
    return t;
}

TypeSpec CodeGen::decay_param(const TypeSpec &t) {
    if (!is_array(t) || t.ref) return t;
    TypeSpec d = t;
    d.decayed = true;
    d.dims[0] = -1;
    return d;
}

bool CodeGen::is_integer(const TypeSpec &t) const {
    return t.ptr == 0 && t.dims.empty() &&
           (t.base == Base::Bool || t.base == Base::Char || t.base == Base::Short ||
            t.base == Base::Int || t.base == Base::Long || t.base == Base::Enum);
}

bool CodeGen::is_scalar(const TypeSpec &t) const {
    return is_pointer(t) || is_array(t) || is_float(t) || is_integer(t) ||
           t.base == Base::Func || t.base == Base::Lambda;
}

bool CodeGen::derives_from(ClassInfo *derived, ClassInfo *base) {
    for (ClassInfo *c = derived; c; c = c->base)
        if (c == base) return true;
    return false;
}

bool CodeGen::same_type(const TypeSpec &a_in, const TypeSpec &b_in) {
    TypeSpec a = resolve(a_in), b = resolve(b_in);
    if (a.decayed) a = pointer_to(a);
    if (b.decayed) b = pointer_to(b);
    if (a.base == Base::Func && b.base == Base::Func) return true;
    return a.base == b.base && a.name == b.name && a.ptr == b.ptr && a.ref == b.ref &&
           (!a.ref || a.rref == b.rref) && a.dims == b.dims;
}

// Reports and returns false when a value of type `from` cannot be stored in an object
// of type `to` (assignment, initialisation, argument passing, return).
bool CodeGen::check_assignable(int line, const TypeSpec &to_in, const Val &from, const char *what) {
    TypeSpec to = resolve(to_in);
    to.ref = false;
    TypeSpec ft = resolve(from.type);
    ft.ref = false;
    if (from.k == Val::Func || from.k == Val::Lambda) ft.base = Base::Func, ft.ptr = 1, ft.dims.clear();
    if (to.base == Base::Auto) return true;
    if (ft.base == Base::Void && ft.ptr == 0 && ft.dims.empty()) {
        error(line, std::string("void value used in ") + what);
        return false;
    }
    if (is_array(to) && !to.decayed) {
        error(line, std::string("cannot assign to an array in ") + what);
        return false;
    }
    if (is_aggregate(to) || is_aggregate(ft)) {
        if (is_aggregate(to) && is_aggregate(ft)) {
            ClassInfo *tc = class_of(to), *fc = class_of(ft);
            if (tc && fc && (tc == fc || derives_from(fc, tc))) return base_accessible(line, fc, tc);
        }
        error(line, std::string("incompatible types in ") + what + ": cannot convert '" + type_str(ft) + "' to '" + type_str(to) + "'");
        return false;
    }
    TypeSpec fdecay = is_array(ft) ? pointer_to(ft) : ft;
    if (to.ptr == 1 && fdecay.ptr == 1 && class_of(to) && class_of(fdecay) &&
        derives_from(class_of(fdecay), class_of(to)))
        return base_accessible(line, class_of(fdecay), class_of(to));
    bool to_ptr = is_pointer(to) || to.base == Base::Func;
    bool from_ptr = is_pointer(fdecay) || fdecay.base == Base::Func || fdecay.base == Base::Lambda;
    if ((to_ptr && is_float(fdecay)) || (is_float(to) && from_ptr)) {
        error(line, std::string("incompatible types in ") + what + ": cannot convert '" + type_str(ft) + "' to '" + type_str(to) + "'");
        return false;
    }
    return true;
}

// Evaluates a controlling expression and checks that it has scalar type.
std::string CodeGen::cond_value(Node *n) {
    Val v = gen_expr(n);
    TypeSpec t = v.type;
    t.ref = false;
    if (v.k != Val::Func && v.k != Val::Lambda && !is_scalar(t))
        error(n->line, "condition must have a scalar type, got '" + type_str(t) + "'");
    return rvalue(v);
}

std::string CodeGen::user_label(const std::string &name) {
    // Generated labels are L<number>; keep user labels distinct from them.
    bool clash = name.size() > 1 && name[0] == 'L';
    for (size_t i = 1; clash && i < name.size(); ++i) clash = std::isdigit(static_cast<unsigned char>(name[i])) != 0;
    return clash ? name + "_" : name;
}

// The expression of the first `return expr;` in a body (not inside nested lambdas).
Node *first_return_value(Node *n) {
    if (!n || n->kind == NK::Lambda) return nullptr;
    if (n->kind == NK::Return) return n->kids.empty() ? nullptr : n->kids[0];
    for (Node *k : n->kids) {
        Node *r = first_return_value(k);
        if (r) return r;
    }
    return nullptr;
}

// A lambda becomes a top-level function lambda_N whose captured variables are extra
// trailing parameters; captures are copied or addressed at the creation point.
// Comment: >30 lines because of the capture bookkeeping.
Val CodeGen::gen_lambda(Node *n) {
    LambdaInfo *lam = new LambdaInfo;
    lam->mode = n->str;
    lam->is_mutable = (n->flags & F_MUTABLE) != 0;
    FuncInfo *fi = new FuncInfo;
    fi->name = fi->irname = "lambda_" + itos(++lambda_counter_);
    fi->defined = true;
    if (n->type) fi->ret = resolve(*n->type);
    else { fi->ret = int_type(); fi->deduce_ret = true; }   // deduced from the body's return
    for (Node *p : n->kids[0]->kids) {
        if (p->kind == NK::Ellipsis) { fi->variadic = true; continue; }
        TypeSpec pt = decay_param(resolve(open_first_dim(*p->type)));
        if (pt.base == Base::Void && pt.ptr == 0 && p->str.empty()) continue;
        fi->params.push_back(pt);
        fi->pnames.push_back(p->str);
    }
    lam->fn = fi;

    Val out;
    out.k = Val::Lambda;
    out.lam = lam;
    out.type.base = Base::Lambda;
    if (in_sizeof_) return out;

    // Generate the body as a separate function, capturing enclosing locals on demand.
    Node fake;
    fake.kind = NK::FuncDef;
    fake.kids = {n->kids[0], nullptr, n->kids[1]};
    fi->def = &fake;
    LambdaInfo *saved_lambda = cur_lambda_;
    std::vector<std::pair<std::string, std::string>> saved_loops = loops_;
    loops_.clear();
    cur_lambda_ = lam;
    ClassInfo *saved_cls = cur_class_;
    cur_class_ = nullptr;
    gen_function(fi);
    cur_class_ = saved_cls;
    cur_lambda_ = saved_lambda;
    loops_ = saved_loops;
    fi->def = nullptr;

    // Copy captured values (or addresses) into hidden locals at the creation point.
    for (auto &cap : lam->caps) {
        Symbol *s = lookup(cap.name);
        if (!s) continue;
        Val sv;
        sv.k = s->type.ref ? Val::Addr : Val::Var;
        sv.place = s->irname;
        sv.type = s->type;
        sv.type.ref = false;
        TypeSpec ht = cap.by_ref || s->type.ref ? pointer_to(sv.type) : sv.type;
        cur_->locals.push_back(cap.holder + " : " + type_str(ht) + " (" + itos(size_of(ht)) + ")");
        if (cap.by_ref || s->type.ref) {
            emit(cap.holder + " = " + addr_of(sv), type_str(ht));
        } else if (lam->is_mutable) {          // the lambda's own copy, passed by address
            cur_->locals.back() = cap.holder + "_copy : " + type_str(ht) + " (" + itos(size_of(ht)) + ")";
            cur_->locals.push_back(cap.holder + " : " + type_str(pointer_to(ht)) + " (4)");
            emit(cap.holder + "_copy = " + rvalue(sv), type_str(ht));
            emit(cap.holder + " = &" + cap.holder + "_copy", type_str(pointer_to(ht)));
        } else {
            emit(cap.holder + " = " + rvalue(sv), type_str(ht));
        }
    }
    return out;
}

}
