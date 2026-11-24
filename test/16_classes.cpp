// Feature: classes and objects: data members, member functions, constructors (default,
// parameterised, overloaded, initializer lists), destructors run at end of scope,
// this->, const methods, static members, objects in arrays, new/delete, out-of-class
// definitions, direct (T x(a)) and list (T x{a}) initialisation, delegating constructors,
// nested classes and enums (Outer::Inner, Outer::VALUE).
#include <cstdio>

class Counter {
    int value;
    static int instances;
public:
    Counter() : value(0) { instances++; }
    Counter(int start) : value(start) { instances++; }
    void increment() { value++; }
    void add(int n) { this->value += n; }
    int get() const { return value; }
    static int count() { return instances; }
};
int Counter::instances = 0;

class Rectangle {
private:
    double width, height;
public:
    Rectangle();
    Rectangle(double w, double h);
    double area() const;
    double perimeter() const { return 2 * (width + height); }
    void scale(double f) { width *= f; height *= f; }
    bool is_square() const { return width == height; }
};
Rectangle::Rectangle() : width(1), height(1) {}
Rectangle::Rectangle(double w, double h) : width(w), height(h) {}
double Rectangle::area() const { return width * height; }

class Tracer {
    int id;
public:
    Tracer(int i) : id(i) { printf("  construct %d\n", id); }
    ~Tracer() { printf("  destruct %d\n", id); }
};

class BankAccount {
    int balance;
    int history[8];
    int n;
public:
    BankAccount(int initial) { balance = initial; n = 0; }
    bool withdraw(int amt) {
        if (amt > balance) return false;
        balance -= amt; history[n++] = -amt; return true;
    }
    void deposit(int amt) { balance += amt; history[n++] = amt; }
    int get_balance() const { return balance; }
    void print_history() const {
        for (int i = 0; i < n; i++) printf("%+d ", history[i]);
        printf("\n");
    }
};

class Box {                       // delegating constructors: Box() -> Box(int) -> Box(int, int)
    int w, h;
public:
    Box(int a, int b) : w(a), h(b) { printf("  Box(%d, %d)\n", a, b); }
    Box(int s) : Box(s, s) { printf("  square %d\n", s); }
    Box() : Box(1) { printf("  default box\n"); }
    int area() const { return w * h; }
};

class Stack {                     // nested types: a private node struct, a public iterator and enum
    struct Node { int val; Node *next; Node(int v, Node *n) : val(v), next(n) {} };
    Node *top;
public:
    enum Kind { EMPTY, NON_EMPTY };
    class Walker {
        Node *cur;
    public:
        Walker(Node *n) : cur(n) {}
        bool more() const { return cur != nullptr; }
        int next() { int v = cur->val; cur = cur->next; return v; }
    };
    Stack() : top(nullptr) {}
    ~Stack() { while (top) { Node *n = top->next; delete top; top = n; } }
    void push(int v) { top = new Node(v, top); }
    Walker walk() const { return Walker(top); }
    Kind kind() const { return top ? NON_EMPTY : EMPTY; }
};

int main() {
    Stack st;
    printf("stack kind %d\n", st.kind() == Stack::EMPTY);
    for (int i = 1; i <= 3; i++) st.push(i * 10);
    for (Stack::Walker w = st.walk(); w.more();) printf("walk %d\n", w.next());
    Box b0;
    Box b3(3);
    printf("box areas %d %d\n", b0.area(), b3.area());
    Counter c1;
    Counter c2(10);
    Counter c3 = Counter(100);
    Counter c4{7};
    c1.increment(); c1.increment();
    c2.add(5);
    printf("%d %d %d %d instances=%d\n", c1.get(), c2.get(), c3.get(), c4.get(), Counter::count());

    Rectangle r1;
    Rectangle r2(3.0, 4.5);
    printf("r1 area=%.2f square=%d\n", r1.area(), r1.is_square());
    printf("r2 area=%.2f perimeter=%.2f\n", r2.area(), r2.perimeter());
    r2.scale(2);
    printf("scaled area=%.2f\n", r2.area());

    Rectangle *heap = new Rectangle(2.0, 2.0);
    printf("heap square=%d area=%.1f\n", heap->is_square(), heap->area());
    delete heap;

    Counter many[3];
    for (int i = 0; i < 3; i++) many[i].add(i * 2);
    printf("array: %d %d %d\n", many[0].get(), many[1].get(), many[2].get());

    Counter *arr = new Counter[2];
    arr[1].increment();
    printf("new[]: %d %d instances=%d\n", arr[0].get(), arr[1].get(), Counter::count());
    delete[] arr;

    BankAccount acct(100);
    acct.deposit(50);
    printf("withdraw 500: %d, withdraw 30: %d\n", acct.withdraw(500), acct.withdraw(30));
    printf("balance=%d history: ", acct.get_balance());
    acct.print_history();

    printf("scopes:\n");
    Tracer outer(1);
    {
        Tracer a(2);
        Tracer b(3);
        printf("  leaving inner block\n");
    }
    for (int i = 0; i < 2; i++) {
        Tracer loop(10 + i);
        if (i == 1) break;
    }
    printf("  end of main\n");
    return 0;
}
