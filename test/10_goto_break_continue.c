/* Feature: goto (forward, backward, out of nested loops), break, continue in every loop. */
#include <stdio.h>

int main() {
    /* backward goto as a loop */
    int i = 0;
again:
    printf("%d ", i);
    i++;
    if (i < 5) goto again;
    printf("\n");

    /* forward goto skipping code */
    int x = 1;
    if (x) goto skip;
    printf("not printed\n");
skip:
    printf("skipped ahead\n");

    /* goto out of nested loops */
    int r, c, found = 0;
    for (r = 0; r < 5; r++)
        for (c = 0; c < 5; c++)
            if (r * c == 6) { found = 1; goto done; }
done:
    printf("found=%d at r=%d c=%d\n", found, r, c);

    /* break and continue in for */
    for (i = 0; i < 10; i++) {
        if (i % 3 == 0) continue;
        if (i > 7) break;
        printf("%d ", i);
    }
    printf("\n");

    /* in while */
    i = 0;
    while (1) {
        i++;
        if (i % 2) continue;
        if (i > 8) break;
        printf("w%d ", i);
    }
    printf("\n");

    /* in do-while: continue jumps to the condition */
    i = 0;
    do {
        i++;
        if (i == 2) continue;
        printf("d%d ", i);
    } while (i < 4);
    printf("\n");

    /* break only leaves the innermost loop */
    for (int a = 0; a < 3; a++) {
        for (int b = 0; b < 3; b++) {
            if (b == 1) break;
            printf("(%d,%d)", a, b);
        }
    }
    printf("\n");

    /* continue inside a switch inside a loop continues the loop */
    for (i = 0; i < 4; i++) {
        switch (i) {
            case 1: continue;
            case 2: break;
            default: printf("s%d ", i);
        }
        printf("after%d ", i);
    }
    printf("\n");

    /* goto into a label at the end of a block */
    int n = 3;
    while (n > 0) {
        n--;
        if (n == 1) goto next;
        printf("n=%d ", n);
    next:;
    }
    printf("\n");
    return 0;
}
