// Test 34: IR optimisations - constant folding, constant/copy propagation and
// strength reduction must not change any result, including the edge cases:
// signed division/remainder of negative numbers (must stay a real division),
// unsigned division/remainder with the top bit set, 32-bit wrap-around,
// shifts of negative numbers, calls whose result is multiplied by 0, unsigned
// comparisons against large literals, values that only meet after a ?:,
// constants that reach a label on all paths or only on some, and jump chains.
#include <stdio.h>

int calls = 0;

int noisy(int v) {             // has a side effect: must still be called for noisy() * 0
    calls++;
    printf("noisy(%d)\n", v);
    return v;
}

int div4(int v) { return v / 4; }
int mod4(int v) { return v % 4; }
int div1(int v) { return v / 1; }
int times8(int v) { return v * 8; }
int eight_times(int v) { return 8 * v; }
int plus0(int v) { return v + 0 - 0; }
unsigned int udiv8(unsigned int u) { return u / 8; }
unsigned int umod8(unsigned int u) { return u % 8; }
unsigned int umod1(unsigned int u) { return u % 1; }

int main(void) {
    // ---- constant folding ----
    int a = 3 * 4 + 2;                    // 14
    int b = (a - 4) / 3;                  // 3
    int c = -7 >> 1;                      // -4 (arithmetic shift)
    int d = !0 + ~5 + -(-3);              // 1 - 6 + 3 = -2
    int e = (10 > 3) + (10 == 3) * 5;     // 1
    unsigned int top = 1u << 31;          // 2147483648
    unsigned int wrap = 4294967295u;
    wrap = wrap + 1u;                     // 0
    printf("fold: %d %d %d %d %d %u %u\n", a, b, c, d, e, top, wrap);

    // ---- constant propagation through variables and branches ----
    const int N = 5;
    int scale = 4;
    int sum = 0;
    for (int i = 0; i < N; i++) sum += i * scale;    // 0+4+8+12+16 = 40
    if (0) printf("never printed\n");
    while (0) printf("never printed either\n");
    int n = 3;
    double half = n / 2.0;                            // 1.5: int constant into a double division
    printf("prop: sum=%d half=%.2f\n", sum, half);

    // ---- copy propagation ----
    int q = 41;
    int p = q;
    int r = p;
    r = r + 1;
    int x = 7, y = 9;
    int m = (x > y) ? x : y;                          // the ?: result is a temporary set on two paths
    int mcopy = m;
    x = 100;                                          // later changes must not leak into the copies
    printf("copy: p=%d q=%d r=%d m=%d mcopy=%d x=%d\n", p, q, r, m, mcopy, x);

    // ---- strength reduction ----
    printf("signed div: %d %d %d %d\n", div4(-7), div4(7), div4(-8), div1(-5));   // -1 1 -2 -5
    printf("signed mod: %d %d %d\n", mod4(-7), mod4(7), mod4(-8));               // -3 3 0
    printf("mul: %d %d %d %d\n", times8(-3), eight_times(-3), times8(-268435456), plus0(-9));
    unsigned int big = 0x80000005u;
    printf("unsigned: %u %u %u %u\n", udiv8(big), umod8(big), umod1(big), udiv8(7u));
    int zero = noisy(6) * 0;                          // the call still happens
    printf("zero=%d calls=%d\n", zero, calls);

    // ---- comparisons the back end must keep unsigned ----
    unsigned int one = 1;
    printf("ucmp: %d %d\n", one < 4294967295u, (unsigned int)-1 > one);       // 1 1

    // ---- array indexing (scaled by << after the change) ----
    int arr[6];
    for (int i = 0; i < 6; i++) arr[i] = i * i;
    int idx = 5;
    printf("arr: %d %d\n", arr[idx], arr[idx - 2]);                           // 25 9

    // ---- constants across blocks: kept only where every path agrees ----
    int same, diff2;
    if (calls > 0) { same = 10; diff2 = 1; } else { same = 10; diff2 = 2; }
    printf("join: %d %d\n", same * 2, diff2);                                 // 20 1
    int s = 1;
    for (int k = 0; k < 4; k++) s = s * 3;            // s changes in the loop: not a constant
    printf("loop: %d\n", s);                                                 // 81

    // ---- jump clean-up: break/continue chains, goto chains, dead code ----
    int hits = 0;
    for (int k = 0; k < 10; k++) {
        if (k % 2) continue;
        if (k > 6) break;
        hits++;
    }
    goto first;
    printf("skipped\n");
first:
    goto second;
second:
    if (hits == 4) printf("jumps: hits=%d\n", hits);                        // 4
    return 0;
}
