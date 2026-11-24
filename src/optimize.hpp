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
    int common = 0;       // repeated pure expressions reused within a basic block
    int dead_stores = 0;  // overwritten local scalar assignments removed within a block
    int jumps = 0;        // jumps retargeted, inverted or deleted
    int removed = 0;      // instructions deleted (dead temporaries, self-copies, branches,
                          // unreachable code, unused labels)
};

// Optimise every function of the module in place: constant folding, constant
// propagation (across basic blocks), copy propagation (within a block),
// strength reduction, basic-block common subexpressions/dead stores and jump
// clean-up.
OptStats optimize(Module &mod);

}

#endif
