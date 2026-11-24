#include "decl_table.hpp"

#include <iostream>

namespace fns {

DeclTable &DeclTable::instance() {
    static DeclTable table;
    return table;
}

void DeclTable::record_error(int line, const std::string &message) {
    errors_.push_back(SyntaxError{line, message});
}

void DeclTable::print_errors() const {
    if (errors_.empty()) {
        return;
    }
    std::cout << "\nSyntax Errors:\n";
    for (const auto &e : errors_) {
        std::cout << "  line " << e.line << ": " << e.message << "\n";
    }
    std::cout << "Total errors: " << errors_.size() << "\n";
}

}
