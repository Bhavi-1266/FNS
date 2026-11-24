#ifndef FNS_IR_HPP
#define FNS_IR_HPP

#include <ostream>
#include <string>
#include <vector>

namespace fns {

struct Instr {
    std::string text;
    std::string note;   // type annotation, printed after ';'
};

struct Function {
    std::string name;
    std::string ret;
    std::vector<std::string> params;   // "int a"
    std::vector<std::string> locals;   // "nums : int[5] (20)"
    std::vector<Instr> code;
};

struct Module {
    std::string source;
    std::vector<std::string> strings;   // raw literal text including quotes
    std::vector<std::string> globals;   // "total : int (4) = 0"
    std::vector<std::string> vtables;   // "vtable_Device: Device_read"
    std::vector<std::string> externs;   // "printf"
    std::vector<Function *> funcs;
    std::vector<std::string> errors;    // "line N: message"
    std::vector<std::string> notes;     // unsupported constructs

    void write(std::ostream &out) const;
};

}

#endif
