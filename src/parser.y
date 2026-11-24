/* FNS (Friendly Neighbourhood Spiderman) grammar: builds an AST for three-address code generation. */
%code requires {
#include "ast.hpp"
}

%{
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

#include "ast.hpp"
#include "decl_table.hpp"

extern int yylineno;
extern int yylex();
extern FILE *yyin;
void yyerror(const char *msg);

using fns::Node;
using fns::NK;
using fns::TypeSpec;
using fns::Declarator;
using fns::Base;

Node *fns::g_ast_root = nullptr;

namespace fns { std::vector<Node *> g_dim_exprs; }
static char *dup_str(const std::string &s) { return strdup(s.c_str()); }

static char *upper_dup(const char *s) {
    std::string u(s);
    for (char &c : u) c = static_cast<char>(std::toupper(static_cast<unsigned char>(c)));
    return dup_str(u);
}

static char *g_current_type = nullptr;
static char *g_pending_name = nullptr;

static void record(const char *name, const char *kind) {
    if (!name) return;
    fns::DeclTable::instance().record(name, kind ? kind : "UNKNOWN");
}

static void record_type(const char *name, const char *kind) {
    record(name, kind);
    if (name) fns::DeclTable::instance().mark_type_name(name);
}

static Node *mk(NK k, const std::string &s = "") {
    Node *n = new Node;
    n->kind = k;
    n->line = yylineno;
    n->str = s;
    return n;
}

static Node *mk1(NK k, Node *a, const std::string &s = "") { Node *n = mk(k, s); n->kids.push_back(a); return n; }
static Node *mk2(NK k, Node *a, Node *b, const std::string &s = "") { Node *n = mk1(k, a, s); n->kids.push_back(b); return n; }
static Node *mk3(NK k, Node *a, Node *b, Node *c, const std::string &s = "") { Node *n = mk2(k, a, b, s); n->kids.push_back(c); return n; }

static Node *list_add(Node *list, Node *item) {
    if (!list) list = mk(NK::DeclList);
    if (item) list->kids.push_back(item);
    return list;
}

static TypeSpec *builtin(Base b, const char *kind) {
    TypeSpec *t = new TypeSpec;
    t->base = b;
    t->kind_str = kind;
    return t;
}

static TypeSpec *apply_quals(TypeSpec *t, int q) {
    if (q & fns::Q_CONST) t->is_const = true;
    if (q & fns::Q_STATIC) t->is_static = true;
    if (q & fns::Q_UNSIGNED) t->is_unsigned = true;
    return t;
}

/* Combine a base type with a declarator (pointer depth, reference, dims). */
static TypeSpec *with_decl(const TypeSpec *base, int ptr, bool ref, const std::vector<int> *dims) {
    TypeSpec *t = new TypeSpec(*base);
    t->ptr += ptr;
    t->ref = t->ref || ref;
    if (dims) t->dims = *dims;
    return t;
}

static TypeSpec *fnptr_type(TypeSpec *ret, Node *params, const std::vector<int> *dims = nullptr) {
    TypeSpec *t = new TypeSpec;
    t->base = Base::Func;
    t->ptr = 1;
    t->ret = ret;
    t->kind_str = ret->kind_str;
    if (dims) t->dims = *dims;
    if (params) {
        for (Node *p : params->kids) {
            if (p->kind == NK::Ellipsis) t->variadic = true;
            else t->params.push_back(p->type);
        }
    }
    return t;
}

static Node *var_decl(const std::string &name, TypeSpec *type, Node *init) {
    Node *n = mk(NK::VarDecl, name);
    n->type = type;
    if (init) n->kids.push_back(init);
    if (type && type->is_static) n->flags |= fns::F_STATIC;
    return n;
}

/* Finish a top-level declaration once the tail (function or variable list) is known. */
static Node *finish_toplevel(TypeSpec *base, const char *name, int ptr, bool ref, Node *tail) {
    if (tail->kind == NK::FuncDef || tail->kind == NK::FuncDecl) {
        tail->str = name;
        tail->type = with_decl(base, ptr, ref, nullptr);
        if (base->is_static) tail->flags |= fns::F_STATIC;
        return tail;
    }
    Node *first = tail->kids[0];
    first->str = name;
    first->type = with_decl(base, ptr, ref, &first->type->dims);
    if (base->is_static) first->flags |= fns::F_STATIC;
    for (size_t i = 1; i < tail->kids.size(); ++i) {
        Node *d = tail->kids[i];
        d->type = with_decl(base, d->type->ptr, d->type->ref, &d->type->dims);
        if (base->is_static) d->flags |= fns::F_STATIC;
    }
    if (base->agg_def) tail->kids.insert(tail->kids.begin(), base->agg_def);
    return tail;
}

/* "A::b" -> class "A", member "b" (member "~A" for a destructor). */
static std::string scope_class(const char *s) { std::string t = s; return t.substr(0, t.find("::")); }
static std::string scope_member(const char *s) { std::string t = s; return t.substr(t.find("::") + 2); }

/* An out-of-class member definition: `R A::f(params) {...}`, `A::A(...) : init {...}`, `A::~A() {...}`. */
static Node *out_of_class(const char *scoped, Node *fn, TypeSpec *ret) {
    std::string cls = scope_class(scoped), m = scope_member(scoped);
    fn->str2 = cls;
    fn->type = ret;
    if (!m.empty() && m[0] == '~') { fn->str = cls; fn->flags |= fns::F_DTOR; }
    else if (m == cls && !ret) { fn->str = cls; fn->flags |= fns::F_CTOR; }
    else fn->str = m;
    return fn;
}

static Node *func_node(NK kind, Node *params, Node *ctor_init, Node *body) {
    Node *n = mk(kind);
    n->kids.push_back(params ? params : mk(NK::DeclList));
    n->kids.push_back(ctor_init ? ctor_init : mk(NK::Empty));
    n->kids.push_back(body ? body : mk(NK::Empty));
    return n;
}
%}

%union {
    char *str;
    int num;
    fns::Node *node;
    fns::TypeSpec *type;
    fns::Declarator *decl;
    std::vector<int> *dims;
}

%token <str> IDENTIFIER INTEGER FLOATNUM STRINGLIT CHARLIT PREPROC
%token <str> TYPE_NAME
%token <str> CXXCAST       /* static_cast / const_cast / reinterpret_cast / dynamic_cast */
%token <str> SCOPED_NAME   /* "Class::member" or "Class::~Class", fused by the lexer */

%token INT_KW FLOAT_KW DOUBLE_KW CHAR_KW VOID_KW BOOL_KW LONG_KW SHORT_KW
%token UNSIGNED_KW SIGNED_KW AUTO_KW CONST_KW STATIC_KW TYPEDEF_KW
%token STRUCT_KW UNION_KW ENUM_KW CLASS_KW PUBLIC_KW PRIVATE_KW PROTECTED_KW VIRTUAL_KW MUTABLE_KW
%token IF_KW ELSE_KW FOR_KW WHILE_KW DO_KW UNTIL_KW SWITCH_KW CASE_KW DEFAULT_KW
%token BREAK_KW CONTINUE_KW GOTO_KW RETURN_KW
%token NEW_KW DELETE_KW SIZEOF_KW TRUE_KW FALSE_KW NULLPTR_KW

%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET SEMI COMMA COLON QUESTION
%token ASSIGN PLUSEQ MINUSEQ STAREQ SLASHEQ PERCENTEQ ANDEQ OREQ XOREQ SHLEQ SHREQ
%token EQ NEQ LT GT LE GE
%token OROR ANDAND NOT
%token BITAND BITOR BITXOR BITNOT
%token SHL SHR
%token INC DEC
%token PLUS MINUS STAR SLASH PERCENT
%token ARROW DOT SCOPE ELLIPSIS

%type <str> string_seq
%type <type> base_type builtin_only_type type_spec aggregate_spec cast_type sizeof_type lambda_return_opt
%type <str> ident_opt assign_op
%type <node> class_base_opt
%type <decl> declarator
%type <num> type_qualifiers_opt sign_spec pointer_opt ref_opt access_specifier
%type <dims> array_suffix_opt
%type <node> top_level_list top_level_item toplevel_decl toplevel_decl_tail typedef_decl
%type <node> member member_list member_list_opt enumerator_list
%type <node> init_declarator init_declarator_list initializer brace_init init_list_opt init_list
%type <node> simple_decl declaration_stmt more_declarators_opt
%type <node> param param_list param_list_opt ctor_init_opt ctor_init_list ctor_init_item
%type <node> constructor_def destructor_def
%type <node> stmt compound_stmt stmt_list stmt_list_opt expr_stmt if_stmt for_init_opt expr_opt
%type <node> for_stmt while_stmt do_while_stmt do_until_stmt switch_stmt case_list case_list_opt case_item
%type <node> expr assignment_expr conditional_expr logical_or_expr logical_and_expr
%type <node> bitor_expr bitxor_expr bitand_expr equality_expr relational_expr shift_expr
%type <node> additive_expr multiplicative_expr unary_expr sizeof_operand postfix_expr primary_expr
%type <node> lambda_expr arg_list arg_list_opt new_initializer_opt
%type <str> capture_list_opt capture_id_list capture_item

%nonassoc THEN
%nonassoc ELSE_KW

%precedence TYPE_NAME
%precedence LPAREN           /* `Name(` inside a class body is a constructor, not a function-pointer member */
%precedence RPAREN           /* `(Name) x` is a cast, not a parenthesised type name */
%precedence COLON            /* `class Name :` opens a base-class list */
%precedence PREFER_DECLARATION
%precedence PREFER_SHIFT
%precedence RBRACKET STAR

%define parse.error verbose

%%

/* ---------- top level ---------- */

program
    : top_level_list    { fns::g_ast_root = $1; }
    ;

top_level_list
    : /* empty */                       { $$ = mk(NK::Program); }
    | top_level_list top_level_item     { $$ = list_add($1, $2); }
    ;

top_level_item
    : PREPROC                                        { $$ = mk(NK::Preproc, $1); }
    | toplevel_decl                                  { $$ = $1; }
    | typedef_decl                                   { $$ = $1; }
    | type_spec SEMI                                 { $$ = $1->agg_def ? $1->agg_def : mk(NK::Empty); }
    | SCOPED_NAME LPAREN param_list_opt RPAREN ctor_init_opt compound_stmt
        { $$ = out_of_class($1, func_node(NK::FuncDef, $3, $5, $6), nullptr); }
    | error SEMI                                     { yyerrok; $$ = nullptr; }
    ;

/* typedef of builtin/aggregate/pointer/array types, and of function pointers */
typedef_decl
    : TYPEDEF_KW type_spec declarator SEMI
        {
            record_type($3->name.c_str(), "TYPEDEF");
            $$ = mk(NK::Typedef, $3->name);
            $$->type = with_decl($2, $3->ptr, $3->ref, &$3->dims);
            if ($2->agg_def) { Node *l = mk(NK::DeclList); l->kids = { $2->agg_def, $$ }; $$ = l; }
        }
    | TYPEDEF_KW type_spec pointer_opt TYPE_NAME array_suffix_opt SEMI
        {
            record_type($4, "TYPEDEF");
            $$ = mk(NK::Typedef, $4);
            $$->type = with_decl($2, $3, false, $5);
            if ($2->agg_def) { Node *l = mk(NK::DeclList); l->kids = { $2->agg_def, $$ }; $$ = l; }
        }
    | TYPEDEF_KW type_spec LPAREN STAR IDENTIFIER array_suffix_opt RPAREN LPAREN param_list_opt RPAREN SEMI
        {
            record_type($5, "TYPEDEF");
            $$ = mk(NK::Typedef, $5);
            $$->type = fnptr_type($2, $9, $6);
        }
    ;

/* ---------- types ---------- */

builtin_only_type
    : INT_KW      { $$ = builtin(Base::Int, "INT"); }
    | FLOAT_KW    { $$ = builtin(Base::Float, "FLOAT"); }
    | DOUBLE_KW   { $$ = builtin(Base::Double, "DOUBLE"); }
    | CHAR_KW     { $$ = builtin(Base::Char, "CHAR"); }
    | VOID_KW     { $$ = builtin(Base::Void, "VOID"); }
    | BOOL_KW     { $$ = builtin(Base::Bool, "BOOL"); }
    | LONG_KW     { $$ = builtin(Base::Long, "LONG"); }
    | LONG_KW LONG_KW         { $$ = builtin(Base::Long, "LONG"); }
    | LONG_KW INT_KW          { $$ = builtin(Base::Long, "LONG"); }
    | LONG_KW LONG_KW INT_KW  { $$ = builtin(Base::Long, "LONG"); }
    | LONG_KW DOUBLE_KW       { $$ = builtin(Base::Double, "DOUBLE"); }
    | SHORT_KW    { $$ = builtin(Base::Short, "SHORT"); }
    | SHORT_KW INT_KW         { $$ = builtin(Base::Short, "SHORT"); }
    ;

base_type
    : builtin_only_type      { $$ = $1; }
    | AUTO_KW                { $$ = builtin(Base::Auto, "AUTO"); }
    | TYPE_NAME              { $$ = builtin(Base::Named, upper_dup($1)); $$->name = $1; }
    ;

type_qualifiers_opt
    : /* empty */ %prec PREFER_DECLARATION    { $$ = 0; }
    | type_qualifiers_opt CONST_KW            { $$ = $1 | fns::Q_CONST; }
    | type_qualifiers_opt STATIC_KW           { $$ = $1 | fns::Q_STATIC; }
    ;

sign_spec
    : UNSIGNED_KW    { $$ = fns::Q_UNSIGNED; }
    | SIGNED_KW      { $$ = fns::Q_SIGNED; }
    ;

type_spec
    : type_qualifiers_opt base_type              { $$ = apply_quals($2, $1); }
    | type_qualifiers_opt sign_spec base_type    { $$ = apply_quals($3, $1 | $2); }
    | type_qualifiers_opt sign_spec              %prec PREFER_DECLARATION { $$ = apply_quals(builtin(Base::Int, "INT"), $1 | $2); }
    | type_qualifiers_opt aggregate_spec          { $$ = apply_quals($2, $1); }
    ;

ident_opt
    : /* empty */        { $$ = nullptr; }
    | IDENTIFIER          { $$ = $1; }
    | TYPE_NAME           { $$ = $1; }   /* tag declared earlier (`struct S;`) */
    ;

class_base_opt
    : /* empty */                           { $$ = nullptr; }
    | COLON access_specifier IDENTIFIER     { $$ = mk(NK::Access, $3); $$->access = $2; }
    | COLON access_specifier TYPE_NAME      { $$ = mk(NK::Access, $3); $$->access = $2; }
    ;

access_specifier
    : PUBLIC_KW       { $$ = 0; }
    | PRIVATE_KW      { $$ = 1; }
    | PROTECTED_KW    { $$ = 2; }
    ;

aggregate_spec
    : STRUCT_KW ident_opt { if ($2) record_type($2, "STRUCT"); } LBRACE member_list_opt RBRACE
        {
            $$ = builtin(Base::Struct, "STRUCT");
            $$->name = $2 ? $2 : "";
            $$->agg_def = mk(NK::AggDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $5->kids;
        }
    | STRUCT_KW IDENTIFIER    { record_type($2, "STRUCT"); $$ = builtin(Base::Struct, "STRUCT"); $$->name = $2; }
    | STRUCT_KW TYPE_NAME     { $$ = builtin(Base::Struct, "STRUCT"); $$->name = $2; }
    | UNION_KW ident_opt { if ($2) record_type($2, "UNION"); } LBRACE member_list_opt RBRACE
        {
            $$ = builtin(Base::Union, "UNION");
            $$->name = $2 ? $2 : "";
            $$->agg_def = mk(NK::AggDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $5->kids;
        }
    | UNION_KW IDENTIFIER     { $$ = builtin(Base::Union, "UNION"); $$->name = $2; }
    | UNION_KW TYPE_NAME      { $$ = builtin(Base::Union, "UNION"); $$->name = $2; }
    | ENUM_KW CLASS_KW IDENTIFIER COLON enum_base LBRACE enumerator_list RBRACE
        {   /* enum class with an underlying type: stored as 4 bytes like every enum */
            record_type($3, "ENUM");
            $$ = builtin(Base::Enum, "ENUM");
            $$->name = $3;
            $$->agg_def = mk(NK::EnumDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $7->kids;
        }
    | ENUM_KW CLASS_KW IDENTIFIER LBRACE enumerator_list RBRACE
        {   /* scoped enumeration: values are written Color::Red */
            record_type($3, "ENUM");
            $$ = builtin(Base::Enum, "ENUM");
            $$->name = $3;
            $$->agg_def = mk(NK::EnumDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $5->kids;
        }
    | ENUM_KW CLASS_KW IDENTIFIER LBRACE enumerator_list COMMA RBRACE
        {
            record_type($3, "ENUM");
            $$ = builtin(Base::Enum, "ENUM");
            $$->name = $3;
            $$->agg_def = mk(NK::EnumDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $5->kids;
        }
    | ENUM_KW ident_opt LBRACE enumerator_list COMMA RBRACE
        {
            if ($2) record_type($2, "ENUM");
            $$ = builtin(Base::Enum, "ENUM");
            $$->name = $2 ? $2 : "";
            $$->agg_def = mk(NK::EnumDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $4->kids;
        }
    | ENUM_KW ident_opt LBRACE enumerator_list RBRACE
        {
            if ($2) record_type($2, "ENUM");
            $$ = builtin(Base::Enum, "ENUM");
            $$->name = $2 ? $2 : "";
            $$->agg_def = mk(NK::EnumDef, $$->name);
            $$->agg_def->type = $$;
            $$->agg_def->kids = $4->kids;
        }
    | ENUM_KW IDENTIFIER      { $$ = builtin(Base::Enum, "ENUM"); $$->name = $2; }
    | ENUM_KW TYPE_NAME       { $$ = builtin(Base::Enum, "ENUM"); $$->name = $2; }
    | CLASS_KW IDENTIFIER %prec TYPE_NAME    { record_type($2, "CLASS"); $$ = builtin(Base::Class, "CLASS"); $$->name = $2; }
    | CLASS_KW TYPE_NAME %prec TYPE_NAME     { $$ = builtin(Base::Class, "CLASS"); $$->name = $2; }
    | CLASS_KW IDENTIFIER class_base_opt { record_type($2, "CLASS"); } LBRACE member_list_opt RBRACE
        {
            $$ = builtin(Base::Class, "CLASS");
            $$->name = $2;
            $$->agg_def = mk(NK::AggDef, $2);
            $$->agg_def->type = $$;
            $$->agg_def->str2 = $3 ? $3->str : "";
            $$->agg_def->access = $3 ? $3->access : 0;
            $$->agg_def->kids = $6->kids;
        }
    | CLASS_KW TYPE_NAME class_base_opt LBRACE member_list_opt RBRACE
        {
            $$ = builtin(Base::Class, "CLASS");
            $$->name = $2;
            $$->agg_def = mk(NK::AggDef, $2);
            $$->agg_def->type = $$;
            $$->agg_def->str2 = $3 ? $3->str : "";
            $$->agg_def->access = $3 ? $3->access : 0;
            $$->agg_def->kids = $5->kids;
        }
    ;

enumerator_list
    : IDENTIFIER                          { record($1, "ENUMERATOR"); $$ = list_add(nullptr, mk(NK::Enumerator, $1)); }
    | IDENTIFIER ASSIGN assignment_expr    { record($1, "ENUMERATOR"); $$ = list_add(nullptr, mk1(NK::Enumerator, $3, $1)); }
    | enumerator_list COMMA IDENTIFIER    { record($3, "ENUMERATOR"); $$ = list_add($1, mk(NK::Enumerator, $3)); }
    | enumerator_list COMMA IDENTIFIER ASSIGN assignment_expr
                                           { record($3, "ENUMERATOR"); $$ = list_add($1, mk1(NK::Enumerator, $5, $3)); }
    ;

/* Casts: builtin types (with sign specifiers), pointers to typedef names, and
   struct/union/enum tags.  A bare typedef name `(Count) x` cannot be told apart from
   a parenthesised expression, so it is written `Count(x)` instead. */
cast_type
    : CONST_KW cast_type                         { $$ = $2; $$->is_const = true; }
    | builtin_only_type pointer_opt              { $$ = with_decl($1, $2, false, nullptr); }
    | sign_spec builtin_only_type pointer_opt    { $$ = with_decl(apply_quals($2, $1), $3, false, nullptr); }
    | sign_spec pointer_opt                      { $$ = with_decl(apply_quals(builtin(Base::Int, "INT"), $1), $2, false, nullptr); }
    | TYPE_NAME STAR pointer_opt           { $$ = builtin(Base::Named, "NAMED"); $$->name = $1; $$->ptr = 1 + $3; }
    | STRUCT_KW IDENTIFIER pointer_opt     { $$ = builtin(Base::Struct, "STRUCT"); $$->name = $2; $$->ptr = $3; }
    | STRUCT_KW TYPE_NAME pointer_opt      { $$ = builtin(Base::Struct, "STRUCT"); $$->name = $2; $$->ptr = $3; }
    | UNION_KW IDENTIFIER pointer_opt      { $$ = builtin(Base::Union, "UNION"); $$->name = $2; $$->ptr = $3; }
    | UNION_KW TYPE_NAME pointer_opt       { $$ = builtin(Base::Union, "UNION"); $$->name = $2; $$->ptr = $3; }
    | ENUM_KW IDENTIFIER pointer_opt       { $$ = builtin(Base::Enum, "ENUM"); $$->name = $2; $$->ptr = $3; }
    | ENUM_KW TYPE_NAME pointer_opt        { $$ = builtin(Base::Enum, "ENUM"); $$->name = $2; $$->ptr = $3; }
    ;

sizeof_type
    : cast_type                            { $$ = $1; }
    ;

/* ---------- declarators ---------- */

pointer_opt
    : /* empty */                 { $$ = 0; }
    | pointer_opt STAR            { $$ = $1 + 1; }
    | pointer_opt STAR CONST_KW   { $$ = $1 + 1; }
    ;

ref_opt
    : /* empty */   { $$ = 0; }
    | BITAND        { $$ = 1; }
    ;

array_suffix_opt
    : /* empty */                                  { $$ = new std::vector<int>; }
    | array_suffix_opt LBRACKET RBRACKET           { $$ = $1; $$->push_back(-1); }
    | array_suffix_opt LBRACKET conditional_expr RBRACKET
        {
            /* a literal bound is folded here; any other constant expression
               (enumerator, const int, sizeof, N * 2) is evaluated by codegen */
            $$ = $1;
            if ($3->kind == NK::IntLit) {
                long n = strtol($3->str.c_str(), nullptr, 0);
                if (n <= 0) { fns::DeclTable::instance().record_error(yylineno, "array size must be positive"); n = 1; }
                $$->push_back((int)n);
            } else {
                fns::g_dim_exprs.push_back($3);
                $$->push_back(fns::DIM_EXPR_BASE - (int)(fns::g_dim_exprs.size() - 1));
            }
        }
    ;

declarator
    : pointer_opt ref_opt IDENTIFIER array_suffix_opt
        { $$ = new Declarator; $$->name = $3; $$->ptr = $1; $$->ref = $2 != 0; $$->dims = *$4; }
    ;

init_declarator
    : declarator
        {
            record($1->name.c_str(), g_current_type);
            TypeSpec *t = new TypeSpec; t->ptr = $1->ptr; t->ref = $1->ref; t->dims = $1->dims;
            $$ = var_decl($1->name, t, nullptr);
        }
    | declarator ASSIGN initializer
        {
            record($1->name.c_str(), g_current_type);
            TypeSpec *t = new TypeSpec; t->ptr = $1->ptr; t->ref = $1->ref; t->dims = $1->dims;
            $$ = var_decl($1->name, t, $3);
        }
    | declarator LPAREN arg_list RPAREN
        {   /* direct-initialisation: Point p(1, 2);  int x(5); */
            record($1->name.c_str(), g_current_type);
            TypeSpec *t = new TypeSpec; t->ptr = $1->ptr; t->ref = $1->ref; t->dims = $1->dims;
            $3->kind = NK::InitList; $3->flags |= fns::F_CTOR;
            $$ = var_decl($1->name, t, $3);
        }
    | declarator brace_init
        {   /* list-initialisation: Point p{1, 2};  int x{5}; */
            record($1->name.c_str(), g_current_type);
            TypeSpec *t = new TypeSpec; t->ptr = $1->ptr; t->ref = $1->ref; t->dims = $1->dims;
            $2->flags |= fns::F_VALUE_INIT;
            $$ = var_decl($1->name, t, $2);
        }
    ;

init_declarator_list
    : init_declarator                              { $$ = list_add(nullptr, $1); }
    | init_declarator_list COMMA init_declarator   { $$ = list_add($1, $3); }
    ;

initializer
    : assignment_expr   { $$ = $1; }
    | brace_init        { $$ = $1; }
    ;

brace_init
    : LBRACE init_list_opt RBRACE   { $$ = $2; }
    | LBRACE init_list COMMA RBRACE { $$ = $2; }      /* trailing comma */
    ;

init_list_opt
    : /* empty */   { $$ = mk(NK::InitList); }
    | init_list     { $$ = $1; }
    ;

init_list
    : initializer                    { $$ = mk1(NK::InitList, $1); }
    | init_list COMMA initializer    { $$ = $1; $$->kids.push_back($3); }
    ;

simple_decl
    : type_spec { g_current_type = dup_str($1->kind_str); } init_declarator_list
        {
            $$ = $3;
            for (Node *d : $$->kids) {
                d->type = with_decl($1, d->type->ptr, d->type->ref, &d->type->dims);
                if ($1->is_static) d->flags |= fns::F_STATIC;
            }
            if ($1->agg_def) $$->kids.insert($$->kids.begin(), $1->agg_def);
        }
    | type_spec LPAREN STAR IDENTIFIER array_suffix_opt RPAREN LPAREN param_list_opt RPAREN
        { record($4, $1->kind_str.c_str()); $$ = list_add(nullptr, var_decl($4, fnptr_type($1, $8, $5), nullptr)); }
    | type_spec LPAREN STAR IDENTIFIER array_suffix_opt RPAREN LPAREN param_list_opt RPAREN ASSIGN initializer
        { record($4, $1->kind_str.c_str()); $$ = list_add(nullptr, var_decl($4, fnptr_type($1, $8, $5), $11)); }
    ;

declaration_stmt
    : simple_decl SEMI   { $$ = $1; }
    ;

/* ---------- functions ---------- */

param
    : type_spec declarator
        {
            record($2->name.c_str(), $1->kind_str.c_str());
            $$ = mk(NK::Param, $2->name);
            $$->type = with_decl($1, $2->ptr, $2->ref, &$2->dims);
        }
    | type_spec declarator ASSIGN assignment_expr
        {   /* C++ default argument */
            record($2->name.c_str(), $1->kind_str.c_str());
            $$ = mk(NK::Param, $2->name);
            $$->type = with_decl($1, $2->ptr, $2->ref, &$2->dims);
            $$->kids.push_back($4);
        }
    | type_spec
        { $$ = mk(NK::Param); $$->type = $1; }
    | type_spec ASSIGN assignment_expr
        { $$ = mk(NK::Param); $$->type = $1; $$->kids.push_back($3); }   /* int = 5 */
    | type_spec pointer_opt STAR
        { $$ = mk(NK::Param); $$->type = with_decl($1, 1 + $2, false, nullptr); }
    | type_spec pointer_opt STAR CONST_KW
        { $$ = mk(NK::Param); $$->type = with_decl($1, 1 + $2, false, nullptr); }
    | type_spec LPAREN STAR IDENTIFIER array_suffix_opt RPAREN LPAREN param_list_opt RPAREN
        { record($4, $1->kind_str.c_str()); $$ = mk(NK::Param, $4); $$->type = fnptr_type($1, $8, $5); }
    | ELLIPSIS
        { $$ = mk(NK::Ellipsis); }
    ;

param_list
    : param                     { $$ = list_add(nullptr, $1); }
    | param_list COMMA param    { $$ = list_add($1, $3); }
    ;

param_list_opt
    : /* empty */    { $$ = mk(NK::DeclList); }
    | param_list     { $$ = $1; }
    ;

trailing_qualifiers_opt
    : /* empty */
    | CONST_KW
    | IDENTIFIER
    | CONST_KW IDENTIFIER
    ;

ctor_init_opt
    : /* empty */             { $$ = nullptr; }
    | COLON ctor_init_list    { $$ = $2; }
    ;

ctor_init_list
    : ctor_init_item                        { $$ = mk1(NK::CtorInit, $1); }
    | ctor_init_list COMMA ctor_init_item   { $$ = $1; $$->kids.push_back($3); }
    ;

ctor_init_item
    : IDENTIFIER LPAREN arg_list_opt RPAREN   { $$ = mk(NK::CtorInitItem, $1); $$->kids = $3->kids; }
    | TYPE_NAME LPAREN arg_list_opt RPAREN    { $$ = mk(NK::CtorInitItem, $1); $$->kids = $3->kids; }
    ;

toplevel_decl
    : type_spec IDENTIFIER { g_pending_name = $2; g_current_type = dup_str($1->kind_str); } toplevel_decl_tail
        { $$ = finish_toplevel($1, $2, 0, false, $4); }
    | type_spec STAR pointer_opt ref_opt IDENTIFIER
        { g_pending_name = $5; g_current_type = dup_str($1->kind_str); } toplevel_decl_tail
        { $$ = finish_toplevel($1, $5, 1 + $3, $4 != 0, $7); }
    | type_spec BITAND IDENTIFIER
        { g_pending_name = $3; g_current_type = dup_str($1->kind_str); } toplevel_decl_tail
        { $$ = finish_toplevel($1, $3, 0, true, $5); }
    | type_spec SCOPED_NAME array_suffix_opt SEMI
        { $$ = var_decl(scope_member($2), with_decl($1, 0, false, $3), nullptr); $$->str2 = scope_class($2); $$->flags |= fns::F_STATIC_DEF; }
    | type_spec SCOPED_NAME array_suffix_opt ASSIGN initializer SEMI
        { $$ = var_decl(scope_member($2), with_decl($1, 0, false, $3), $5); $$->str2 = scope_class($2); $$->flags |= fns::F_STATIC_DEF; }
    | type_spec STAR pointer_opt SCOPED_NAME SEMI
        { $$ = var_decl(scope_member($4), with_decl($1, 1 + $3, false, nullptr), nullptr); $$->str2 = scope_class($4); $$->flags |= fns::F_STATIC_DEF; }
    | type_spec STAR pointer_opt SCOPED_NAME ASSIGN initializer SEMI
        { $$ = var_decl(scope_member($4), with_decl($1, 1 + $3, false, nullptr), $6); $$->str2 = scope_class($4); $$->flags |= fns::F_STATIC_DEF; }
    | type_spec SCOPED_NAME LPAREN param_list_opt RPAREN trailing_qualifiers_opt compound_stmt
        { $$ = out_of_class($2, func_node(NK::FuncDef, $4, nullptr, $7), $1); }
    | type_spec STAR pointer_opt SCOPED_NAME LPAREN param_list_opt RPAREN trailing_qualifiers_opt compound_stmt
        { $$ = out_of_class($4, func_node(NK::FuncDef, $6, nullptr, $9), with_decl($1, 1 + $3, false, nullptr)); }
    | type_spec BITAND SCOPED_NAME LPAREN param_list_opt RPAREN trailing_qualifiers_opt compound_stmt
        { $$ = out_of_class($3, func_node(NK::FuncDef, $5, nullptr, $8), with_decl($1, 0, true, nullptr)); }
    | type_spec LPAREN STAR IDENTIFIER array_suffix_opt RPAREN LPAREN param_list_opt RPAREN SEMI
        { record($4, $1->kind_str.c_str()); $$ = list_add(nullptr, var_decl($4, fnptr_type($1, $8, $5), nullptr)); }
    | type_spec LPAREN STAR IDENTIFIER array_suffix_opt RPAREN LPAREN param_list_opt RPAREN ASSIGN initializer SEMI
        { record($4, $1->kind_str.c_str()); $$ = list_add(nullptr, var_decl($4, fnptr_type($1, $8, $5), $11)); }
    ;

toplevel_decl_tail
    : LPAREN param_list_opt RPAREN trailing_qualifiers_opt SEMI
        { record(g_pending_name, "PROCEDURE"); $$ = func_node(NK::FuncDecl, $2, nullptr, nullptr); }
    | LPAREN param_list_opt RPAREN trailing_qualifiers_opt ASSIGN INTEGER SEMI
        { record(g_pending_name, "PROCEDURE"); $$ = func_node(NK::FuncDecl, $2, nullptr, nullptr); $$->flags |= fns::F_PURE; }
    | LPAREN param_list_opt RPAREN trailing_qualifiers_opt ctor_init_opt compound_stmt
        { record(g_pending_name, "PROCEDURE"); $$ = func_node(NK::FuncDef, $2, $5, $6); }
    | LPAREN arg_list RPAREN more_declarators_opt SEMI
        {   /* a global object constructed with arguments: Point origin(0, 0); */
            record(g_pending_name, g_current_type);
            $2->kind = NK::InitList; $2->flags |= fns::F_CTOR;
            $$ = mk(NK::DeclList);
            $$->kids.push_back(var_decl("", new TypeSpec, $2));
            for (Node *d : $4->kids) $$->kids.push_back(d);
        }
    | array_suffix_opt more_declarators_opt SEMI
        {
            record(g_pending_name, g_current_type);
            TypeSpec *t = new TypeSpec; t->dims = *$1;
            $$ = mk(NK::DeclList);
            $$->kids.push_back(var_decl("", t, nullptr));
            for (Node *d : $2->kids) $$->kids.push_back(d);
        }
    | array_suffix_opt ASSIGN initializer more_declarators_opt SEMI
        {
            record(g_pending_name, g_current_type);
            TypeSpec *t = new TypeSpec; t->dims = *$1;
            $$ = mk(NK::DeclList);
            $$->kids.push_back(var_decl("", t, $3));
            for (Node *d : $4->kids) $$->kids.push_back(d);
        }
    ;

more_declarators_opt
    : /* empty */                                    { $$ = mk(NK::DeclList); }
    | more_declarators_opt COMMA init_declarator     { $$ = list_add($1, $3); }
    ;

/* Starts with the same (empty) qualifier list as a member declaration so the parser
   only has to tell `Name(` from `Name x` / `Name *x` once the name has been read. */
constructor_def
    : type_qualifiers_opt TYPE_NAME LPAREN param_list_opt RPAREN ctor_init_opt compound_stmt
        { record($2, "PROCEDURE"); $$ = func_node(NK::FuncDef, $4, $6, $7); $$->str = $2; $$->flags |= fns::F_CTOR; }
    | type_qualifiers_opt TYPE_NAME LPAREN param_list_opt RPAREN SEMI
        { record($2, "PROCEDURE"); $$ = func_node(NK::FuncDecl, $4, nullptr, nullptr); $$->str = $2; $$->flags |= fns::F_CTOR; }
    ;

destructor_def
    : BITNOT TYPE_NAME LPAREN RPAREN compound_stmt
        {
            std::string n = std::string("~") + $2;
            record(dup_str(n), "PROCEDURE");
            $$ = func_node(NK::FuncDef, nullptr, nullptr, $5); $$->str = $2; $$->flags |= fns::F_DTOR;
        }
    | BITNOT TYPE_NAME LPAREN RPAREN SEMI
        {
            std::string n = std::string("~") + $2;
            record(dup_str(n), "PROCEDURE");
            $$ = func_node(NK::FuncDecl, nullptr, nullptr, nullptr); $$->str = $2; $$->flags |= fns::F_DTOR;
        }
    ;

/* ---------- classes / structs: members ---------- */

member
    : access_specifier COLON       { $$ = mk(NK::Access); $$->access = $1; }
    | toplevel_decl                { $$ = $1; }
    | VIRTUAL_KW toplevel_decl     { $$ = $2; $$->flags |= fns::F_VIRTUAL; }
    | constructor_def              { $$ = $1; }
    | destructor_def               { $$ = $1; }
    | VIRTUAL_KW destructor_def    { $$ = $2; $$->flags |= fns::F_VIRTUAL; }
    ;

member_list
    : member                { $$ = list_add(nullptr, $1); }
    | member_list member    { $$ = list_add($1, $2); }
    ;

member_list_opt
    : /* empty */    { $$ = mk(NK::DeclList); }
    | member_list    { $$ = $1; }
    ;

/* ---------- statements ---------- */

stmt
    : compound_stmt              { $$ = $1; }
    | declaration_stmt           { $$ = $1; }
    | type_spec SEMI             { $$ = $1->agg_def ? $1->agg_def : mk(NK::Empty); }
    | typedef_decl               { $$ = $1; }
    | expr_stmt                  { $$ = $1; }
    | if_stmt                    { $$ = $1; }
    | for_stmt                   { $$ = $1; }
    | while_stmt                 { $$ = $1; }
    | do_while_stmt              { $$ = $1; }
    | do_until_stmt              { $$ = $1; }
    | switch_stmt                { $$ = $1; }
    | BREAK_KW SEMI              { $$ = mk(NK::Break); }
    | CONTINUE_KW SEMI           { $$ = mk(NK::Continue); }
    | GOTO_KW IDENTIFIER SEMI    { $$ = mk(NK::Goto, $2); }
    | IDENTIFIER COLON stmt      { $$ = mk1(NK::Label, $3, $1); }
    | RETURN_KW SEMI             { $$ = mk(NK::Return); }
    | RETURN_KW expr SEMI        { $$ = mk1(NK::Return, $2); }
    | SEMI                       { $$ = mk(NK::Empty); }
    | error SEMI                 { yyerrok; $$ = nullptr; }
    ;

compound_stmt
    : LBRACE stmt_list_opt RBRACE   { $$ = $2; $$->kind = NK::Block; }
    ;

stmt_list
    : stmt              { $$ = list_add(nullptr, $1); }
    | stmt_list stmt    { $$ = list_add($1, $2); }
    ;

stmt_list_opt
    : /* empty */   { $$ = mk(NK::Block); }
    | stmt_list     { $$ = $1; $$->kind = NK::Block; }
    ;

expr_stmt
    : expr SEMI   { $$ = mk1(NK::ExprStmt, $1); }
    ;

if_stmt
    : IF_KW LPAREN expr RPAREN stmt %prec THEN         { $$ = mk2(NK::If, $3, $5); }
    | IF_KW LPAREN expr RPAREN stmt ELSE_KW stmt       { $$ = mk3(NK::If, $3, $5, $7); }
    ;

for_init_opt
    : /* empty */    { $$ = mk(NK::Empty); }
    | simple_decl    { $$ = $1; }
    | expr           { $$ = mk1(NK::ExprStmt, $1); }
    ;

expr_opt
    : /* empty */    { $$ = nullptr; }
    | expr           { $$ = $1; }
    ;

for_stmt
    : FOR_KW LPAREN simple_decl COLON expr RPAREN stmt
        {   /* range-based for over an array: for (int x : arr), for (auto &x : arr) */
            $$ = mk(NK::For);
            Node *d = $3->kids.empty() ? mk(NK::Empty) : $3->kids.back();
            if ($3->kids.size() != 1 || d->kind != NK::VarDecl || !d->kids.empty())
                fns::DeclTable::instance().record_error(yylineno, "range-based for declares exactly one variable");
            $$->kids = { d, $5, mk(NK::Empty), $7 };
            $$->flags |= fns::F_ARRAY;
        }
    | FOR_KW LPAREN for_init_opt SEMI expr_opt SEMI expr_opt RPAREN stmt
        {
            $$ = mk(NK::For);
            $$->kids = { $3, $5 ? $5 : mk(NK::Empty), $7 ? $7 : mk(NK::Empty), $9 };
        }
    ;

while_stmt
    : WHILE_KW LPAREN expr RPAREN stmt   { $$ = mk2(NK::While, $3, $5); }
    ;

do_while_stmt
    : DO_KW stmt WHILE_KW LPAREN expr RPAREN SEMI   { $$ = mk2(NK::DoWhile, $2, $5); }
    ;

/* FNS extension. */
do_until_stmt
    : DO_KW stmt UNTIL_KW LPAREN expr RPAREN SEMI   { $$ = mk2(NK::DoUntil, $2, $5); }
    ;

switch_stmt
    : SWITCH_KW LPAREN expr RPAREN LBRACE case_list_opt RBRACE
        { $$ = mk(NK::Switch); $$->kids.push_back($3); for (Node *c : $6->kids) $$->kids.push_back(c); }
    ;

case_list
    : case_item              { $$ = list_add(nullptr, $1); }
    | case_list case_item    { $$ = list_add($1, $2); }
    ;

case_list_opt
    : /* empty */   { $$ = mk(NK::DeclList); }
    | case_list     { $$ = $1; }
    ;

case_item
    : CASE_KW expr COLON stmt_list_opt     { $$ = mk2(NK::Case, $2, $4); }
    | DEFAULT_KW COLON stmt_list_opt       { $$ = mk2(NK::Case, mk(NK::Empty), $3); $$->flags |= fns::F_DEFAULT; }
    ;

/* ---------- expressions (precedence climbing, lowest to highest) ---------- */

expr
    : assignment_expr                { $$ = $1; }
    | expr COMMA assignment_expr     { $$ = mk2(NK::Comma, $1, $3); }
    ;

assign_op
    : ASSIGN { $$ = dup_str("="); } | PLUSEQ { $$ = dup_str("+"); } | MINUSEQ { $$ = dup_str("-"); }
    | STAREQ { $$ = dup_str("*"); } | SLASHEQ { $$ = dup_str("/"); } | PERCENTEQ { $$ = dup_str("%"); }
    | ANDEQ { $$ = dup_str("&"); } | OREQ { $$ = dup_str("|"); } | XOREQ { $$ = dup_str("^"); }
    | SHLEQ { $$ = dup_str("<<"); } | SHREQ { $$ = dup_str(">>"); }
    ;

assignment_expr
    : conditional_expr                        { $$ = $1; }
    | unary_expr assign_op assignment_expr    { $$ = mk2(NK::Assign, $1, $3, $2); }
    ;

conditional_expr
    : logical_or_expr                                            { $$ = $1; }
    | logical_or_expr QUESTION expr COLON conditional_expr       { $$ = mk3(NK::Cond, $1, $3, $5); }
    ;

logical_or_expr
    : logical_and_expr                          { $$ = $1; }
    | logical_or_expr OROR logical_and_expr     { $$ = mk2(NK::Binary, $1, $3, "||"); }
    ;

logical_and_expr
    : bitor_expr                            { $$ = $1; }
    | logical_and_expr ANDAND bitor_expr    { $$ = mk2(NK::Binary, $1, $3, "&&"); }
    ;

bitor_expr
    : bitxor_expr                      { $$ = $1; }
    | bitor_expr BITOR bitxor_expr     { $$ = mk2(NK::Binary, $1, $3, "|"); }
    ;

bitxor_expr
    : bitand_expr                        { $$ = $1; }
    | bitxor_expr BITXOR bitand_expr     { $$ = mk2(NK::Binary, $1, $3, "^"); }
    ;

bitand_expr
    : equality_expr                        { $$ = $1; }
    | bitand_expr BITAND equality_expr     { $$ = mk2(NK::Binary, $1, $3, "&"); }
    ;

equality_expr
    : relational_expr                        { $$ = $1; }
    | equality_expr EQ relational_expr       { $$ = mk2(NK::Binary, $1, $3, "=="); }
    | equality_expr NEQ relational_expr      { $$ = mk2(NK::Binary, $1, $3, "!="); }
    ;

relational_expr
    : shift_expr                        { $$ = $1; }
    | relational_expr LT shift_expr     { $$ = mk2(NK::Binary, $1, $3, "<"); }
    | relational_expr GT shift_expr     { $$ = mk2(NK::Binary, $1, $3, ">"); }
    | relational_expr LE shift_expr     { $$ = mk2(NK::Binary, $1, $3, "<="); }
    | relational_expr GE shift_expr     { $$ = mk2(NK::Binary, $1, $3, ">="); }
    ;

shift_expr
    : additive_expr                     { $$ = $1; }
    | shift_expr SHL additive_expr      { $$ = mk2(NK::Binary, $1, $3, "<<"); }
    | shift_expr SHR additive_expr      { $$ = mk2(NK::Binary, $1, $3, ">>"); }
    ;

additive_expr
    : multiplicative_expr                        { $$ = $1; }
    | additive_expr PLUS multiplicative_expr     { $$ = mk2(NK::Binary, $1, $3, "+"); }
    | additive_expr MINUS multiplicative_expr    { $$ = mk2(NK::Binary, $1, $3, "-"); }
    ;

multiplicative_expr
    : unary_expr                              { $$ = $1; }
    | multiplicative_expr STAR unary_expr     { $$ = mk2(NK::Binary, $1, $3, "*"); }
    | multiplicative_expr SLASH unary_expr    { $$ = mk2(NK::Binary, $1, $3, "/"); }
    | multiplicative_expr PERCENT unary_expr  { $$ = mk2(NK::Binary, $1, $3, "%"); }
    ;

new_initializer_opt
    : /* empty */ %prec PREFER_SHIFT      { $$ = nullptr; }
    | LPAREN arg_list_opt RPAREN          { $$ = $2; }
    | LBRACKET expr RBRACKET              { $$ = mk1(NK::Index, $2); }
    ;

unary_expr
    : postfix_expr               { $$ = $1; }
    | INC unary_expr             { $$ = mk1(NK::Unary, $2, "++"); }
    | DEC unary_expr             { $$ = mk1(NK::Unary, $2, "--"); }
    | PLUS unary_expr            { $$ = mk1(NK::Unary, $2, "+"); }
    | MINUS unary_expr           { $$ = mk1(NK::Unary, $2, "-"); }
    | NOT unary_expr             { $$ = mk1(NK::Unary, $2, "!"); }
    | BITNOT unary_expr          { $$ = mk1(NK::Unary, $2, "~"); }
    | BITAND unary_expr          { $$ = mk1(NK::Unary, $2, "&"); }
    | STAR unary_expr            { $$ = mk1(NK::Unary, $2, "*"); }
    | SIZEOF_KW LPAREN sizeof_type RPAREN    { $$ = mk(NK::SizeofType); $$->type = $3; }
    | SIZEOF_KW sizeof_operand               { $$ = mk1(NK::SizeofExpr, $2); }
    | NEW_KW type_spec pointer_opt new_initializer_opt
        {
            $$ = mk(NK::New);
            $$->type = with_decl($2, $3, false, nullptr);
            if ($4 && $4->kind == NK::Index) { $$->flags |= fns::F_ARRAY; $$->kids.push_back($4->kids[0]); }
            else if ($4) { $$->flags |= fns::F_VALUE_INIT; $$->kids = $4->kids; }
        }
    | DELETE_KW unary_expr                         { $$ = mk1(NK::Delete, $2); }
    | DELETE_KW LBRACKET RBRACKET unary_expr       { $$ = mk1(NK::Delete, $4); $$->flags |= fns::F_ARRAY; }
    | LPAREN cast_type RPAREN unary_expr           { $$ = mk1(NK::Cast, $4); $$->type = $2; }
    | LPAREN TYPE_NAME RPAREN unary_expr
        {   /* (Level) i, (size_t) n: a cast to a typedef / enum / class name */
            $$ = mk1(NK::Cast, $4);
            $$->type = builtin(Base::Named, "NAMED");
            $$->type->name = $2;
        }
    ;

/* Same as unary_expr minus the cast form; keeps sizeof(type) unambiguous. */
sizeof_operand
    : postfix_expr               { $$ = $1; }
    | INC sizeof_operand         { $$ = mk1(NK::Unary, $2, "++"); }
    | DEC sizeof_operand         { $$ = mk1(NK::Unary, $2, "--"); }
    | PLUS sizeof_operand        { $$ = mk1(NK::Unary, $2, "+"); }
    | MINUS sizeof_operand       { $$ = mk1(NK::Unary, $2, "-"); }
    | NOT sizeof_operand         { $$ = mk1(NK::Unary, $2, "!"); }
    | BITNOT sizeof_operand      { $$ = mk1(NK::Unary, $2, "~"); }
    | BITAND sizeof_operand      { $$ = mk1(NK::Unary, $2, "&"); }
    | STAR sizeof_operand        { $$ = mk1(NK::Unary, $2, "*"); }
    | SIZEOF_KW LPAREN sizeof_type RPAREN    { $$ = mk(NK::SizeofType); $$->type = $3; }
    | SIZEOF_KW sizeof_operand               { $$ = mk1(NK::SizeofExpr, $2); }
    ;

postfix_expr
    : primary_expr                                   { $$ = $1; }
    | postfix_expr LBRACKET expr RBRACKET            { $$ = mk2(NK::Index, $1, $3); }
    | postfix_expr LPAREN arg_list_opt RPAREN        { $$ = mk2(NK::Call, $1, $3); }
    | postfix_expr DOT IDENTIFIER                    { $$ = mk1(NK::Member, $1, $3); }
    | postfix_expr ARROW IDENTIFIER                  { $$ = mk1(NK::Arrow, $1, $3); }
    | postfix_expr SCOPE IDENTIFIER                  { $$ = mk1(NK::Scope, $1, $3); }
    | postfix_expr INC                               { $$ = mk1(NK::PostInc, $1); }
    | postfix_expr DEC                               { $$ = mk1(NK::PostDec, $1); }
    ;

primary_expr
    : IDENTIFIER           { $$ = mk(NK::Ident, $1); }
    | TYPE_NAME            { $$ = mk(NK::TypeName, $1); }
    | SCOPED_NAME          { $$ = mk1(NK::Scope, mk(NK::TypeName, scope_class($1)), scope_member($1)); }
    | CXXCAST LT cast_type GT LPAREN expr RPAREN
        { $$ = mk1(NK::Cast, $6); $$->type = $3; }      /* static_cast<int>(d) is a C cast */
    | CXXCAST LT TYPE_NAME GT LPAREN expr RPAREN
        { $$ = mk1(NK::Cast, $6); $$->type = builtin(Base::Named, "NAMED"); $$->type->name = $3; }
    | INTEGER              { $$ = mk(NK::IntLit, $1); }
    | FLOATNUM             { $$ = mk(NK::FloatLit, $1); }
    | string_seq           { $$ = mk(NK::StrLit, $1); }
    | CHARLIT              { $$ = mk(NK::CharLit, $1); }
    | TRUE_KW              { $$ = mk(NK::BoolLit, "1"); }
    | FALSE_KW             { $$ = mk(NK::BoolLit, "0"); }
    | NULLPTR_KW           { $$ = mk(NK::Nullptr); }
    | LPAREN expr RPAREN   { $$ = $2; }
    | lambda_expr          { $$ = $1; }
    ;

/* underlying type of an enum class (ignored: enums are 4 bytes) */
enum_base
    : builtin_only_type            { }
    | sign_spec builtin_only_type  { }
    | sign_spec                    { }
    ;

/* adjacent string literals are one literal: "ab" "cd" == "abcd" */
string_seq
    : STRINGLIT               { $$ = $1; }
    | string_seq STRINGLIT
        {
            std::string a = $1, b = $2;
            $$ = dup_str(a.substr(0, a.size() - 1) + b.substr(1));
        }
    ;

lambda_expr
    : LBRACKET capture_list_opt RBRACKET LPAREN param_list_opt RPAREN lambda_return_opt compound_stmt
        {
            $$ = mk2(NK::Lambda, $5, $8);
            $$->str = $2 ? $2 : "";
            $$->type = $7;
        }
    | LBRACKET capture_list_opt RBRACKET LPAREN param_list_opt RPAREN MUTABLE_KW lambda_return_opt compound_stmt
        {
            $$ = mk2(NK::Lambda, $5, $9);
            $$->str = $2 ? $2 : "";
            $$->type = $8;
            $$->flags |= fns::F_MUTABLE;
        }
    ;

capture_list_opt
    : /* empty */ %prec PREFER_SHIFT   { $$ = dup_str(""); }
    | BITAND                           { $$ = dup_str("&"); }
    | ASSIGN                           { $$ = dup_str("="); }
    | BITAND COMMA capture_id_list     { $$ = dup_str(std::string("&,") + $3); }
    | ASSIGN COMMA capture_id_list     { $$ = dup_str(std::string("=,") + $3); }
    | capture_id_list                  { $$ = $1; }
    ;

capture_id_list
    : capture_item                         { $$ = $1; }
    | capture_id_list COMMA capture_item   { $$ = dup_str(std::string($1) + "," + $3); }
    ;

capture_item
    : IDENTIFIER         { $$ = $1; }
    | BITAND IDENTIFIER  { $$ = dup_str(std::string("&") + $2); }
    ;

lambda_return_opt
    : /* empty */                                               { $$ = nullptr; }
    | ARROW type_qualifiers_opt base_type pointer_opt           { $$ = with_decl(apply_quals($3, $2), $4, false, nullptr); }
    | ARROW type_qualifiers_opt sign_spec base_type pointer_opt { $$ = with_decl(apply_quals($4, $2 | $3), $5, false, nullptr); }
    ;

arg_list
    : assignment_expr                    { $$ = list_add(nullptr, $1); }
    | arg_list COMMA assignment_expr     { $$ = list_add($1, $3); }
    ;

arg_list_opt
    : /* empty */   { $$ = mk(NK::DeclList); }
    | arg_list      { $$ = $1; }
    ;

%%

void yyerror(const char *msg) {
    fns::DeclTable::instance().record_error(yylineno, msg);
}
