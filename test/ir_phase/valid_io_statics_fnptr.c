/* Valid: printf/scanf/file I/O externs, variadic calls, function pointers,
   static locals (incl. recursion and same name in two functions), argc/argv, malloc family. */
#include <stdio.h>
typedef void FILE;
double half(double x);
void noop(void) { return; }
int noret(int a) { if (a) return 1; }
double half(double x) { return x / 2; }
static int counter(void) { static int n = 0; static int m; return ++n + m; }
static int counter2(void) { static int n = 10; return n--; }
int rec(int n) { static int depth = 0; depth++; if (n <= 0) return depth; return rec(n - 1); }
int vsum(int n, ...) { return n; }
int apply(int (*f)(int, int), int a, int b) { return f(a, b); }
int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int main(int argc, char **argv) {
    int x; float fl = 1.5f; char ch = 'q'; short sh = 2; double d = 3.0;
    printf("x=%d f=%f c=%c s=%hd d=%f str=%s\n", x, fl, ch, sh, d, "lit");
    printf("plain\n"); printf("%s", argv[0]);
    scanf("%d %f %c", &x, &fl, &ch);
    int ret = scanf("%d", &x);
    if (argc > 1) x = argv[1][0] - '0';
    char *fname = argv[argc - 1]; char **av = argv + 1;
    FILE *fp = fopen("a.txt", "w"); fprintf(fp, "%d\n", x); fclose(fp);
    void *fp2 = fopen(fname, "r"); char buf[32]; fgets(buf, 32, fp2); fscanf(fp2, "%d", &x); fclose(fp2);
    int n = vsum(0) + vsum(1, 2) + vsum(3, 1.5, 'c', sh, fl);
    noop(); half(2.0); int (*fp3)(int, int) = add; fp3 = &sub; 
    int r = apply(add, 1, 2) + apply(fp3, 3, 4) + fp3(1, 1) + (*fp3)(2, 2);
    int c = counter() + counter() + counter2() + rec(3) + noret(1) + (int)half(4.0);
    int (*recp)(int) = rec; c += recp(1);
    int *mp = malloc(sizeof(int) * 4); mp[0] = 1; free(mp); int *mc = (int *) calloc(4, sizeof(int)); mc = realloc(mc, 8); free(mc);
    exit(0);
    return x + ret + n + r + c;
}
