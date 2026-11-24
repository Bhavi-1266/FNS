/* Feature: switch: fallthrough, default anywhere, nested switch, char and enum labels,
   negative and constant-expression labels, break inside switch inside loop. */
#include <stdio.h>

enum Op { ADD = 1, SUB, MUL = 10, DIV };

int calc(enum Op op, int a, int b) {
    switch (op) {
        case ADD: return a + b;
        case SUB: return a - b;
        case MUL: return a * b;
        case DIV: return b ? a / b : 0;
    }
    return -999;
}

const char *kind(char c) {
    switch (c) {
        case 'a': case 'e': case 'i': case 'o': case 'u':
            return "vowel";
        case ' ':
            return "space";
        default:
            if (c >= '0' && c <= '9') return "digit";
            return "consonant";
    }
}

int main() {
    /* fallthrough accumulates */
    for (int n = 0; n <= 4; n++) {
        int acc = 0;
        switch (n) {
            case 0: acc += 1;
            case 1: acc += 10;
            case 2: acc += 100; break;
            case 3: acc += 1000;
            default: acc += 5;
        }
        printf("n=%d acc=%d\n", n, acc);
    }

    /* default in the middle, negative and expression labels */
    int vals[] = {-1, 4, 7, 8, 100};
    for (int i = 0; i < 5; i++) {
        switch (vals[i]) {
            case -1: printf("minus one\n"); break;
            default: printf("other %d\n", vals[i]); break;
            case 2 * 2: printf("four\n"); break;
            case 7: printf("seven\n");
            case 8: printf("seven-or-eight\n"); break;
        }
    }

    printf("%d %d %d %d\n", calc(ADD, 6, 3), calc(SUB, 6, 3), calc(MUL, 6, 3), calc(DIV, 6, 3));
    const char *word = "hi 2u";
    for (int i = 0; word[i]; i++) printf("%c:%s ", word[i], kind(word[i]));
    printf("\n");

    /* nested switch, and break inside switch only leaves the switch */
    int count = 0;
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0:
                switch (count) { case 0: printf("outer0 inner0\n"); break; default: printf("never\n"); }
                break;
            case 1:
                count += 10;
                break;
            default:
                printf("i=%d count=%d\n", i, count);
        }
    }

    /* switch with no matching case and no default */
    switch (42) { case 1: printf("never\n"); }
    printf("done\n");
    return 0;
}
