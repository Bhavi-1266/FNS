/* Feature: multi-level pointers into multi-dimensional arrays: *(*(a + i) + j), **a,
   row pointers, pointer-to-array variables int (*p)[N]; casts to typedef / enum names;
   constant-expression array bounds. */
#include <stdio.h>
int g[3][4];
typedef unsigned char Byte;
typedef enum { LOW, MID, HIGH } Level;
enum { ROWS = 2, COLS = 3 };
#define M 5

int row_sum(int (*rows)[4], int n) {          /* parameter declared as a pointer to arrays */
    int s = 0;
    for (int (*r)[4] = rows; r < rows + n; r++)
        for (int j = 0; j < 4; j++) s += (*r)[j];
    return s;
}

int main() {
    int a[2][3] = {{1, 2, 3}, {4, 5, 6}};
    int b[2][2][2] = {1, 2, 3, 4, 5, 6, 7, 8};
    for (int i = 0; i < 3; i++) for (int j = 0; j < 4; j++) g[i][j] = i * 4 + j;
    printf("%d %d %d %d\n", *(*(a + 1) + 2), **a, *(*a + 1), *(a[1] + 1));
    for (int i = 0; i < 2; i++) { for (int j = 0; j < 3; j++) printf("%d ", *(*(a + i) + j)); }
    printf("\n%d %d %d\n", *(*(*(b + 1) + 1) + 0), *(*(g + 2) + 3), (int)(*(g + 1) - *g));
    int *row = *(a + 1);
    printf("%d %d\n", row[0], *(row + 2));
    int k = 2;
    Level l = (Level)k;
    Byte by = (Byte)300;
    int m[ROWS][COLS * 2];
    char name[M + 1] = "hello";
    int sz[sizeof(int) * 2];
    printf("%d %d %d %d %s %d\n", l, by, (int)sizeof(m), (int)(sizeof(sz) / sizeof(sz[0])), name, HIGH);
    int (*pg)[4] = g;                          /* pointer to an array of 4 ints */
    pg++;
    int (*last)[4] = &g[2];
    printf("pointer to array: %d %d %d %d rows apart=%d size=%d\n", pg[0][1], (*pg)[3], last[0][0],
           *(*(pg + 1) + 2), (int)(last - pg), (int)sizeof(*pg));
    printf("row sums: %d %d\n", row_sum(g, 3), row_sum(pg, 2));
    return 0;
}
