#include "keywords.hpp"

#include <unordered_set>

namespace fns {

namespace {

const std::unordered_set<std::string> &keyword_set() {
    static const std::unordered_set<std::string> keywords = {
        // C / C99 / C11
        "auto", "break", "case", "char", "const", "continue", "default", "do",
        "double", "else", "enum", "extern", "float", "for", "goto", "if",
        "inline", "int", "long", "register", "return", "short", "signed", "sizeof",
        "static", "struct", "switch", "typedef", "union", "unsigned", "void",
        "volatile", "while",
        "_Bool", "_Complex", "_Imaginary",

        // C++
        "alignas", "alignof", "and", "and_eq", "asm", "bitand", "bitor",
        "bool", "catch", "class", "compl", "concept", "consteval", "constexpr",
        "constinit", "const_cast", "co_await", "co_return", "co_yield", "decltype",
        "delete", "dynamic_cast", "explicit", "export", "false", "friend",
        "mutable", "namespace", "new", "noexcept", "not", "not_eq", "nullptr",
        "operator", "or", "or_eq", "private", "protected", "public",
        "reinterpret_cast", "requires", "static_assert", "static_cast", "template",
        "this", "thread_local", "throw", "true", "try", "typeid", "typename",
        "using", "virtual", "wchar_t", "xor", "xor_eq",

        // FNS language extension: `do { ... } until (cond);`
        "until",
    };
    return keywords;
}

} 
bool is_keyword(const std::string &text) {
    return keyword_set().count(text) != 0;
}

} 
