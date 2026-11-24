#include "decl_table.hpp"

#include <fstream>
#include <iomanip>
#include <iostream>

namespace fns {

namespace {
constexpr int kTokenWidth = 20;
constexpr int kTypeWidth = 16;

void print_rule(std::ostream &out) {
    out << "+" << std::string(kTokenWidth + 2, '-')
        << "+" << std::string(kTypeWidth + 2, '-') << "+\n";
}
}

DeclTable &DeclTable::instance() {
    static DeclTable table;
    return table;
}

void DeclTable::record(const std::string &name, const std::string &kind) {
    decls_.push_back(Declaration{name, kind});
}

void DeclTable::record_error(int line, const std::string &message) {
    errors_.push_back(SyntaxError{line, message});
}

void DeclTable::print_table(const std::string &source) const {
    if (!source.empty()) {
        std::cout << "\nSyntax analysis: " << source << "\n";
    }

    if (decls_.empty()) {
        std::cout << "No declared identifiers found.\n";
        return;
    }

    print_rule(std::cout);
    std::cout << "| " << std::left << std::setw(kTokenWidth) << "Token"
               << " | " << std::setw(kTypeWidth) << "Token_Type" << " |\n";
    print_rule(std::cout);

    for (const auto &d : decls_) {
        std::cout << "| " << std::left << std::setw(kTokenWidth) << d.name
                   << " | " << std::setw(kTypeWidth) << d.kind << " |\n";
    }

    print_rule(std::cout);
    std::cout << "Total declared identifiers: " << decls_.size() << "\n";
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

void DeclTable::write_table(const std::string &path, const std::string &source) const {
    std::ofstream out(path);
    if (!out) {
        std::perror(path.c_str());
        return;
    }

    out << "Declared Identifier Table\n";
    if (!source.empty()) {
        out << "Source: " << source << "\n";
    }
    out << "\n";
    out << std::left << std::setw(kTokenWidth + 2) << "Token"
        << "Token_Type\n";

    for (const auto &d : decls_) {
        out << std::left << std::setw(kTokenWidth + 2) << d.name << d.kind << "\n";
    }
    out << "\nTotal declared identifiers: " << decls_.size() << "\n";

    if (!errors_.empty()) {
        out << "\nSyntax Errors:\n";
        for (const auto &e : errors_) {
            out << "  line " << e.line << ": " << e.message << "\n";
        }
        out << "Total errors: " << errors_.size() << "\n";
    }

    std::cout << "Declaration table written to " << path << "\n";
}

}
