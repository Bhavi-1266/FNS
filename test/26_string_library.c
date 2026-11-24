/* Feature: string.h / ctype.h / stdlib.h functions provided by the FNS runtime. */
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int main() {
    char a[64] = "Hello";
    char b[64];
    strcpy(b, a);
    strcat(a, ", World");
    printf("%s | %s | len=%d\n", a, b, (int)strlen(a));
    printf("cmp: %d %d %d\n", strcmp("abc", "abc") == 0, strcmp("abc", "abd") < 0, strcmp("b", "a") > 0);
    printf("ncmp: %d\n", strncmp("compiler", "compute", 4));
    strncpy(b, "truncate-me", 8);
    b[8] = '\0';
    printf("strncpy: %s\n", b);
    strncat(b, "XYZW", 2);
    printf("strncat: %s\n", b);
    printf("strchr: %s, strrchr: %s\n", strchr(a, 'o'), strrchr(a, 'o'));
    printf("strstr: %s, missing: %s\n", strstr(a, "World"), strstr(a, "xyz") ? "found" : "null");
    char *dup = strdup("duplicate");
    dup[0] = 'D';
    printf("%s\n", dup);
    free(dup);

    char text[] = "one,two;;three four";
    char *tok = strtok(text, ",; ");
    while (tok) { printf("[%s]", tok); tok = strtok(NULL, ",; "); }
    printf("\n");

    char mixed[] = "MiXeD 123 text!";
    for (int i = 0; mixed[i]; i++) mixed[i] = isupper(mixed[i]) ? tolower(mixed[i]) : toupper(mixed[i]);
    printf("%s\n", mixed);
    int al = 0, dg = 0, sp = 0, pu = 0;
    for (char *p = "a1 b2, c3!"; *p; p++) {
        if (isalpha(*p)) al++;
        if (isdigit(*p)) dg++;
        if (isspace(*p)) sp++;
        if (ispunct(*p)) pu++;
    }
    printf("alpha=%d digit=%d space=%d punct=%d\n", al, dg, sp, pu);

    printf("atoi=%d atol=%ld atof=%.3f\n", atoi("  -321xyz"), atol("123456"), atof("2.5e2"));
    char *end;
    long hexval = strtol("0x1F rest", &end, 16);
    printf("strtol hex=%ld rest=%s\n", hexval, end);
    printf("abs=%d %d\n", abs(-17), abs(17));

    int nums[5] = {1, 2, 3, 4, 5};
    int copy[5];
    memcpy(copy, nums, sizeof(nums));
    memset(nums, 0, sizeof(nums));
    printf("memcpy: %d %d, memset: %d, memcmp: %d\n", copy[0], copy[4], nums[2], memcmp(copy, nums, 20) > 0);
    memmove(copy + 1, copy, 3 * sizeof(int));
    printf("memmove: %d %d %d %d %d\n", copy[0], copy[1], copy[2], copy[3], copy[4]);

    srand(42);
    int r1 = rand(), r2 = rand();
    srand(42);
    printf("rand repeatable after srand: %d\n", r1 == rand() && r2 == rand());
    return 0;
}
