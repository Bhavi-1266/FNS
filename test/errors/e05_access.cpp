// Must fail: access-control violations (private / protected members).
#include <cstdio>

class Account {
private:
    int balance;
    void audit() {}
protected:
    int id;
public:
    Account() : balance(0), id(1) {}
    int get() { return balance; }
};

class Savings : public Account {
public:
    int peek() { return balance; }     // private member of the base class
    int ident() { return id; }         // protected: fine inside a derived class
};

class Locked : private Account {
public:
    int ok() { return get(); }         // fine: inside the derived class
};
class Deeper : public Locked {
public:
    int bad() { return get(); }        // get() is private in Locked
};

class Plain : Account {};            // a class base is private by default

int main() {
    Plain pl;
    pl.get();                          // get() is private in Plain
    Locked l;
    l.get();                           // public in Account, private through the private base
    Account *ap = &l;                  // inaccessible base
    Account a;
    a.balance = 100;                   // private member
    a.audit();                         // private method
    printf("%d\n", a.id);              // protected member from outside
    Savings s;
    printf("%d\n", s.ident());
    return 0;
}
