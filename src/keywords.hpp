#ifndef FNS_KEYWORDS_HPP
#define FNS_KEYWORDS_HPP

#include <string>

namespace fns {

// Case-sensitive keyword lookup (e.g. "Int" is an identifier, not a
// keyword). Covers standard C / C99 / C11 keywords, common C++
// keywords (classes, access specifiers, casts, etc.), and one
// language extension specific to FNS's "C-like" source language:
// `until`, used for `do { ... } until (cond);` loops.
bool is_keyword(const std::string &text);

} 
#endif // FNS_KEYWORDS_HPP
