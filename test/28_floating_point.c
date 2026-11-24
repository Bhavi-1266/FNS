/* Feature: single- and double-precision floating point: arithmetic,
 * comparisons, int<->float<->double conversions, negation and a function
 * that takes and returns doubles.  Values are chosen to be exact in binary
 * floating point so the printed output is stable.                          */
#include <stdio.h>


double average(double a, double b) { return (a + b) / 2.0; }

int main() {
    /* double arithmetic */
    double x = 2.5, y = 1.25;
    printf("sum=%f diff=%f prod=%f\n", x + y, x - y, x * y);  /* 3.75 1.25 3.125 */
    printf("avg=%f\n", average(x, y));                        /* 1.875 */

    /* single precision */
    float f = 0.5;
    float g = f * 3.0;                                        /* 1.5 */
    printf("g=%f\n", (double) g);                             /* 1.5 */

    /* conversions */
    int n = (int) 7.75;            /* truncates to 7 */
    double d = (double) n + 0.25;  /* 7.25 */
    float back = (float) n;        /* 7.0 */
    printf("n=%d d=%f back=%f\n", n, d, (double) back);       /* 7 7.25 7 */

    /* comparisons (result is int 0/1) */
    printf("gt=%d le=%d eq=%d\n", x > y, f <= 0.5, x == 2.5); /* 1 1 1 */

    /* negation */
    printf("neg=%f\n", -x);                                   /* -2.5 */

    /* a tiny numeric routine: average of an array of doubles */
    double vals[4];
    vals[0] = 1.0; vals[1] = 2.0; vals[2] = 3.0; vals[3] = 4.0;
    double acc = 0.0;
    int i;
    for (i = 0; i < 4; i++) acc = acc + vals[i];
    printf("mean=%f\n", acc / 4.0);                           /* 2.5 */
    return 0;
}
