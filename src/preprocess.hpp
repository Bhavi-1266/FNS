#ifndef FNS_PREPROCESS_HPP
#define FNS_PREPROCESS_HPP

#include <set>
#include <string>
#include <vector>

namespace fns {

// Result of running the FNS preprocessor over one source file.
struct PreprocessResult {
    std::string text;                    // expanded source, same line numbering as the input
    std::vector<std::string> errors;     // "line N: message"
    std::set<std::string> lib_protos;    // library functions declared by the prelude
};

// Expand macros and conditionals in `source`.
//   * `#include` lines are dropped (the library is built in; see prelude below);
//   * `#define` / `#undef` (object-like and function-like, with # and ##);
//   * `#if` / `#ifdef` / `#ifndef` / `#elif` / `#else` / `#endif`;
//   * comments are removed, every directive becomes an empty line, so line
//     numbers in diagnostics match the original file.
// A one-line prelude (FILE, va_list, size_t and the prototypes of the library
// functions the program calls) is placed in front of line 1.
// `runtime_mode` is set when compiling the runtime library itself: no
// prototypes are injected (the library defines them).
PreprocessResult preprocess(const std::string &source, bool cplusplus, bool runtime_mode,
                            const std::string &file_name = "");

}

#endif
