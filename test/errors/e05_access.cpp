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

int main() {
    Account a;
    a.balance = 100;                   // private member
    a.audit();                         // private method
    printf("%d\n", a.id);              // protected member from outside
    Savings s;
    printf("%d\n", s.ident());
    return 0;
}
