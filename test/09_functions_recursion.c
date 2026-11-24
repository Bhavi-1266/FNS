/* Feature: functions with arguments (by value, arrays, pointers, many args, prototypes,
   void functions), recursion (factorial, fibonacci, gcd, power, hanoi, ackermann,
   permutations, binary search), mutual recursion. */
#include <stdio.h>

int factorial(int n);                  /* prototype before definition */
long power(long base, int e);
int is_even(int n);
int is_odd(int n);

int factorial(int n) { return n <= 1 ? 1 : n * factorial(n - 1); }
int fib(int n) { return n < 2 ? n : fib(n - 1) + fib(n - 2); }
int gcd(int a, int b) { return b == 0 ? a : gcd(b, a % b); }
long power(long base, int e) {
    if (e == 0) return 1;
    long half = power(base, e / 2);
    return e % 2 ? half * half * base : half * half;
}
int ackermann(int m, int n) {
    if (m == 0) return n + 1;
    if (n == 0) return ackermann(m - 1, 1);
    return ackermann(m - 1, ackermann(m, n - 1));
}
int is_even(int n) { return n == 0 ? 1 : is_odd(n - 1); }
int is_odd(int n) { return n == 0 ? 0 : is_even(n - 1); }

int moves = 0;
void hanoi(int n, char from, char to, char via) {
    if (n == 0) return;
    hanoi(n - 1, from, via, to);
    moves++;
    if (n == 3) printf("move disk 3 %c->%c\n", from, to);
    hanoi(n - 1, via, to, from);
}

void permute(char *s, int l, int r) {
    if (l == r) { printf("%s ", s); return; }
    for (int i = l; i <= r; i++) {
        char t = s[l]; s[l] = s[i]; s[i] = t;
        permute(s, l + 1, r);
        t = s[l]; s[l] = s[i]; s[i] = t;
    }
}

int rsearch(int *a, int lo, int hi, int key) {
    if (lo > hi) return -1;
    int mid = (lo + hi) / 2;
    if (a[mid] == key) return mid;
    return a[mid] < key ? rsearch(a, mid + 1, hi, key) : rsearch(a, lo, mid - 1, key);
}

int sum_digits(int n) { return n < 10 ? n : n % 10 + sum_digits(n / 10); }

double average(int a, int b, int c, int d, int e, int f, int g, int h) {
    return (a + b + c + d + e + f + g + h) / 8.0;
}

void fill(int *out, int n, int value) { for (int i = 0; i < n; i++) out[i] = value + i; }

double scale(double x, float k, char sign) { return sign == '-' ? -x * k : x * k; }

int main() {
    printf("10! = %d, 12! = %d\n", factorial(10), factorial(12));
    for (int i = 0; i <= 15; i += 3) printf("fib(%d)=%d ", i, fib(i));
    printf("\n");
    printf("gcd(84,36)=%d gcd(17,5)=%d\n", gcd(84, 36), gcd(17, 5));
    printf("2^10=%ld 3^13=%ld\n", power(2, 10), power(3, 13));
    printf("ackermann(2,3)=%d\n", ackermann(2, 3));
    printf("even(10)=%d odd(7)=%d\n", is_even(10), is_odd(7));
    hanoi(4, 'A', 'C', 'B');
    printf("hanoi(4) moves=%d\n", moves);
    char letters[] = "abc";
    permute(letters, 0, 2);
    printf("\n");
    int sorted[] = {2, 5, 8, 12, 16, 23, 38, 56, 72, 91};
    printf("found 23 at %d, 4 at %d\n", rsearch(sorted, 0, 9, 23), rsearch(sorted, 0, 9, 4));
    printf("digit sum 98765=%d\n", sum_digits(98765));
    printf("avg=%.3f\n", average(1, 2, 3, 4, 5, 6, 7, 9));
    int buf[4];
    fill(buf, 4, 100);
    printf("%d %d\n", buf[0], buf[3]);
    printf("%.2f %.2f\n", scale(2.0, 1.5f, '+'), scale(2.0, 1.5f, '-'));
    return 0;
}
