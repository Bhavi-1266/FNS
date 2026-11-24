#include "token.hpp"

namespace fns {

std::string to_string(TokenType type) {
    switch (type) {
        case TokenType::KEYWORD:      return "keyword";
        case TokenType::IDENTIFIER:   return "identifier";
        case TokenType::INTEGER:      return "integer";
        case TokenType::FLOAT:        return "float";
        case TokenType::STRING:       return "string";
        case TokenType::CHAR:         return "char";
        case TokenType::OPERATOR:     return "operator";
        case TokenType::PREPROCESSOR: return "preprocessor";
        case TokenType::LPAREN:       return "lparen";
        case TokenType::RPAREN:       return "rparen";
        case TokenType::LBRACE:       return "lbrace";
        case TokenType::RBRACE:       return "rbrace";
        case TokenType::LBRACKET:     return "lbracket";
        case TokenType::RBRACKET:     return "rbracket";
        case TokenType::SEMICOLON:    return "semicolon";
        case TokenType::COMMA:        return "comma";
        case TokenType::ELLIPSIS:     return "ellipsis";
        case TokenType::UNKNOWN:      return "unknown";
    }
    return "unknown";
}

} 
