#ifndef FNS_SYMBOL_TABLE_HPP
#define FNS_SYMBOL_TABLE_HPP

#include <string>
#include <vector>

#include "token.hpp"

namespace fns {

struct LexError {
    int line;
    std::string text; // the offending character(s)
};

// SymbolTable is the lexer's output: an ordered token stream plus the
// set of lexical errors found along the way. It is deliberately a
// plain reusable class (not tied to stdout) so the next compiler
// phase (syntax analysis) can link against this file and call
// `tokens()` directly instead of re-reading printed text or the
// symbol_table.txt log.
class SymbolTable {
public:
    static SymbolTable &instance();

    void record_token(TokenType type, const std::string &lexeme, int line);
    void record_error(const std::string &text, int line);

    const std::vector<Token> &tokens() const { return tokens_; }
    const std::vector<LexError> &errors() const { return errors_; }
    bool has_errors() const { return !errors_.empty(); }

    void print_token_table(const std::string &source) const;
    void print_errors() const;
    void write_symbol_table(const std::string &path, const std::string &source) const;

    void reset();

private:
    SymbolTable() = default;

    std::vector<Token> tokens_;
    std::vector<LexError> errors_;
};

} 
#endif 
