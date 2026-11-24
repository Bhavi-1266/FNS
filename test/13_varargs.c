/* Feature: functions with a variable number of arguments (stdarg.h): ints, doubles,
   strings, a sentinel-terminated list, a printf-like function, forwarding with vprintf. */
#include <stdio.h>
#include <stdarg.h>

int sum(int count, ...) {
    va_list ap;
    va_start(ap, count);
    int total = 0;
    for (int i = 0; i < count; i++) total += va_arg(ap, int);
    va_end(ap);
    return total;
}

double average(int count, ...) {
    va_list ap;
    double total = 0;
    va_start(ap, count);
    for (int i = 0; i < count; i++) total += va_arg(ap, double);
    va_end(ap);
    return count ? total / count : 0;
}

int max_of(int first, ...) {           /* list terminated by -1 */
    va_list ap;
    int best = first, v;
    va_start(ap, first);
    while ((v = va_arg(ap, int)) != -1) if (v > best) best = v;
    va_end(ap);
    return best;
}

void join(const char *sep, int n, ...) {
    va_list ap;
    va_start(ap, n);
    for (int i = 0; i < n; i++) {
        if (i) printf("%s", sep);
        printf("%s", va_arg(ap, char *));
    }
    va_end(ap);
    printf("\n");
}

void mini_printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    for (const char *p = fmt; *p; p++) {
        if (*p != '%') { putchar(*p); continue; }
        p++;
        if (*p == 'd') printf("%d", va_arg(ap, int));
        else if (*p == 'c') putchar(va_arg(ap, int));
        else if (*p == 's') printf("%s", va_arg(ap, const char *));
        else if (*p == 'f') printf("%.3f", va_arg(ap, double));
        else putchar(*p);
    }
    va_end(ap);
}

void log_msg(const char *level, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    printf("[%s] ", level);
    vprintf(fmt, ap);
    va_end(ap);
}

int main() {
    printf("%d %d %d\n", sum(0), sum(3, 1, 2, 3), sum(6, 10, 20, 30, 40, 50, 60));
    printf("%.3f %.3f\n", average(2, 1.5, 2.5), average(4, 1.0, 2.0, 3.0, 4.5));
    printf("%d\n", max_of(3, 17, 5, 22, 9, -1));
    join(", ", 3, "red", "green", "blue");
    join("-", 1, "solo");
    mini_printf("int %d, char %c, str %s, dbl %f, pct %%\n", -45, 'k', "abc", 2.5);
    float small = 1.25f;                  /* float is promoted to double */
    mini_printf("float %f char-promoted %d\n", small, (char)'A');
    log_msg("INFO", "%d items, %s\n", 4, "ok");
    return 0;
}
