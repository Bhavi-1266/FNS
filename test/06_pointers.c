/* Feature: pointers: address-of, dereference, arithmetic, comparison, pointer to array
   elements, pointers to structs, swap, NULL, void*, multi-level pointers (**, ***). */
#include <stdio.h>
#include <stdlib.h>

void swap(int *x, int *y) { int t = *x; *x = *y; *y = t; }

void set_ptr(int **pp, int *target) { *pp = target; }

int *find_max(int *a, int n) {
    int *best = a;
    for (int *p = a; p < a + n; p++) if (*p > *best) best = p;
    return best;
}

struct Point { int x, y; };

int main() {
    int a = 5, b = 9;
    int *p = &a;
    printf("%d %d\n", *p, *p + 1);
    *p = 50;
    printf("a=%d\n", a);
    swap(&a, &b);
    printf("after swap a=%d b=%d\n", a, b);

    int arr[6] = {3, 8, 1, 9, 4, 7};
    int *q = arr;
    printf("%d %d %d\n", *(q + 2), q[3], *(arr + 5));
    int *m = find_max(arr, 6);
    printf("max %d at index %d\n", *m, (int)(m - arr));
    int *end = &arr[5];
    printf("distance %d, q<end %d, q==arr %d\n", (int)(end - q), q < end, q == arr);
    q++; q += 2;
    printf("after moves: %d\n", *q);
    q--;
    printf("back one: %d\n", *q);

    /* pointer walk over a char array */
    char s[] = "pointer";
    char *c = s;
    while (*c) { *c = *c - 32; c++; }
    printf("%s len=%d\n", s, (int)(c - s));

    /* multi-level pointers */
    int v = 1;
    int *p1 = &v;
    int **p2 = &p1;
    int ***p3 = &p2;
    ***p3 = 77;
    printf("v=%d **p2=%d\n", v, **p2);
    int other = 123;
    set_ptr(p2, &other);
    printf("p1 now -> %d, ***p3=%d\n", *p1, ***p3);

    /* struct pointers */
    struct Point pt = {2, 3};
    struct Point *pp = &pt;
    pp->x = 20;
    (*pp).y += 30;
    printf("pt=(%d,%d)\n", pt.x, pt.y);

    /* NULL and void* */
    int *nothing = NULL;
    if (nothing == NULL) printf("null pointer ok\n");
    void *vp = &b;
    int *back = (int *)vp;
    printf("via void*: %d\n", *back);

    /* array of pointers and pointer to pointer iteration */
    int x1 = 1, x2 = 2, x3 = 3;
    int *ptrs[3] = {&x1, &x2, &x3};
    int **walk = ptrs;
    int total = 0;
    for (int i = 0; i < 3; i++) total += **(walk + i);
    printf("total via int** = %d\n", total);

    /* heap array of pointers (int **) used as a jagged 2-D array */
    int **rows = (int **)malloc(3 * sizeof(int *));
    for (int i = 0; i < 3; i++) {
        rows[i] = (int *)malloc((i + 1) * sizeof(int));
        for (int j = 0; j <= i; j++) rows[i][j] = i * 10 + j;
    }
    printf("%d %d %d\n", rows[0][0], rows[1][1], rows[2][2]);
    for (int i = 0; i < 3; i++) free(rows[i]);
    free(rows);
    return 0;
}
