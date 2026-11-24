/* Must fail: syntax errors.  The parser reports each one with its line number
   and recovers at the next ';' or '}' so later errors are found too. */
#include <stdio.h>

int main() {
    int a = 5
    int b = 10;
    if (a > b {
        printf("never\n");
    }
    int c = (a + * b);
    printf("%d\n", a);
    return 0;
}
