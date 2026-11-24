/* Must fail: type errors. */
#include <stdio.h>

struct P { int x, y; };
void nothing(void) {}
int value(void) { return 1; }

int main() {
    struct P p;
    int i = p;                    /* struct assigned to int */
    int j = nothing();            /* void value used */
    double d = 2.5;
    switch (d) { case 1: break; } /* switch on a double */
    int k = *i;                   /* dereference of a non-pointer */
    int arr[3];
    arr = 0;                      /* assignment to an array */
    p.z = 3;                      /* no such member */
    return;                       /* return without a value in int main is allowed */
}
