#ifndef FNS_TOKEN_HPP
#define FNS_TOKEN_HPP

#include <string>

// Shared token vocabulary for the FNS front end.
//
// This header is intentionally decoupled from the scanner: it is the
// contract between the lexical analyser (this phase) and the syntax
// analyser / semantic analyser that will be built on top of it later.
// The parser phase should depend on `fns::Token` / `fns::TokenType`
// directly instead of re-parsing printed text.


namespace fns {

enum class TokenType {
    KEYWORD,
    IDENTIFIER,
    INTEGER,
    FLOAT,
    STRING,
    CHAR,
    OPERATOR,
    PREPROCESSOR,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,
    LBRACKET,
    RBRACKET,
    SEMICOLON,
    COMMA,
    ELLIPSIS,
    UNKNOWN
};

// Lowercase label used for printed output (matches the assignment's
// example token table: "if -> keyword", "foo -> identifier").
std::string to_string(TokenType type);

struct Token {
    TokenType type;
    std::string lexeme;
    int line;
};

} 

#endif 
