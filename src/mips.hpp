#ifndef FNS_MIPS_HPP
#define FNS_MIPS_HPP

#include <ostream>
#include "ir.hpp"

namespace fns {

// Lower an in-memory IR Module to little-endian MIPS32 assembly for the spim
// simulator. Any IR construct the backend cannot translate is reported by
// appending a human-readable line to `unsupported`; the caller decides what to
// do with it. Returns true when at least one function was emitted.
bool emit_mips(const Module &mod, std::ostream &out,
               std::vector<std::string> &unsupported, bool runtime_mode = false);

// True when the embedded runtime library defines function `name`.
bool runtime_provides(const std::string &name);

}

#endif
