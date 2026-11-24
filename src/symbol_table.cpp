#include "symbol_table.hpp"

#include <cstdio>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <unistd.h>

namespace fns {

namespace {

constexpr int kLexemeWidth = 24;
constexpr int kTokenWidth = 14;

bool use_color() {
    return isatty(fileno(stdout)) != 0;
}

std::string color_for(TokenType type) {
    if (!use_color()) {
        return "";
    }
    switch (type) {
        case TokenType::KEYWORD:      return "\033[35m";
        case TokenType::IDENTIFIER:   return "\033[36m";
        case TokenType::INTEGER:
        case TokenType::FLOAT:        return "\033[33m";
        case TokenType::STRING:
        case TokenType::CHAR:         return "\033[32m";
        case TokenType::OPERATOR:     return "\033[31m";
        default:                      return "\033[37m";
    }
}

std::string reset_color() {
    return use_color() ? "\033[0m" : "";
}

std::string truncate(const std::string &s, size_t max_len) {
    if (s.size() <= max_len) {
        return s;
    }
    return s.substr(0, max_len - 3) + "...";
}

void print_rule(std::ostream &out) {
    out << "+" << std::string(kLexemeWidth + 2, '-')
        << "+" << std::string(kTokenWidth + 2, '-') << "+\n";
}

} // namespace

SymbolTable &SymbolTable::instance() {
    static SymbolTable table;
    return table;
}

void SymbolTable::record_token(TokenType type, const std::string &lexeme, int line) {
    tokens_.push_back(Token{type, lexeme, line});
}

void SymbolTable::record_error(const std::string &text, int line) {
    errors_.push_back(LexError{line, text});
}

void SymbolTable::reset() {
    tokens_.clear();
    errors_.clear();
}

// Lexeme and Token eg "foo -> identifier").
void SymbolTable::print_token_table(const std::string &source) const {
    if (!source.empty()) {
        std::cout << "\nLexical analysis: " << source << "\n";
    }

    if (tokens_.empty()) {
        std::cout << "No tokens found.\n";
        return;
    }

    print_rule(std::cout);
    std::cout << "| " << std::left << std::setw(kLexemeWidth) << "Lexeme"
               << " | " << std::setw(kTokenWidth) << "Token" << " |\n";
    print_rule(std::cout);

    for (const auto &tok : tokens_) {
        std::string lexeme = truncate(tok.lexeme, kLexemeWidth);
        std::string type_str = to_string(tok.type);
        std::string c = color_for(tok.type);
        std::string r = reset_color();

        std::cout << "| " << std::left << std::setw(kLexemeWidth) << lexeme
                   << " | " << c << std::setw(kTokenWidth) << type_str << r << " |\n";
    }

    print_rule(std::cout);
    std::cout << "Total tokens: " << tokens_.size() << "\n";
}

void SymbolTable::print_errors() const {
    if (errors_.empty()) {
        return;
    }
    std::cout << "\nLexical Errors:\n";
    for (const auto &err : errors_) {
        std::cout << "  line " << err.line << ": illegal character '" << err.text << "'\n";
    }
    std::cout << "Total errors: " << errors_.size() << "\n";
}

// Write the lexer's symbol table (phase-1 diagnostic output).
// Comment: >30 lines because it formats every table column.
void SymbolTable::write_symbol_table(const std::string &path, const std::string &source) const {
    std::ofstream out(path);
    if (!out) {
        std::perror(path.c_str());
        return;
    }

    out << "Symbol Table\n";
    if (!source.empty()) {
        out << "Source: " << source << "\n";
    }
    out << "\n";
    out << std::left << std::setw(6) << "#" << std::setw(6) << "Line"
        << std::setw(kTokenWidth + 2) << "Token" << "Lexeme\n";

    for (size_t i = 0; i < tokens_.size(); ++i) {
        const auto &tok = tokens_[i];
        out << std::left << std::setw(6) << (i + 1)
            << std::setw(6) << tok.line
            << std::setw(kTokenWidth + 2) << to_string(tok.type)
            << tok.lexeme << "\n";
    }

    out << "\nTotal tokens: " << tokens_.size() << "\n";

    if (!errors_.empty()) {
        out << "\nLexical Errors:\n";
        for (const auto &err : errors_) {
            out << "  line " << err.line << ": illegal character '" << err.text << "'\n";
        }
        out << "Total errors: " << errors_.size() << "\n";
    }

    std::cout << "Symbol table written to " << path << "\n";
}

} 
