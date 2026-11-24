/* Valid: constructs that the generator previously mishandled or rejected.
   2-D array parameters, 2-D char arrays with string initialisers, casts with sign
   specifiers and to struct pointers, arrays of function pointers, typedef'd function
   pointers, const/static aggregates, local struct/enum/typedef definitions, const
   pointers, char pointer increments, and a user label that looks like a generated one. */
struct S { int a; };
typedef struct S S_t;
typedef int (*binop)(int, int);
int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int sum2d(int m[2][3]) { return m[1][2]; }
int sum1d(int a[], int n) { return a[n - 1]; }
int main(void) {
    int grid[2][3] = {{1, 2, 3}, {4, 5, 6}};
    char names[2][8] = {"ab", "cd"};
    int v = 300; double d = 2.5; void *vp = 0;
    unsigned char uc = (unsigned char) v;
    unsigned int u = (unsigned) d;
    long l = (long) d;
    int sz = sizeof(unsigned int) + sizeof(long long) + sizeof(unsigned char);
    struct S *sp = (struct S *) vp;
    S_t *tp = (S_t *) vp;
    int (*fpa[2])(int, int) = {add, sub};
    binop ops[2] = {sub, add};
    binop one = add;
    const struct S cs = {7};
    static struct S ss;
    const struct S *pcs = &cs;
    int *const cp = &v;
    struct Local { int x; int y; };
    enum Mode { OFF, ON = 4, AUTO };
    typedef int count_t;
    struct Local loc; loc.x = 1; loc.y = 2;
    enum Mode m = AUTO;
    count_t c = 3;
    char buf[4] = "abc"; char *p = buf; p++; ++p; p--;
    int r = sum2d(grid) + sum1d(grid[1], 3) + names[1][1] + uc + (int) u + (int) l + sz;
    r += fpa[1](5, 3) + (*fpa[0])(1, 1) + ops[0](2, 1) + one(1, 2) + pcs->a + *cp + loc.x + loc.y + m + c + *p;
    if (sp == tp) r++;
L1:
    r++;
    if (r < 0) goto L1;
    ss.a = r;
    return ss.a;
}
