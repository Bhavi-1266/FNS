/* Feature: for, while, do-while loops (nested, empty bodies, missing parts). */
#include <stdio.h>

int main() {
    int i, j, sum = 0;

    /* for: count up, count down, step 3, two variables */
    for (i = 1; i <= 10; i++) sum += i;
    printf("sum 1..10 = %d\n", sum);
    for (i = 10; i > 0; i -= 3) printf("%d ", i);
    printf("\n");
    for (i = 0, j = 10; i < j; i++, j--) printf("(%d,%d)", i, j);
    printf("\n");

    /* for with missing parts */
    i = 0;
    for (;;) { if (++i == 4) break; }
    printf("infinite for left at %d\n", i);
    for (i = 0; i < 3;) i++;
    printf("no-step for: %d\n", i);

    /* loop that never runs, empty body */
    for (i = 5; i < 5; i++) printf("never\n");
    for (i = 0; i < 1000; i++) ;
    printf("empty body ran to %d\n", i);

    /* while: digits of a number, reverse */
    int n = 907150, rev = 0, digits = 0;
    while (n > 0) { rev = rev * 10 + n % 10; n /= 10; digits++; }
    printf("reversed=%d digits=%d\n", rev, digits);

    /* while with false condition */
    while (0) printf("never\n");

    /* do-while runs at least once */
    int k = 100;
    do { printf("do-while body k=%d\n", k); k++; } while (k < 50);
    k = 0;
    do k += 2; while (k < 9);
    printf("k=%d\n", k);

    /* nested loops: multiplication table and a triangle */
    for (i = 1; i <= 4; i++) {
        for (j = 1; j <= 4; j++) printf("%4d", i * j);
        printf("\n");
    }
    for (i = 1; i <= 4; i++) {
        j = 0;
        while (j < i) { printf("*"); j++; }
        printf("\n");
    }

    /* primes below 50 */
    for (i = 2; i < 50; i++) {
        int prime = 1;
        for (j = 2; j * j <= i; j++)
            if (i % j == 0) { prime = 0; break; }
        if (prime) printf("%d ", i);
    }
    printf("\n");

    /* loop variable declared in for, shadowing an outer variable */
    int x = 99;
    for (int x = 0; x < 2; x++) printf("inner x=%d\n", x);
    printf("outer x=%d\n", x);
    return 0;
}
