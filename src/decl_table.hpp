#ifndef FNS_DECL_TABLE_HPP
#define FNS_DECL_TABLE_HPP

#include <string>
#include <unordered_set>
#include <vector>

namespace fns {

struct SyntaxError {
    int line;
    std::string message;
};

class DeclTable {
public:
    static DeclTable &instance();

    void record_error(int line, const std::string &message);

    void mark_type_name(const std::string &name) { type_names_.insert(name); }
    bool is_type_name(const std::string &name) const {
        return type_names_.count(name) != 0;
    }

    const std::vector<SyntaxError> &errors() const { return errors_; }
    bool has_errors() const { return !errors_.empty(); }

    void print_errors() const;

private:
    DeclTable() = default;

    std::vector<SyntaxError> errors_;
    std::unordered_set<std::string> type_names_;
};

}

#endif
