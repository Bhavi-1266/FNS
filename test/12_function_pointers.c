/* Feature: function pointers: declaration, typedef, arrays of them, callbacks,
   returning results through them, qsort comparators. */
#include <stdio.h>
#include <stdlib.h>

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }
int maxi(int a, int b) { return a > b ? a : b; }

typedef int (*binop)(int, int);

int fold(int *a, int n, binop f, int init) {
    int acc = init;
    for (int i = 0; i < n; i++) acc = f(acc, a[i]);
    return acc;
}

void for_each(int *a, int n, void (*visit)(int)) { for (int i = 0; i < n; i++) visit(a[i]); }
void show(int x) { printf("<%d>", x); }
void show_square(int x) { printf("<%d>", x * x); }

int cmp_asc(const void *p, const void *q) { return *(const int *)p - *(const int *)q; }
int cmp_desc(const void *p, const void *q) { return *(const int *)q - *(const int *)p; }

double apply_d(double (*g)(double), double v) { return g(v); }
double half(double v) { return v / 2; }

binop choose(char op) {
    switch (op) {
        case '+': return add;
        case '-': return sub;
        default: return mul;
    }
}

int main() {
    int (*fp)(int, int) = add;
    printf("%d %d\n", fp(2, 3), (*fp)(10, 4));
    fp = &sub;
    printf("%d\n", fp(2, 3));

    binop table[4] = {add, sub, mul, maxi};
    const char *names[4] = {"add", "sub", "mul", "max"};
    for (int i = 0; i < 4; i++) printf("%s(7,3)=%d ", names[i], table[i](7, 3));
    printf("\n");

    int data[6] = {5, 3, 9, 1, 7, 2};
    printf("sum=%d product=%d max=%d\n", fold(data, 6, add, 0), fold(data, 6, mul, 1), fold(data, 6, maxi, 0));
    for_each(data, 6, show);
    printf("\n");
    for_each(data, 3, show_square);
    printf("\n");

    qsort(data, 6, sizeof(int), cmp_asc);
    for (int i = 0; i < 6; i++) printf("%d ", data[i]);
    printf("\n");
    qsort(data, 6, sizeof(int), cmp_desc);
    for (int i = 0; i < 6; i++) printf("%d ", data[i]);
    printf("\n");

    printf("%.2f\n", apply_d(half, 9.0));
    printf("%d %d %d\n", choose('+')(6, 2), choose('-')(6, 2), choose('*')(6, 2));
    binop none = NULL;
    printf("none is %s\n", none == NULL ? "null" : "set");
    return 0;
}
