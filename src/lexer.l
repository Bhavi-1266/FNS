%{
/* Integrated lexer: lexical analysis + parser tokens. */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

#include "decl_table.hpp"
#include "parser.tab.hpp"

#include "keywords.hpp"
#include "symbol_table.hpp"
#include "token.hpp"

extern int yylineno;
/* set by main(): C++-only keywords are ordinary identifiers in a .c file */
bool fns_cplusplus = true;

#define TOKEN(type, text) \
    fns::SymbolTable::instance().record_token((type), (text), yylineno)

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
    TOKEN(fns::TokenType::PREPROCESSOR, yytext);
    yylval.str = strdup(yytext);
    return PREPROC;
}

"int"        { TOKEN(fns::TokenType::KEYWORD, yytext); return INT_KW; }
"float"      { TOKEN(fns::TokenType::KEYWORD, yytext); return FLOAT_KW; }
"double"     { TOKEN(fns::TokenType::KEYWORD, yytext); return DOUBLE_KW; }
"char"       { TOKEN(fns::TokenType::KEYWORD, yytext); return CHAR_KW; }
"void"       { TOKEN(fns::TokenType::KEYWORD, yytext); return VOID_KW; }
"bool"       { TOKEN(fns::TokenType::KEYWORD, yytext); return BOOL_KW; }
"long"       { TOKEN(fns::TokenType::KEYWORD, yytext); return LONG_KW; }
"short"      { TOKEN(fns::TokenType::KEYWORD, yytext); return SHORT_KW; }
"unsigned"   { TOKEN(fns::TokenType::KEYWORD, yytext); return UNSIGNED_KW; }
"signed"     { TOKEN(fns::TokenType::KEYWORD, yytext); return SIGNED_KW; }
"auto"       { TOKEN(fns::TokenType::KEYWORD, yytext); return AUTO_KW; }
"const"      { TOKEN(fns::TokenType::KEYWORD, yytext); return CONST_KW; }
"static"     { TOKEN(fns::TokenType::KEYWORD, yytext); return STATIC_KW; }
"typedef"    { TOKEN(fns::TokenType::KEYWORD, yytext); return TYPEDEF_KW; }
"struct"     { TOKEN(fns::TokenType::KEYWORD, yytext); return STRUCT_KW; }
"union"      { TOKEN(fns::TokenType::KEYWORD, yytext); return UNION_KW; }
"enum"       { TOKEN(fns::TokenType::KEYWORD, yytext); return ENUM_KW; }
"class"      { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return CLASS_KW; }
"public"     { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return PUBLIC_KW; }
"private"    { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return PRIVATE_KW; }
"protected"  { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return PROTECTED_KW; }
"virtual"    { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return VIRTUAL_KW; }

"if"         { TOKEN(fns::TokenType::KEYWORD, yytext); return IF_KW; }
"else"       { TOKEN(fns::TokenType::KEYWORD, yytext); return ELSE_KW; }
"for"        { TOKEN(fns::TokenType::KEYWORD, yytext); return FOR_KW; }
"while"      { TOKEN(fns::TokenType::KEYWORD, yytext); return WHILE_KW; }
"do"         { TOKEN(fns::TokenType::KEYWORD, yytext); return DO_KW; }
"until"      { TOKEN(fns::TokenType::KEYWORD, yytext); return UNTIL_KW; }

"switch"     { TOKEN(fns::TokenType::KEYWORD, yytext); return SWITCH_KW; }
"case"       { TOKEN(fns::TokenType::KEYWORD, yytext); return CASE_KW; }
"default"    { TOKEN(fns::TokenType::KEYWORD, yytext); return DEFAULT_KW; }

"break"      { TOKEN(fns::TokenType::KEYWORD, yytext); return BREAK_KW; }
"continue"   { TOKEN(fns::TokenType::KEYWORD, yytext); return CONTINUE_KW; }
"goto"       { TOKEN(fns::TokenType::KEYWORD, yytext); return GOTO_KW; }
"return"     { TOKEN(fns::TokenType::KEYWORD, yytext); return RETURN_KW; }

"new"        { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return NEW_KW; }
"delete"     { if (!fns_cplusplus) { TOKEN(fns::TokenType::IDENTIFIER, yytext); yylval.str = strdup(yytext); return fns::DeclTable::instance().is_type_name(yytext) ? TYPE_NAME : IDENTIFIER; } TOKEN(fns::TokenType::KEYWORD, yytext); return DELETE_KW; }
"sizeof"     { TOKEN(fns::TokenType::KEYWORD, yytext); return SIZEOF_KW; }

"true"       { TOKEN(fns::TokenType::KEYWORD, yytext); return TRUE_KW; }
"false"      { TOKEN(fns::TokenType::KEYWORD, yytext); return FALSE_KW; }
"nullptr"    { TOKEN(fns::TokenType::KEYWORD, yytext); return NULLPTR_KW; }

"static_cast"|"const_cast"|"reinterpret_cast"|"dynamic_cast" {
    /* C++ named casts (ordinary identifiers in a .c file) */
    TOKEN(fns_cplusplus ? fns::TokenType::KEYWORD : fns::TokenType::IDENTIFIER, yytext);
    yylval.str = strdup(yytext);
    if (!fns_cplusplus) return IDENTIFIER;
    return CXXCAST;
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
        TOKEN(fns::TokenType::IDENTIFIER, yytext);
        yylval.str = strdup((cls + "::" + member).c_str());
        return SCOPED_NAME;
    }
    yyless((int)len);
    TOKEN(fns::TokenType::IDENTIFIER, yytext);
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

{ID} {
    TOKEN(fns::TokenType::IDENTIFIER, yytext);

    yylval.str = strdup(yytext);

    if (fns::DeclTable::instance().is_type_name(yytext)) {
        return TYPE_NAME;
    }

    return IDENTIFIER;
}

{FLOATLIT} {
    TOKEN(fns::TokenType::FLOAT, yytext);
    yylval.str = strdup(yytext);
    return FLOATNUM;
}

{HEX} {
    TOKEN(fns::TokenType::INTEGER, yytext);
    yylval.str = strdup(yytext);
    return INTEGER;
}

{OCTAL} {
    TOKEN(fns::TokenType::INTEGER, yytext);
    yylval.str = strdup(yytext);
    return INTEGER;
}

{INTEGERNUM} {
    TOKEN(fns::TokenType::INTEGER, yytext);
    yylval.str = strdup(yytext);
    return INTEGER;
}

\"(\\.|[^\\"])*\" {
    TOKEN(fns::TokenType::STRING, yytext);
    yylval.str = strdup(yytext);
    return STRINGLIT;
}

'(\\.|[^\\'])+' {
    TOKEN(fns::TokenType::CHAR, yytext);
    yylval.str = strdup(yytext);
    return CHARLIT;
}

"..." { TOKEN(fns::TokenType::ELLIPSIS, yytext); return ELLIPSIS; }
"::"    { TOKEN(fns::TokenType::OPERATOR, yytext); return SCOPE; }
"<<="   { TOKEN(fns::TokenType::OPERATOR, yytext); return SHLEQ; }
">>="   { TOKEN(fns::TokenType::OPERATOR, yytext); return SHREQ; }
"<<"    { TOKEN(fns::TokenType::OPERATOR, yytext); return SHL; }
">>"    { TOKEN(fns::TokenType::OPERATOR, yytext); return SHR; }
"&&"    { TOKEN(fns::TokenType::OPERATOR, yytext); return ANDAND; }
"||"    { TOKEN(fns::TokenType::OPERATOR, yytext); return OROR; }
"=="    { TOKEN(fns::TokenType::OPERATOR, yytext); return EQ; }
"!="    { TOKEN(fns::TokenType::OPERATOR, yytext); return NEQ; }
"<="    { TOKEN(fns::TokenType::OPERATOR, yytext); return LE; }
">="    { TOKEN(fns::TokenType::OPERATOR, yytext); return GE; }
"+="    { TOKEN(fns::TokenType::OPERATOR, yytext); return PLUSEQ; }
"-="    { TOKEN(fns::TokenType::OPERATOR, yytext); return MINUSEQ; }
"*="    { TOKEN(fns::TokenType::OPERATOR, yytext); return STAREQ; }
"/="    { TOKEN(fns::TokenType::OPERATOR, yytext); return SLASHEQ; }
"%="    { TOKEN(fns::TokenType::OPERATOR, yytext); return PERCENTEQ; }
"&="    { TOKEN(fns::TokenType::OPERATOR, yytext); return ANDEQ; }
"|="    { TOKEN(fns::TokenType::OPERATOR, yytext); return OREQ; }
"^="    { TOKEN(fns::TokenType::OPERATOR, yytext); return XOREQ; }
"->"    { TOKEN(fns::TokenType::OPERATOR, yytext); return ARROW; }
"++"    { TOKEN(fns::TokenType::OPERATOR, yytext); return INC; }
"--"    { TOKEN(fns::TokenType::OPERATOR, yytext); return DEC; }

"+"     { TOKEN(fns::TokenType::OPERATOR, yytext); return PLUS; }
"-"     { TOKEN(fns::TokenType::OPERATOR, yytext); return MINUS; }
"*"     { TOKEN(fns::TokenType::OPERATOR, yytext); return STAR; }
"/"     { TOKEN(fns::TokenType::OPERATOR, yytext); return SLASH; }
"%"     { TOKEN(fns::TokenType::OPERATOR, yytext); return PERCENT; }
"="     { TOKEN(fns::TokenType::OPERATOR, yytext); return ASSIGN; }
"!"     { TOKEN(fns::TokenType::OPERATOR, yytext); return NOT; }
"<"     { TOKEN(fns::TokenType::OPERATOR, yytext); return LT; }
">"     { TOKEN(fns::TokenType::OPERATOR, yytext); return GT; }
"&"     { TOKEN(fns::TokenType::OPERATOR, yytext); return BITAND; }
"|"     { TOKEN(fns::TokenType::OPERATOR, yytext); return BITOR; }
"^"     { TOKEN(fns::TokenType::OPERATOR, yytext); return BITXOR; }
"~"     { TOKEN(fns::TokenType::OPERATOR, yytext); return BITNOT; }
"?"     { TOKEN(fns::TokenType::OPERATOR, yytext); return QUESTION; }
":"     { TOKEN(fns::TokenType::OPERATOR, yytext); return COLON; }


"("     { TOKEN(fns::TokenType::LPAREN, yytext); return LPAREN; }
")"     { TOKEN(fns::TokenType::RPAREN, yytext); return RPAREN; }
"{"     { TOKEN(fns::TokenType::LBRACE, yytext); return LBRACE; }
"}"     { TOKEN(fns::TokenType::RBRACE, yytext); return RBRACE; }
"["     { TOKEN(fns::TokenType::LBRACKET, yytext); return LBRACKET; }
"]"     { TOKEN(fns::TokenType::RBRACKET, yytext); return RBRACKET; }
";"     { TOKEN(fns::TokenType::SEMICOLON, yytext); return SEMI; }
","     { TOKEN(fns::TokenType::COMMA, yytext); return COMMA; }
"."     { TOKEN(fns::TokenType::OPERATOR, yytext); return DOT; }


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
