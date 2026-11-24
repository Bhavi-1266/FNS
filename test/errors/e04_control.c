/* Must fail: misplaced break/continue, goto to a missing label, duplicate case
   labels, redeclarations, assignment to const. */
#include <stdio.h>

int main() {
    break;                        /* break outside a loop or switch */
    continue;                     /* continue outside a loop */
    goto nowhere;                 /* label does not exist */
    int x = 1;
    int x = 2;                    /* redeclaration in the same scope */
    switch (x) {
        case 1: break;
        case 1: break;            /* duplicate case label */
    }
    const int limit = 10;
    limit = 20;                   /* assignment to const */
    return 0;
}
