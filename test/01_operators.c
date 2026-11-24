/* Feature: all arithmetic, relational, logical, bitwise and assignment operators. */
#include <stdio.h>

int side_effect_count = 0;
int touch(int v) { side_effect_count++; return v; }

int main() {
    int a = 17, b = 5, c = -17;
    unsigned int u = 3000000000u, w = 7;
    char ch = 'A';
    double x = 7.5, y = 2.0;

    /* arithmetic, including negative division/modulo (truncates toward zero) */
    printf("%d %d %d %d %d\n", a + b, a - b, a * b, a / b, a % b);
    printf("%d %d %d %d\n", c / b, c % b, a / -b, a % -b);
    printf("%d %d %d\n", -a, +a, -(-a));
    printf("%.3f %.3f %.3f %.3f\n", x + y, x - y, x * y, x / y);
    printf("%.3f %d\n", a / 2.0, (int)(x * 3));          /* mixed int/double */
    printf("%u %u %u\n", u + u, u / w, w - 8);            /* unsigned wrap-around */
    printf("%d %c %d\n", ch + 1, ch + 2, 'z' - 'a');       /* char arithmetic */
    printf("%d %d %d %d %d\n", '\x41', '\101', '\0', '\t', '\\');   /* escapes */

    /* relational */
    printf("%d %d %d %d %d %d\n", a == b, a != b, a < b, a > b, a <= 17, a >= 18);
    printf("%d %d\n", u > 5u, -1 < 0);

    /* logical with short-circuit */
    side_effect_count = 0;
    int r1 = (a > 100) && touch(1);
    int r2 = (a > 0) || touch(1);
    int r3 = (a > 0) && touch(0);
    printf("%d %d %d %d %d\n", r1, r2, r3, !a, side_effect_count);
    printf("%d %d %d\n", !0, !!42, (a && b) || (c && 0));

    /* bitwise and shifts */
    printf("%d %d %d %d\n", a & b, a | b, a ^ b, ~a);
    printf("%d %d %d %u\n", a << 3, a >> 2, c >> 2, u >> 28);
    printf("%x %X %o\n", 0xF0F0 & 0x0FF0, 0xABC | 0x111, 8 ^ 15);

    /* assignment operators */
    int k = 10;
    k += 5; printf("%d ", k);
    k -= 3; printf("%d ", k);
    k *= 4; printf("%d ", k);
    k /= 6; printf("%d ", k);
    k %= 5; printf("%d ", k);
    k <<= 4; printf("%d ", k);
    k >>= 2; printf("%d ", k);
    k &= 6; printf("%d ", k);
    k |= 9; printf("%d ", k);
    k ^= 3; printf("%d\n", k);

    /* increment / decrement */
    int i = 5;
    int p = i++, q = ++i, s = i--, t = --i;
    printf("%d %d %d %d %d\n", p, q, s, t, i);

    /* ternary, comma, precedence */
    int m = a > b ? a : b;
    int n = (a = 3, b = 4, a * b);
    printf("%d %d %d %d\n", m, n, 2 + 3 * 4 - 6 / 2, (2 + 3) * (4 - 6) / 2);
    printf("%d %d\n", 1 + 2 << 1, 5 & 3 == 3);
    int chain1, chain2;
    chain1 = chain2 = 9;
    printf("%d %d\n", chain1, chain2);
    printf("%d\n", a < b ? (b < 10 ? 1 : 2) : 3);
    return 0;
}
