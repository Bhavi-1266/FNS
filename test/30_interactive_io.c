/* Feature: interactive input/output through the runtime library.
 * Reads values with scanf and echoes computed results with printf.
 * The matching input is in test/input/30_interactive_io.in                            */
#include <stdio.h>


int main() {
    int n;
    printf("Enter an integer:\n");
    scanf("%d", &n);
    printf("square=%d cube=%d\n", n * n, n * n * n);

    int a, b;
    printf("Enter two integers:\n");
    scanf("%d", &a);
    scanf("%d", &b);
    printf("sum=%d max=%d\n", a + b, (a > b) ? a : b);

    char name[32];
    printf("Enter your name:\n");
    scanf("%s", name);
    printf("Hello, %s!\n", name);

    /* read characters until the '#' sentinel, counting the digits seen */
    int digits = 0, ch;
    printf("Enter text ending with '#':\n");
    while (1) {
        ch = getchar();
        if (ch == '#') break;
        if (ch >= '0' && ch <= '9') digits++;
    }
    printf("digits=%d\n", digits);
    return 0;
}
