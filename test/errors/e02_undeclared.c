/* Must fail: undeclared names, calls to functions that exist nowhere,
   wrong number of arguments. */
#include <stdio.h>

int add(int a, int b) { return a + b; }

int main() {
    int x = 4;
    y = x + 1;                    /* y was never declared */
    printf("%d\n", add(x));       /* too few arguments */
    printf("%d\n", add(1, 2, 3)); /* too many arguments */
    int z = undefined_function(x);
    return 0;
}
