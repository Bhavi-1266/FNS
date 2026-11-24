#include "symbol_table.hpp"

#include <iostream>

namespace fns {

SymbolTable &SymbolTable::instance() {
    static SymbolTable table;
    return table;
}

void SymbolTable::record_error(const std::string &text, int line) {
    errors_.push_back(LexError{line, text});
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

} 
