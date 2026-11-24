/* Feature: preprocessor: #define constants and function-like macros (with # and ##),
   #undef, #ifdef / #ifndef / #if / #elif / #else, macros used as array sizes,
   predefined NULL / EOF / INT_MAX, multi-line macros. */
#include <stdio.h>
#include <limits.h>

#define SIZE 5
#define PI 3.14159
#define SQUARE(x) ((x) * (x))
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define STR(x) #x
#define GLUE(a, b) a##b
#define AREA(r) (PI * SQUARE(r))
#define SWAP(t, a, b) do { t tmp_ = a; a = b; b = tmp_; } while (0)
#define PRINT_SUM(a, b) \
    printf("%d + %d = %d\n", a, b, (a) + (b))
#define DEBUG 1
#define VERSION 3

int main() {
    int arr[SIZE];
    for (int i = 0; i < SIZE; i++) arr[i] = SQUARE(i + 1);
    printf("%d %d %d\n", arr[0], arr[SIZE - 1], (int)(sizeof(arr) / sizeof(arr[0])));
    printf("max=%d area=%.3f\n", MAX(7, SIZE * 2), AREA(2.0));
    printf("%s %s\n", STR(hello), STR(1 + 2));
    int GLUE(var, 42) = 9;
    printf("var42=%d\n", var42);
    int x = 1, y = 2;
    SWAP(int, x, y);
    printf("x=%d y=%d\n", x, y);
    PRINT_SUM(20, 22);

#ifdef DEBUG
    printf("debug on\n");
#else
    printf("debug off\n");
#endif
#ifndef RELEASE
    printf("not a release build\n");
#endif
#if VERSION >= 3 && defined(DEBUG)
    printf("version 3+\n");
#elif VERSION == 2
    printf("version 2\n");
#else
    printf("old version\n");
#endif
#undef DEBUG
#ifdef DEBUG
    printf("still debug\n");
#endif
#if 0
    this text is never compiled
#endif
    int *p = NULL;
    printf("NULL=%d EOF=%d INT_MAX=%d INT_MIN=%d\n", p == NULL, EOF, INT_MAX, INT_MIN);
    printf("SQUARE(1+2)=%d\n", SQUARE(1 + 2));
    return 0;
}
