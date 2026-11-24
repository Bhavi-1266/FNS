// Feature: C++ object lifetime: copy constructor (copy-initialisation, pass by
// value), default arguments, global objects with constructor arguments,
// construction/destruction order of globals, static locals, temporaries.
// Static locals are initialised when control first reaches them (also from a
// run-time value) and destroyed in reverse order of construction, also by exit().
// A goto out of blocks destroys the objects of the blocks it leaves.
#include <cstdio>
#include <cstdlib>

class T {
public:
    int id;
    T(int i = 0) : id(i) { printf("T(%d)\n", id); }
    T(const T &o) : id(o.id + 100) { printf("copy -> %d\n", id); }
    ~T() { printf("~T(%d)\n", id); }
};

T global_obj(7);                       // constructed before main, destroyed after it

int show(T t) { printf("show %d\n", t.id); return t.id; }

T &instance() {
    static T only(42);                 // constructed on the first call only
    return only;
}

void first_use(int n) {
    static T made(n);                  // run-time argument: built on the first call
    static int calls = n * 10;         // run-time initialiser, evaluated once
    calls++;
    printf("first_use(%d): made %d, calls %d\n", n, made.id, calls);
}

int search(int target) {
    T outer(1);
    for (int i = 0; i < 2; i++) {
        T row(10 + i);
        for (int j = 0; j < 2; j++) {
            T cell(100 + i * 2 + j);
            if (i * 2 + j == target) goto found;   // leaves cell, row (and the loops)
        }
    }
    return -1;
found:
    printf("found %d\n", target);
    return target;
}

void pair_of_two() {
    static T two[2];                   // static array of objects, built on first use
    two[1].id = 55;
}

class Counter {
    int c, step;
public:
    Counter(int start = 10, int s = 1) : c(start), step(s) {}
    void tick(int times = 1) { c += step * times; }
    int get() const { return c; }
};

double area(double w, double h = 2.0) { return w * h; }

class Val {
    int v;
public:
    Val(int x) : v(x) { printf("Val(%d)\n", v); }
    ~Val() { printf("~Val(%d)\n", v); }
    int get() const { return v; }
    Val plus(int d) const { return Val(v + d); }
};
int peek(const Val &o) { return o.get(); }
int &larger(int &a, int &b) { return a > b ? a : b; }

int main() {
    printf("main starts, global id=%d\n", global_obj.id);
    T a(1);
    T b = a;                           // copy constructor
    show(a);                           // copy made for the parameter, destroyed after the call
    printf("returned %d\n", show(b));
    {
        T c(b);
        printf("inner block\n");
    }
    printf("first: %d\n", instance().id);
    printf("second: %d\n", instance().id);
    Counter x, y(5), z(0, 3);
    x.tick(); y.tick(4); z.tick(2);
    printf("%d %d %d %.1f %.1f\n", x.get(), y.get(), z.get(), area(3), area(3, 4));
    T d;                               // default argument used by the constructor
    printf("peek %d\n", peek(Val(5)));   // temporary destroyed at the end of the statement
    Val v1(1);
    Val v3 = v1.plus(1).plus(2);       // intermediate temporary destroyed, result kept
    printf("v3=%d\n", v3.get());
    int p = 3, q = 8;
    larger(p, q) = 0;                  // ?: of two lvalues returned by reference
    printf("p=%d q=%d\n", p, q);
    search(2);
    first_use(8);
    first_use(9);
    pair_of_two();
    printf("main ends\n");
    exit(0);                           // exit() also destroys static and global objects
}
