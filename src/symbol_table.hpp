#ifndef FNS_SYMBOL_TABLE_HPP
#define FNS_SYMBOL_TABLE_HPP

#include <string>
#include <vector>

namespace fns {

struct LexError {
    int line;
    std::string text; // the offending character(s)
};

// Lexical diagnostics collected by the scanner and consumed by the driver.
class SymbolTable {
public:
    static SymbolTable &instance();

    void record_error(const std::string &text, int line);

    const std::vector<LexError> &errors() const { return errors_; }
    bool has_errors() const { return !errors_.empty(); }

    void print_errors() const;

private:
    SymbolTable() = default;

    std::vector<LexError> errors_;
};

} 
#endif 
