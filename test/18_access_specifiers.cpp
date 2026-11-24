// Feature: public, private and protected members; struct defaults to public, class to
// private; protected members are visible in derived classes; private data reached only
// through public methods.  (Violations are compile errors: see test/errors/.)
#include <cstdio>

class Person {
private:
    int age;
    int secret_code() const { return age * 7; }
protected:
    const char *name;
    void set_age(int a) { if (a >= 0) age = a; }
public:
    Person(const char *n, int a) : age(a), name(n) {}
    int get_age() const { return age; }
    int code() const { return secret_code(); }
    void birthday() { age++; }
};

class Employee : public Person {
    int salary;                   // private by default in a class
public:
    Employee(const char *n, int a, int s) : Person(n, a), salary(s) {}
    void print() const { printf("%s (%d) earns %d\n", name, get_age(), salary); }   // protected name
    void correct_age(int a) { set_age(a); }                                       // protected method
    void raise(int pct) { salary += salary * pct / 100; }
};

struct Pair {                     // members of a struct are public by default
    int first, second;
    int sum() { return first + second; }
private:
    int hidden = 42;
public:
    int peek() { return hidden; }
};

// private and protected inheritance: the base's public members become private /
// protected in the derived class, so only the derived class (and, for protected,
// its own derived classes) can use them.
class Counter {
public:
    int n = 0;
    void bump() { n++; }
};
class Hidden : private Counter {
public:
    int twice() { bump(); bump(); return n; }
};
class Shared : protected Counter {
public:
    int once() { bump(); return n; }
};
class Shared2 : public Shared {
public:
    int thrice() { bump(); bump(); return once(); }
};

int main() {
    Hidden hd;
    Shared2 s2;
    printf("private base: %d  protected base: %d\n", hd.twice(), s2.thrice());
    Person p("Riya", 30);
    p.birthday();
    printf("age=%d code=%d\n", p.get_age(), p.code());
    Employee e("Kabir", 41, 50000);
    e.print();
    e.correct_age(40);
    e.raise(10);
    e.print();
    e.correct_age(-5);            // rejected by the setter
    e.print();
    Pair pr;
    pr.first = 3;
    pr.second = 4;
    printf("pair sum=%d hidden=%d\n", pr.sum(), pr.peek());
    return 0;
}
