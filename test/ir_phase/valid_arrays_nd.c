/* Valid: 1-D/2-D/3-D arrays, inferred bounds, string initialisers, pointer
   difference, array of pointers, sizeof on arrays, passing rows to functions. */
int sumptr(int *p, int n) { int s = 0; for (int i = 0; i < n; i++) s += p[i]; return s; }
int main(void) {
    int a[5] = {1, 2};                 /* zero fill */
    int b[] = {1, 2, 3, 4};            /* inferred */
    char s1[8] = "fns";                /* literal copy */
    char s2[] = "hello";               /* inferred 6 */
    char s3[4] = {'a', 'b', 'c', '\0'};
    int m[2][3] = {{1, 2, 3}, {4, 5, 6}};
    int m3[2][2][2] = {{{1,2},{3,4}},{{5,6},{7,8}}};
    int i = 1, j = 2;
    int x = m[i][j];                   /* expect i*3+j scaled 4 */
    m[1][0] = m3[1][0][1];
    int y = m3[i][j-1][0];
    a[i] += 2; a[i]++; ++a[i]; a[a[0]] = a[1];
    int *p = a; int *q = &a[4]; int diff = q - p;   /* 4 */
    int *r = p + 2; r = r - 1; p++; --p;
    int z = *(a + 3) + p[1];
    int *parr = &a[0];
    int *ap[2] = {a, b};               /* array of pointers */
    int w = ap[1][2];
    int t = sumptr(a, 5) + sumptr(&m[1][0], 3) + sizeof(a) + sizeof(m) + sizeof(s2) + sizeof(m3) / sizeof(m3[0]);
    char ch = s2[0]; s1[0] = s2[1];
    int len = 0; while (s2[len]) len++;
    return x + y + diff + z + w + t + ch + len;
}
