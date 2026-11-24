/* Feature: printf and scanf: every conversion, widths, precision, flags, return values,
   reading ints/chars/strings/floats/doubles, scanf return value at end of input. */
#include <stdio.h>

int main() {
    int n1, n2, count;
    char initial, word[32];
    float f;
    double d;

    count = scanf("%d %d", &n1, &n2);
    printf("read %d ints: %d %d sum=%d\n", count, n1, n2, n1 + n2);
    scanf(" %c", &initial);
    scanf("%s", word);
    printf("initial=%c word=%s\n", initial, word);
    scanf("%f %lf", &f, &d);
    printf("f=%.2f d=%.4f product=%.3f\n", f, d, f * d);

    int hex, oct;
    scanf("%x %o", &hex, &oct);
    printf("hex=%d oct=%d\n", hex, oct);

    /* read numbers until input ends */
    int x, total = 0, items = 0;
    while (scanf("%d", &x) == 1) { total += x; items++; }
    printf("%d more numbers, total=%d\n", items, total);
    printf("scanf at EOF returns %d\n", scanf("%d", &x));

    /* printf conversions and flags */
    printf("[%d] [%i] [%5d] [%-5d] [%05d] [%+d] [% d]\n", 42, 42, 42, 42, 42, 42, 42);
    printf("[%u] [%x] [%X] [%#x] [%o] [%#o]\n", 4294967295u, 255, 255, 255, 8, 8);
    printf("[%c] [%5c] [%-3c]\n", 'Q', 'Q', 'Q');
    printf("[%s] [%8s] [%-8s] [%.2s]\n", "text", "text", "text", "text");
    printf("[%f] [%.0f] [%.1f] [%10.3f] [%-10.2f] [%+.2f]\n", 3.14159, 2.5, 0.05, -1.5, 9.999, 1.0);
    printf("[%e] [%.2E] [%g] [%g] [%g]\n", 123456.789, 0.000123, 0.0001, 1e10, 100.0);
    printf("[%5.1f%%] [%d%%]\n", 99.5, 100);
    printf("[%*d] [%-*d] [%.*f]\n", 6, 7, 4, 8, 2, 3.14159);
    printf("[%hd] [%ld] [%lu] [%hhd]\n", (short)-3, 123456L, 99UL, (char)65);
    int len = printf("abc\n");
    printf("printf returned %d\n", len);

    /* sprintf / sscanf */
    char buf[64];
    int written = sprintf(buf, "%s-%03d-%.1f", "id", 7, 2.25);
    printf("%s (%d chars)\n", buf, written);
    int a, b; char tag[10];
    int got = sscanf("12 apples 30", "%d %s %d", &a, tag, &b);
    printf("sscanf got %d: %d %s %d\n", got, a, tag, b);
    return 0;
}
