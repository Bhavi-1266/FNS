/* Invalid: broken expressions. */
#include <stdio.h>

int main(void) {
    int x = 5;
    int y = ;
    int total = x +;
    int z = 10;

    printf("z = %d\n", z);
    return 0;
}
