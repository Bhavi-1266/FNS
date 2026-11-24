#include "ir.hpp"

#include <iomanip>

namespace fns {

// Print the module as the textual three-address code (.data, .extern, .text).
// Comment: >30 lines because it prints every section of the IR.
void Module::write(std::ostream &out) const {
    out << "; FNS three-address code\n";
    out << "; source: " << source << "\n";

    if (!errors.empty()) {
        out << "\n; Errors (no code generated for this file):\n";
        for (const auto &e : errors) out << ";   " << e << "\n";
        return;
    }

    out << "\n.data\n";
    for (size_t i = 0; i < strings.size(); ++i)
        out << "    str" << i << ": " << strings[i] << "\n";
    for (const auto &g : globals) out << "    global " << g << "\n";
    for (const auto &v : vtables) out << "    " << v << "\n";
    if (!externs.empty()) {
        out << "\n.extern\n";
        for (const auto &e : externs) out << "    " << e << "\n";
    }

    out << "\n.text\n";
    for (const Function *f : funcs) {
        out << "\nfunction " << f->name << "(";
        for (size_t i = 0; i < f->params.size(); ++i) {
            if (i) out << ", ";
            out << f->params[i];
        }
        out << ") : " << f->ret << "\n";
        for (const auto &l : f->locals) out << "    local " << l << "\n";
        for (const auto &ins : f->code) {
            bool label = !ins.text.empty() && ins.text.back() == ':' && ins.text.find(' ') == std::string::npos;
            if (label) {
                out << ins.text << "\n";
                continue;
            }
            if (ins.note.empty()) {
                out << "    " << ins.text << "\n";
            } else {
                out << "    " << std::left << std::setw(36) << ins.text << " ; " << ins.note << "\n";
            }
        }
        out << "endfunction\n";
    }

    if (!notes.empty()) {
        out << "\n; Notes:\n";
        for (const auto &n : notes) out << ";   " << n << "\n";
    }
}

}
