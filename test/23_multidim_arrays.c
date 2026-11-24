/* Feature: multi-dimensional arrays: 2-D/3-D, initialisers (nested, flat, partial),
   passing to functions, matrix multiply/transpose, char 2-D arrays, row pointers. */
#include <stdio.h>

#define N 3

void print_matrix(int m[][N], int rows) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < N; j++) printf("%4d", m[i][j]);
        printf("\n");
    }
}

void multiply(int a[N][N], int b[N][N], int c[N][N]) {
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) {
            c[i][j] = 0;
            for (int k = 0; k < N; k++) c[i][j] += a[i][k] * b[k][j];
        }
}

int trace(int m[N][N]) { int t = 0; for (int i = 0; i < N; i++) t += m[i][i]; return t; }

int cube[2][3][4];

int main() {
    int a[N][N] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
    int b[N][N] = {1, 0, 0, 0, 2, 0, 0, 0, 3};       /* flat initialiser */
    int c[N][N];
    int partial[3][3] = {{1}, {2, 2}};               /* rest is zero */
    multiply(a, b, c);
    print_matrix(c, N);
    print_matrix(partial, 3);
    printf("trace(a)=%d\n", trace(a));

    int t[N][N];
    for (int i = 0; i < N; i++) for (int j = 0; j < N; j++) t[j][i] = a[i][j];
    print_matrix(t, N);

    for (int i = 0; i < 2; i++)
        for (int j = 0; j < 3; j++)
            for (int k = 0; k < 4; k++) cube[i][j][k] = i * 100 + j * 10 + k;
    printf("cube[1][2][3]=%d cube[0][1][2]=%d sizeof=%d\n", cube[1][2][3], cube[0][1][2], (int)sizeof(cube));

    double grid[2][2] = {{0.5, 1.5}, {2.5, 3.5}};
    double sum = 0;
    for (int i = 0; i < 2; i++) for (int j = 0; j < 2; j++) sum += grid[i][j];
    printf("double grid sum=%.2f\n", sum);

    char words[4][10] = {"one", "two", "three", "four"};
    for (int i = 0; i < 4; i++) printf("%s(%c) ", words[i], words[i][1]);
    printf("\n");
    words[2][0] = 'T';
    printf("%s\n", words[2]);

    int *row = a[1];                                  /* a row decays to a pointer */
    printf("row: %d %d %d\n", row[0], row[1], row[2]);
    int *flat = &a[0][0];
    printf("flat[7]=%d\n", flat[7]);

    int jag[3][4] = {{0}};
    int k = 0;
    for (int i = 0; i < 3; i++) for (int j = 0; j <= i; j++) jag[i][j] = ++k;
    for (int i = 0; i < 3; i++) { for (int j = 0; j < 4; j++) printf("%d ", jag[i][j]); printf("| "); }
    printf("\n");
    return 0;
}
