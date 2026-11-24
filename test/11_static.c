/* Feature: static keyword: static local variables keep their value between calls
   (including in recursion), static globals and static functions, static arrays. */
#include <stdio.h>

static int calls = 0;                    /* static global */
static int helper(int x) { return x * 2; } /* static function */

int counter() {
    static int n = 0;                    /* initialised once */
    n++;
    calls++;
    return n;
}

int other_counter() {
    static int n = 100;                  /* same name, different function */
    return n--;
}

int depth_tracker(int level) {
    static int max_depth = 0;
    if (level > max_depth) max_depth = level;
    if (level < 4) depth_tracker(level + 1);
    return max_depth;
}

int next_id() {
    static int ids[3] = {7, 8, 9};
    static int pos;                      /* zero-initialised */
    int v = ids[pos % 3];
    pos++;
    return v;
}

const char *name_of(int k) {
    static char buf[8];
    buf[0] = 'n';
    buf[1] = '0' + k;
    buf[2] = '\0';
    return buf;
}

int main() {
    for (int i = 0; i < 3; i++) printf("counter=%d ", counter());
    printf("\n");
    int o1 = other_counter(), o2 = other_counter(), o3 = other_counter();
    printf("%d %d %d\n", o1, o2, o3);
    printf("max depth=%d\n", depth_tracker(0));
    int i1 = next_id(), i2 = next_id(), i3 = next_id(), i4 = next_id();
    printf("ids: %d %d %d %d\n", i1, i2, i3, i4);
    printf("%s ", name_of(3));
    printf("%s\n", name_of(5));
    printf("calls=%d helper=%d\n", calls, helper(21));
    static double ratio = 0.5;
    ratio *= 3;
    printf("ratio=%.2f\n", ratio);
    return 0;
}
