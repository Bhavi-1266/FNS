/* Valid: control-flow corner cases: dangling else, empty for, continue inside
   do-while/until/switch-in-loop, default-first switch, char/negative/expression case
   labels, nested and empty switch, enum switch, forward/backward goto, label before '}'. */
enum Color { RED, GREEN = 5, BLUE };
int main(void) {
    int i, j, n = 0, k = 0;
    if (n) ; else n = 1;                         /* empty then */
    if (n) if (k) k = 1; else k = 2;             /* dangling else */
    for (;;) { if (++n > 3) break; }             /* empty for */
    for (i = 0, j = 10; i < j; i++, j--) { if (i == 2) continue; k += i; }
    for (int q = 0; q < 2; q++) { int q2 = q; k += q2; }
    while (0) { k = 99; }
    do { k++; if (k > 5) continue; k++; } while (k < 10);   /* continue in do-while -> cond */
    do { k--; if (k == 7) continue; } until (k < 5);        /* continue in until */
    /* continue in switch in loop must reach loop step */
    for (i = 0; i < 5; i++) {
        switch (i) {
            case 0: continue;
            case 1: break;
            default: k++;
            case 2: k += 2;       /* fallthrough into case after default */
        }
        k += 100;
    }
    switch (k) { default: k = 0; case -1: k = 1; case 'a': k = 2; case 1 + 1: k = 3; }   /* default first, negative, char, expr */
    switch (k) { case 1: switch (k) { case 1: k = 5; break; } k = 6; break; }   /* nested switch, no default */
    switch (k) { }                                            /* empty switch */
    switch (k) { case 1: { int z = 1; k = z; break; } }
    enum Color col = BLUE;
    switch (col) { case RED: k = 0; break; case GREEN: k = 1; break; case BLUE: k = 2; break; }
    /* goto: forward, backward, label before }, label on loop */
    goto fwd;
back:
    k++;
    if (k < 3) goto back;
fwd:
    k++;
    {
        k++;
    end: ;
    }
    while (1) { while (1) { break; } break; }
    for (i = 0; i < 2; i++) for (j = 0; j < 2; j++) { if (j) break; else continue; }
    return k;
}
