// Feature: lambda functions: no capture, capture by value, by reference, [=], [&],
// mixed captures, explicit return types, immediate invocation, lambdas as callbacks.
#include <cstdio>

int apply(int (*f)(int), int v) { return f(v); }
void repeat(int n, void (*f)(int)) { for (int i = 0; i < n; i++) f(i); }

int main() {
    auto square = [](int x) { return x * x; };
    auto add = [](int a, int b) -> int { return a + b; };
    auto halve = [](double d) -> double { return d / 2; };
    printf("%d %d %.2f\n", square(9), add(4, 5), halve(7.0));

    int base = 10, counter = 0;
    auto add_base = [base](int x) { return x + base; };       // copy taken now
    base = 1000;
    printf("by value: %d (base is now %d)\n", add_base(5), base);

    auto bump = [&counter]() { counter++; };
    bump(); bump(); bump();
    printf("by reference: counter=%d\n", counter);

    int a = 3, b = 4;
    auto all_val = [=]() { return a * b; };
    auto all_ref = [&]() { a += 10; b += 10; };
    all_ref();
    printf("[=] saw %d, after [&]: a=%d b=%d\n", all_val(), a, b);

    int scale = 2, total = 0;
    auto mixed = [scale, &total](int v) { total += v * scale; };
    mixed(5); mixed(7);
    printf("mixed: total=%d\n", total);

    int r = [](int x, int y) { return x - y; }(20, 8);        // immediately invoked
    printf("immediate: %d\n", r);

    printf("callback: %d\n", apply(square, 12));
    repeat(3, [](int i) { printf("tick %d ", i); });
    printf("\n");

    auto is_even = [](int n) -> bool { return n % 2 == 0; };
    int evens = 0;
    for (int i = 0; i < 10; i++) if (is_even(i)) evens++;
    printf("evens=%d\n", evens);

    auto max3 = [](int x, int y, int z) {
        int m = x;
        if (y > m) m = y;
        if (z > m) m = z;
        return m;
    };
    printf("max3=%d\n", max3(4, 19, 7));

    // return types deduced from the body when `->` is omitted
    auto half = [](double d) { return d / 2; };
    auto initial = [](const char *s) { return s[0]; };
    auto next = [](int *p) { return p + 1; };
    auto shout = [](const char *s) { printf("%s!\n", s); };   // no return: void
    int pair[2] = {5, 9};
    printf("deduced: %.2f %c %d\n", half(5.0), initial("xyz"), *next(pair));
    shout("done");
    return 0;
}
