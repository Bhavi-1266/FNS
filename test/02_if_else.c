/* Feature: if / else-if / else, nesting, dangling else, conditions of every scalar type. */
#include <stdio.h>

const char *grade(int score) {
    if (score >= 90) return "A";
    else if (score >= 80) return "B";
    else if (score >= 70) return "C";
    else if (score >= 60) return "D";
    else return "F";
}

int classify(int x) {
    if (x > 0) {
        if (x % 2 == 0) return 2;
        else return 1;
    } else if (x < 0) {
        return -1;
    }
    return 0;
}

int main() {
    int scores[] = {95, 85, 75, 65, 55, 90, 60, 0, 100};
    for (int i = 0; i < 9; i++) printf("%d:%s ", scores[i], grade(scores[i]));
    printf("\n");
    printf("%d %d %d %d\n", classify(4), classify(7), classify(-3), classify(0));

    /* dangling else binds to the nearest if */
    int a = 1, b = 0;
    if (a)
        if (b) printf("both\n");
        else printf("a only\n");

    /* conditions on double, char, pointer */
    double d = 0.0;
    char c = '\0';
    int *p = 0;
    int v = 3;
    if (d) printf("d true\n"); else printf("d false\n");
    d = -0.25;
    if (d) printf("d true\n"); else printf("d false\n");
    if (!c) printf("c is NUL\n");
    if (!p) printf("p is null\n");
    p = &v;
    if (p && *p == 3) printf("p -> 3\n");

    /* leap years: compound conditions */
    int years[] = {1900, 2000, 2023, 2024};
    for (int i = 0; i < 4; i++) {
        int y = years[i];
        if ((y % 4 == 0 && y % 100 != 0) || y % 400 == 0) printf("%d leap\n", y);
        else printf("%d common\n", y);
    }

    /* largest of three */
    int x = 12, y = 45, z = 30, big;
    if (x >= y && x >= z) big = x;
    else if (y >= x && y >= z) big = y;
    else big = z;
    printf("max=%d\n", big);

    /* empty branches and blocks */
    if (x > 100) { } else { printf("empty then-branch ok\n"); }
    if (x) ;
    return 0;
}
