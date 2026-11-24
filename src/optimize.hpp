#ifndef FNS_OPTIMIZE_HPP
#define FNS_OPTIMIZE_HPP

#include "ir.hpp"

namespace fns {

// What the optimiser changed, for the compiler's summary line.
struct OptStats {
    int folded = 0;       // constant expressions / constant branches evaluated
    int constants = 0;    // uses of a variable replaced by its known constant
    int copies = 0;       // uses of a copy replaced by its source (incl. t = e; v = t)
    int reduced = 0;      // multiplications/divisions turned into shifts/masks/copies
    int removed = 0;      // instructions deleted (dead temporaries, self-copies, branches)
};

// Optimise every function of the module in place: constant folding, constant
// and copy propagation within basic blocks, and strength reduction.
OptStats optimize(Module &mod);

}

#endif
