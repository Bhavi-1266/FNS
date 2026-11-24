#ifndef FNS_AST_HPP
#define FNS_AST_HPP

#include <string>
#include <vector>

namespace fns {

enum class Base {
    Void, Bool, Char, Short, Int, Long, Float, Double, Auto,
    Named,              // typedef / class / struct name seen as TYPE_NAME
    Struct, Union, Enum, Class,
    Func,               // function (pointer) type: ret + params
    Lambda
};

struct Node;

struct TypeSpec {
    Base base = Base::Int;
    std::string name;             // aggregate / typedef name
    int ptr = 0;
    bool ref = false;
    std::vector<int> dims;        // -1 for []
    bool is_unsigned = false;
    bool is_const = false;
    bool is_static = false;
    bool decayed = false;         // array parameter: storage is a pointer to the first element
    TypeSpec *ret = nullptr;      // Base::Func
    std::vector<TypeSpec *> params;
    bool variadic = false;
    Node *agg_def = nullptr;      // inline struct/class/union/enum body
    std::string kind_str;         // phase-2 declaration table label
};

struct Declarator {
    std::string name;
    int ptr = 0;
    bool ref = false;
    std::vector<int> dims;
};

enum class NK {
    Program, Preproc, FuncDef, FuncDecl, VarDecl, DeclList, AggDef, EnumDef, Enumerator,
    Typedef, Access, Param, Ellipsis, CtorInit, CtorInitItem,
    Block, ExprStmt, If, For, While, DoWhile, DoUntil, Switch, Case, Break, Continue,
    Goto, Label, Return, Empty,
    Binary, Unary, PostInc, PostDec, Assign, Cond, Comma, Call, Index, Member, Arrow, Scope,
    Ident, TypeName, IntLit, FloatLit, StrLit, CharLit, BoolLit, Nullptr, Cast,
    SizeofType, SizeofExpr, New, Delete, Lambda, InitList
};

enum NodeFlag {
    F_STATIC = 1, F_VIRTUAL = 2, F_PURE = 4, F_CTOR = 8, F_DTOR = 16,
    F_ARRAY = 32, F_DEFAULT = 64, F_PREFIX = 128, F_VALUE_INIT = 256, F_STATIC_DEF = 512
};

struct Node {
    NK kind;
    int line = 0;
    std::string str;              // name, operator, literal text, capture mode
    std::string str2;             // base class name, capture names
    std::vector<Node *> kids;
    TypeSpec *type = nullptr;
    int flags = 0;
    int access = 0;               // 0 public, 1 private, 2 protected (members)
};

// Qualifier flags returned by type_qualifiers_opt / sign_spec.
enum QualFlag { Q_CONST = 1, Q_STATIC = 2, Q_UNSIGNED = 4, Q_SIGNED = 8 };

extern Node *g_ast_root;

// Array bounds that are not integer literals are stored here by the parser and
// written into TypeSpec::dims as DIM_EXPR_BASE - index; codegen evaluates them.
const int DIM_EXPR_BASE = -1000;
extern std::vector<Node *> g_dim_exprs;

}

#endif
