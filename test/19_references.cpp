// Feature: references: reference variables (aliases), pass by reference, const
// references, returning a reference, references to struct/class objects and pointers,
// rvalue references T&& (binding temporaries, overloads on & / &&, std::move, move constructor).
#include <cstdio>
#include <utility>

void swap(int &a, int &b) { int t = a; a = b; b = t; }
void triple(double &d) { d *= 3; }
int &element(int *arr, int i) { return arr[i]; }
int sum_const(const int &a, const int &b) { return a + b; }

struct Account { int balance; };
void deposit(Account &acc, int amt) { acc.balance += amt; }

class Box {
    int v;
public:
    Box(int x) : v(x) {}
    int &value() { return v; }
    void copy_from(const Box &other) { v = other.v; }
};

void reset_ptr(int *&p) { p = nullptr; }

const char *category(int &) { return "lvalue"; }
const char *category(int &&) { return "rvalue"; }
int bump(int &&x) { x += 100; return x; }          // a temporary bound to T&& can be changed

class Holder {
    int *res;
public:
    Holder(int v) : res(new int(v)) { printf("acquire %d\n", v); }
    Holder(const Holder &o) : res(new int(*o.res)) { printf("copy %d\n", *res); }
    Holder(Holder &&o) : res(o.res) { o.res = nullptr; printf("move %d\n", *res); }
    ~Holder() { if (res) { printf("release %d\n", *res); delete res; } else printf("release (empty)\n"); }
    bool empty() const { return res == nullptr; }
};

int main() {
    int x = 10, y = 20;
    int &rx = x;
    rx = 15;
    printf("x=%d rx=%d\n", x, rx);
    rx++;
    printf("x=%d\n", x);
    swap(x, y);
    printf("after swap x=%d y=%d\n", x, y);

    double d = 1.5;
    triple(d);
    printf("d=%.1f\n", d);

    int arr[3] = {1, 2, 3};
    element(arr, 1) = 99;          // assign through a returned reference
    printf("arr[1]=%d\n", arr[1]);
    element(arr, 2) += 5;
    printf("arr[2]=%d\n", arr[2]);

    printf("const ref sum=%d %d\n", sum_const(x, y), sum_const(4, 5));

    Account acc = {100};
    deposit(acc, 25);
    Account &alias = acc;
    alias.balance -= 5;
    printf("balance=%d\n", acc.balance);

    Box b(7), c(0);
    b.value() = 70;
    c.copy_from(b);
    printf("box b=%d c=%d\n", b.value(), c.value());

    int *p = &x;
    reset_ptr(p);
    printf("p is %s\n", p == nullptr ? "null" : "set");

    int &ref_to_elem = arr[0];
    ref_to_elem = -1;
    printf("arr[0]=%d\n", arr[0]);
    int &&temp = 7 * 6;                                // extends the temporary's life
    temp++;
    int n = 1;
    const char *c1 = category(n), *c2 = category(n + 1), *c3 = category(std::move(n));
    printf("rvalue refs: %d %d %s %s %s\n", temp, bump(5), c1, c2, c3);
    Holder h1(9);
    Holder h2 = h1;                                    // copy constructor
    Holder h3 = std::move(h1);                         // move constructor: h1 is left empty
    printf("h1 empty: %d, h3 empty: %d\n", h1.empty(), h3.empty());
    return 0;
}
