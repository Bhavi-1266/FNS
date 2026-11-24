#ifndef FNS_CODEGEN_HPP
#define FNS_CODEGEN_HPP

#include <map>
#include <set>
#include <string>
#include <vector>

#include "ast.hpp"
#include "ir.hpp"

namespace fns {

struct ClassInfo;

struct FuncInfo {
    std::string name;
    std::string irname;
    TypeSpec ret;
    std::vector<TypeSpec> params;
    std::vector<std::string> pnames;
    bool variadic = false;
    bool is_virtual = false;
    bool is_pure = false;
    bool is_ctor = false;
    bool is_dtor = false;
    bool is_static = false;
    bool is_external = false;
    bool is_lib = false;      // prototype from the built-in library prelude
    bool deduce_ret = false;  // lambda without `-> T`: return type comes from the body
    FuncInfo *next_overload = nullptr;   // next function/method/ctor with the same name
    std::vector<Node *> defaults;        // default-argument expressions (nullptr = none)
    bool defined = false;
    int access = 0; // public=0, private=1, protected=2
    int vindex = -1;
    ClassInfo *cls = nullptr;
    Node *def = nullptr;
};

struct Field {
    std::string name;
    TypeSpec type;
    int offset = 0;
    int access = 0; // public=0, private=1, protected=2
    ClassInfo *owner = nullptr;
    bool is_static = false;
    std::string irname;
    Node *init = nullptr;     // default member initializer (`int v = 5;`)
};

struct ClassInfo {
    std::string name;
    Base kind = Base::Struct;
    ClassInfo *base = nullptr;
    int base_access = 0;                        // public=0, private=1, protected=2 inheritance
    std::vector<Field> fields;                  // includes inherited fields
    std::map<std::string, FuncInfo *> methods;  // own methods only
    std::vector<FuncInfo *> vtable;
    bool has_vptr = false;
    int vptr_offset = 0;
    int size = 0;
    FuncInfo *ctor = nullptr;
    FuncInfo *dtor = nullptr;
    int def_line = 0;
    bool laid_out = false;
};

struct LambdaInfo {
    FuncInfo *fn = nullptr;
    struct Cap {
        std::string name;
        bool by_ref = false;
        std::string holder;   // hidden local in the enclosing function
        TypeSpec type;
    };
    std::vector<Cap> caps;
    std::string mode;         // "", "&", "=", or comma list
    bool is_mutable = false;  // copies may be changed, and keep their value between calls
};

struct Symbol {
    enum Kind { Var, EnumConst, Lambda } kind = Var;
    std::string name;
    std::string irname;
    TypeSpec type;
    long value = 0;
    LambdaInfo *lam = nullptr;
    int func_depth = 0;
    bool is_global = false;
    bool const_int = false;   // const integer with a constant initializer (value)
};

struct Scope {
    std::map<std::string, Symbol> syms;
    std::vector<std::pair<std::string, ClassInfo *>> dtors;   // local objects to destroy at exit
    int func_depth = 0;
};

struct Val {
    enum K { None, RVal, Var, Addr, Func, Method, Type, Lambda } k = None;
    std::string place;
    TypeSpec type;
    FuncInfo *fn = nullptr;
    std::string this_place;
    bool is_const = false;
    long cval = 0;
    ClassInfo *cls = nullptr;
    LambdaInfo *lam = nullptr;
    bool bad = false;      // produced by an expression that already reported an error
    bool row_ptr = false;  // address of a row of a multi-dimensional array (type = the row)
    std::string temp_obj;  // unnamed temporary object (destroyed at the end of the statement)
};

class CodeGen {
public:
    explicit CodeGen(Module &m) : mod_(m) {}
    void generate(Node *program);
    // Names declared by the built-in prelude; a user definition overrides them.
    void set_library_prototypes(const std::set<std::string> &names) { lib_protos_ = names; }
    // C++ sources allow function overloading; C sources report a conflict.
    void set_cplusplus(bool on) { cplusplus_ = on; }

private:
    // ---- module-level passes ----
    void declare_toplevel(Node *n);
    void declare_function(Node *n, ClassInfo *cls);
    void declare_global_var(Node *n, const std::string &irname_prefix, bool register_symbol = true,
                            bool construct = true);
    void define_static_member(Node *n);
    void process_aggregate(Node *n);
    void process_enum(Node *n);
    void layout_class(ClassInfo *ci, Node *def);
    void gen_pending_bodies();
    void gen_function(FuncInfo *fi);

    // ---- statements ----
    void gen_stmt(Node *n);
    void gen_stmt_inner(Node *n);
    void flush_temp_dtors();
    void gen_block(Node *n, bool new_scope);
    void gen_local_decl(Node *n);
    void emit_scope_dtors(size_t depth, const std::string &keep = "");
    void for_each_element(const std::string &base, ClassInfo *ci, int count, bool destroy, bool at_exit = false);
    void gen_var_init(const Symbol &sym, const TypeSpec &t, Node *init);
    void init_aggregate(const std::string &base_addr, const TypeSpec &t, Node *list);
    void fill_aggregate(const std::string &base, const TypeSpec &t, Node *list, size_t &idx, bool braced);
    void init_member(const std::string &a, const TypeSpec &t, Node *list, size_t &idx);
    bool needs_elision(const TypeSpec &t, Node *k);
    int scalar_leaves(const TypeSpec &t);
    int inferred_bound(const TypeSpec &t, Node *init);
    void zero_initialize(const std::string &base_addr, const TypeSpec &t);
    void gen_if(Node *n);
    void gen_for(Node *n);
    void gen_range_for(Node *n);
    void gen_while(Node *n);
    void gen_do(Node *n, bool until);
    void gen_switch(Node *n);
    void gen_return(Node *n);

    // ---- expressions ----
    Val gen_expr(Node *n);
    Val gen_ident(Node *n);
    Val gen_binary(Node *n);
    Val gen_logical(Node *n);
    Val gen_unary(Node *n);
    Val gen_assign(Node *n);
    Val gen_incdec(Node *target, const std::string &op, bool prefix);
    Val gen_cond(Node *n);
    Val gen_call(Node *n);
    Val gen_index(Node *n);
    Val gen_member(Node *n, bool arrow);
    Val gen_new(Node *n);
    Val gen_delete(Node *n);
    Val gen_lambda(Node *n);
    Val gen_literal(Node *n);
    Val construct_temp(ClassInfo *ci, Node *args);
    void call_ctor(ClassInfo *ci, const std::string &this_place, Node *args);
    void init_string(const std::string &base_addr, const TypeSpec &t, Node *lit);
    TypeSpec decay_param(const TypeSpec &t);
    bool check_assignable(int line, const TypeSpec &to, const Val &from, const char *what);
    bool same_type(const TypeSpec &a, const TypeSpec &b);
    static bool derives_from(ClassInfo *derived, ClassInfo *base);
    std::string cond_value(Node *n);
    bool is_scalar(const TypeSpec &t) const;
    bool is_integer(const TypeSpec &t) const;
    std::string user_label(const std::string &name);
    Val emit_call(FuncInfo *fi, const std::string &callee, const std::vector<std::string> &args,
                  bool indirect);
    std::vector<std::string> eval_args(FuncInfo *fi, Node *args, int skip);
    FuncInfo *pick_overload(FuncInfo *head, Node *args, int line);
    FuncInfo *copy_ctor_of(ClassInfo *ci);
    bool is_lvalue_node(Node *n) const;
    bool has_pending_dtors() const;
    void adopt_temp(const Val &v);
    Val gen_cond_lvalue(Node *n);
    int conversion_score(const TypeSpec &param, const TypeSpec &arg);
    TypeSpec type_of_expr(Node *n);
    bool eval_const_int(Node *n, long &value);

    // ---- values ----
    std::string rvalue(const Val &v);
    std::string addr_of(const Val &v);
    void store(const Val &lhs, const std::string &v, const TypeSpec &vt);
    std::string convert(const std::string &place, const TypeSpec &from, const TypeSpec &to);
    std::string load(const std::string &addr, const TypeSpec &t);
    std::string emit_binop(const std::string &a, const std::string &op, const std::string &b,
                           const TypeSpec &t);
    std::string offset_addr(const std::string &base, int off, const std::string &note = "ptr");

    // ---- symbols ----
    void push_scope();
    void pop_scope();
    Symbol *lookup(const std::string &name);
    Symbol &declare(const std::string &name, const TypeSpec &t, Symbol::Kind kind = Symbol::Var);
    std::string unique_local(const std::string &name);
    FuncInfo *find_function(const std::string &name);
    FuncInfo *find_method(ClassInfo *ci, const std::string &name);
    const Field *find_field(ClassInfo *ci, const std::string &name);
    bool can_access(int access, ClassInfo *owner, ClassInfo *object_type = nullptr) const;
    int access_in(ClassInfo *naming, ClassInfo *owner, int access) const;
    bool allowed(int access, ClassInfo *naming, ClassInfo *object_type) const;
    bool base_accessible(int line, ClassInfo *derived, ClassInfo *base);
    FuncInfo *external(const std::string &name);
    ClassInfo *class_of(const TypeSpec &t);
    ClassInfo *class_of(const std::string &name);

    // ---- types ----
    TypeSpec resolve(const TypeSpec &t);
    int size_of(const TypeSpec &t);
    int align_of(const TypeSpec &t);
    TypeSpec elem_type(const TypeSpec &t);
    TypeSpec pointer_to(const TypeSpec &t);
    bool is_float(const TypeSpec &t) const;
    bool is_aggregate(const TypeSpec &t) const;
    bool is_pointer(const TypeSpec &t) const;
    bool is_array(const TypeSpec &t) const;
    std::string type_str(const TypeSpec &t);
    TypeSpec int_type();
    TypeSpec promote(const TypeSpec &a, const TypeSpec &b);

    // ---- emission ----
    void emit(const std::string &text, const std::string &note = "");
    void emit_label(const std::string &l);
    std::string new_temp();
    std::string new_label();
    void error(int line, const std::string &msg);
    void unsupported(int line, const std::string &what);
    int string_index(const std::string &lit);

    Module &mod_;
    Function *cur_ = nullptr;
    FuncInfo *cur_fn_ = nullptr;
    ClassInfo *cur_class_ = nullptr;
    LambdaInfo *cur_lambda_ = nullptr;
    Function *ginit_ = nullptr;
    std::vector<Function *> fn_stack_;
    std::vector<Scope> scopes_;
    std::vector<std::pair<std::string, std::string>> loops_;   // break, continue
    std::map<std::string, ClassInfo *> classes_;
    std::set<std::string> enums_;
    std::map<std::string, TypeSpec> typedefs_;
    std::map<std::string, FuncInfo *> functions_;
    std::vector<FuncInfo *> pending_;
    std::vector<std::set<std::string>> used_names_;
    std::vector<int> temp_stack_;
    int temp_counter_ = 0;
    int label_counter_ = 0;
    int lambda_counter_ = 0;
    int anon_counter_ = 0;
    bool in_sizeof_ = false;
    int cur_line_ = 0;
    std::set<std::string> lib_protos_;
    std::set<Node *> enum_nodes_done_;
    struct StaticObj { std::string name; ClassInfo *cls; };
    std::vector<StaticObj> static_objs_;  // global objects destroyed by __global_fini
    bool uses_atexit_ = false;            // a static-local object registers its destructor
    bool literal_init(Node *init, const TypeSpec &t);
    bool designated_member(const std::string &a, const TypeSpec &t, Node *list, size_t &idx);
    std::vector<std::pair<std::string, ClassInfo *>> temp_dtors_;   // argument copies to destroy
    std::map<size_t, int> dim_values_;    // evaluated constant-expression array bounds
    std::vector<size_t> loop_depth_;      // scopes_.size() when each loops_ entry was pushed
    size_t fn_scope_depth_ = 0;
    bool cplusplus_ = true;           // index of the current function's outermost scope
    std::map<std::string, int> labels_defined_;
    std::vector<std::pair<std::string, int>> gotos_;
};

}

#endif
