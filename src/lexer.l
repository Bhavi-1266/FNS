%{
/* Integrated lexer: lexical analysis + parser tokens. */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

#include "decl_table.hpp"
#include "parser.tab.hpp"

#include "symbol_table.hpp"

extern int yylineno;
/* set by main(): C++-only keywords are ordinary identifiers in a .c file */
bool fns_cplusplus = true;

%}

%option noyywrap nounput noinput yylineno

DIGIT        [0-9]
LETTER       [a-zA-Z_]
ID           {LETTER}({LETTER}|{DIGIT})*
INT_SUFFIX   (u|U|l|L|ul|UL|lu|LU|ll|LL|ull|ULL|llu|LLU)?
HEX          0[xX][0-9a-fA-F]+{INT_SUFFIX}
OCTAL        0[0-7]+{INT_SUFFIX}
INTEGERNUM   {DIGIT}+{INT_SUFFIX}
EXP          [eE][+-]?{DIGIT}+
FLOAT_SUFFIX (f|F|l|L)?
FLOATLIT     (({DIGIT}+\.{DIGIT}*|{DIGIT}*\.{DIGIT}+){EXP}?|{DIGIT}+{EXP}){FLOAT_SUFFIX}

%%

"//".*                          { }
"/*"([^*]|\*+[^*/])*\*+"/"     { }
"#".* {
    yylval.str = strdup(yytext);
    return PREPROC;
}

"int"        { return INT_KW; }
"float"      { return FLOAT_KW; }
"double"     { return DOUBLE_KW; }
"char"       { return CHAR_KW; }
"void"       { return VOID_KW; }
"bool"       { return BOOL_KW; }
"long"       { return LONG_KW; }
"short"      { return SHORT_KW; }
"unsigned"   { return UNSIGNED_KW; }
"signed"     { return SIGNED_KW; }
"auto"       { return AUTO_KW; }
"const"      { return CONST_KW; }
"static"     { return STATIC_KW; }
"typedef"    { return TYPEDEF_KW; }
"struct"     { return STRUCT_KW; }
"union"      { return UNION_KW; }
"enum"       { return ENUM_KW; }
"class"      { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return CLASS_KW; }
"public"     { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return PUBLIC_KW; }
"private"    { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return PRIVATE_KW; }
"protected"  { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return PROTECTED_KW; }
"virtual"    { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return VIRTUAL_KW; }

"if"         { return IF_KW; }
"else"       { return ELSE_KW; }
"for"        { return FOR_KW; }
"while"      { return WHILE_KW; }
"do"         { return DO_KW; }
"until"      { return UNTIL_KW; }

"switch"     { return SWITCH_KW; }
"case"       { return CASE_KW; }
"default"    { return DEFAULT_KW; }

"break"      { return BREAK_KW; }
"continue"   { return CONTINUE_KW; }
"goto"       { return GOTO_KW; }
"return"     { return RETURN_KW; }

"new"        { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return NEW_KW; }
"delete"     { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return DELETE_KW; }
"sizeof"     { return SIZEOF_KW; }

"true"       { return TRUE_KW; }
"false"      { return FALSE_KW; }
"mutable"    { if (!fns_cplusplus) { yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } return MUTABLE_KW; }
"nullptr"    { return NULLPTR_KW; }

"static_cast"|"const_cast"|"reinterpret_cast"|"dynamic_cast" {
    /* C++ named casts (ordinary identifiers in a .c file) */

    yylval.str = strdup(yytext);
    if (!fns_cplusplus) return IDENTIFIER;
    return CXXCAST;
}

"std"[ \t]*"::"[ \t]*"move" {
    /* std::move(x): the only std:: function, turned into a builtin (x as an rvalue) */

    yylval.str = strdup("__fns_move");
    return IDENTIFIER;
}
{ID}[ \t]*"::"[ \t]*"~"?[ \t]*{ID} {
    /* Class::member is one token, so a statement may start with Base::f()
       and members may be defined outside the class body. */
    std::string text = yytext;
    size_t len = 0;
    while (len < text.size() && (isalnum((unsigned char)text[len]) || text[len] == '_')) ++len;
    std::string cls = text.substr(0, len);
    if (fns::DeclTable::instance().is_type_name(cls)) {
        std::string member;
        for (size_t i = text.find("::") + 2; i < text.size(); ++i)
            if (text[i] != ' ' && text[i] != '\t') member += text[i];
        if (member != cls && fns::DeclTable::instance().is_type_name(member)) {
            /* Outer::Inner names a nested class/struct/enum: the type itself */

            yylval.str = strdup(member.c_str());
            return TYPE_NAME;
        }

        yylval.str = strdup((cls + "::" + member).c_str());
        return SCOPED_NAME;
    }
    yyless((int)len);

    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

{ID} {
    yylval.str = strdup(yytext);

    if (fns::DeclTable::instance().is_type_name(yytext)) {
        return TYPE_NAME;
    }

    return IDENTIFIER;
}

{FLOATLIT} {
    yylval.str = strdup(yytext);
    return FLOATNUM;
}

{HEX} {
    yylval.str = strdup(yytext);
    return INTEGER;
}

{OCTAL} {
    yylval.str = strdup(yytext);
    return INTEGER;
}

{INTEGERNUM} {
    yylval.str = strdup(yytext);
    return INTEGER;
}

\"(\\.|[^\\"])*\" {
    yylval.str = strdup(yytext);
    return STRINGLIT;
}

'(\\.|[^\\'])+' {
    yylval.str = strdup(yytext);
    return CHARLIT;
}

"..." { return ELLIPSIS; }
"::"    { return SCOPE; }
"<<="   { return SHLEQ; }
">>="   { return SHREQ; }
"<<"    { return SHL; }
">>"    { return SHR; }
"&&"    { return ANDAND; }
"||"    { return OROR; }
"=="    { return EQ; }
"!="    { return NEQ; }
"<="    { return LE; }
">="    { return GE; }
"+="    { return PLUSEQ; }
"-="    { return MINUSEQ; }
"*="    { return STAREQ; }
"/="    { return SLASHEQ; }
"%="    { return PERCENTEQ; }
"&="    { return ANDEQ; }
"|="    { return OREQ; }
"^="    { return XOREQ; }
"->"    { return ARROW; }
"++"    { return INC; }
"--"    { return DEC; }

"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return STAR; }
"/"     { return SLASH; }
"%"     { return PERCENT; }
"="     { return ASSIGN; }
"!"     { return NOT; }
"<"     { return LT; }
">"     { return GT; }
"&"     { return BITAND; }
"|"     { return BITOR; }
"^"     { return BITXOR; }
"~"     { return BITNOT; }
"?"     { return QUESTION; }
":"     { return COLON; }

"("     { return LPAREN; }
")"     { return RPAREN; }
"{"     { return LBRACE; }
"}"     { return RBRACE; }
"["     { return LBRACKET; }
"]"     { return RBRACKET; }
";"     { return SEMI; }
","     { return COMMA; }
"."     { return DOT; }

[ \t\r\n]+   { }

. {
    fns::SymbolTable::instance().record_error(
        yytext,
        yylineno
    );

    fns::DeclTable::instance().record_error(
        yylineno,
        std::string("unexpected character '") + yytext + "'"
    );
}

%%
