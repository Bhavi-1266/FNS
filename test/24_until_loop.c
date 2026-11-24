/* Feature: the FNS `until` loop:  do { body } until (cond);
   The body runs once, then repeats while cond is FALSE (it stops once cond is true).
   Equivalent C: do { body } while (!(cond));  break / continue work inside it. */
#include <stdio.h>

int main() {
    int i = 0;
    do {
        printf("%d ", i);
        i++;
    } until (i == 5);
    printf("\n");

    /* the body runs once even if the condition is already true */
    int n = 100;
    do { printf("ran once with n=%d\n", n); } until (n > 0);

    /* digits of a number */
    int x = 4096, digits = 0;
    do { digits++; x /= 10; } until (x == 0);
    printf("digits=%d\n", digits);

    /* continue jumps to the until-test; break leaves the loop */
    int k = 0, odd_sum = 0;
    do {
        k++;
        if (k % 2 == 0) continue;
        if (k > 9) break;
        odd_sum += k;
    } until (k >= 20);
    printf("k=%d odd_sum=%d\n", k, odd_sum);

    /* nested until loops */
    int r = 0;
    do {
        int c = 0;
        do { printf("%d%d ", r, c); c++; } until (c > r);
        r++;
    } until (r == 3);
    printf("\n");

    /* Collatz steps */
    int v = 27, steps = 0;
    do {
        v = (v % 2 == 0) ? v / 2 : 3 * v + 1;
        steps++;
    } until (v == 1);
    printf("collatz(27) steps=%d\n", steps);
    return 0;
}
