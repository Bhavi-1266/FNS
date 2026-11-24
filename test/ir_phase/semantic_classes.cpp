/* Deliberate semantic errors: access control, static context, constructors,
   initialiser lists, inheritance. */
class Base {
private:
    int priv;
    void hidden() {}
    static int sp;
protected:
    int prot;
public:
    int pub;
    Base() : priv(0), prot(0), pub(0) {}
    int get() { return priv; }
    static int st() { return pub; }          /* expect: non-static member 'pub' used in a static method */
    static int st2() { return get(); }       /* expect: non-static method 'get' called from a static method */
};
class Derived : public Base {
public:
    int d;
    Derived() : d(0) {}
    int touch() { return priv; }             /* expect: member 'priv' is not accessible here */
    int touch2() { return prot; }            /* valid: protected through this */
    int touch3(Base &b) { return b.prot; }   /* expect: member 'prot' is not accessible here */
    void callhidden() { hidden(); }          /* expect: member 'hidden' is not accessible here */
    int qual() { return Base::get(); }       /* valid: qualified call inside a derived method */
};
class Unrelated {
public:
    int q;
    Unrelated() : q(0) {}
    int poke(Base &b) { return b.prot; }     /* expect: member 'prot' is not accessible here */
    int qual() { return Base::get(); }       /* expect: qualified non-static call requires a compatible this object */
};
class Bad : public Nope { public: int z; };  /* expect: unknown base class Nope */
class PrivCtor { PrivCtor() {} public: int v; };
class PrivDtor { ~PrivDtor() {} public: int v; };
class Holder { public: PrivDtor m; };        /* expect: member destructor of 'PrivDtor' is not accessible here */
class Child : public PrivDtor { public: int w; };  /* expect: base destructor of 'PrivDtor' is not accessible here */
class RefMem { public: int &r; RefMem() {} };     /* expect: reference member 'r' requires an initializer */
class RefMem2 { public: int &r; RefMem2() : r(5) {} };   /* expect: reference member must bind to an lvalue */
class RefMem3 { public: int &r; RefMem3(int a, int b) : r(a, b) {} };   /* expect: reference member initializer requires one lvalue */
class BadInit { public: int a; BadInit() : zz(1) {} };   /* expect: unknown member zz in initializer list */
class TooMany { public: int a; TooMany() : a(1, 2) {} }; /* expect: too many values in member initializer */
class NoBaseCtor { public: int a; };
class UsesBase : public NoBaseCtor { public: UsesBase() : NoBaseCtor(1) {} };  /* expect: base class has no constructor */
class Ctor2 { public: int a; Ctor2(int x) : a(x) {} };
int main() {
    Base b; Derived d;
    int e1 = b.priv;                 /* expect: member 'priv' is not accessible here */
    int e2 = b.prot;                 /* expect: member 'prot' is not accessible here */
    int e3 = d.prot;                 /* expect: member 'prot' is not accessible here */
    int e4 = d.priv;                 /* expect: member 'priv' is not accessible here */
    b.hidden();                      /* expect: member 'hidden' is not accessible here */
    int e5 = b.nosuch;               /* expect: no member 'nosuch' in Base */
    b.nomethod();                    /* expect: no member 'nomethod' in Base */
    int e6 = Base::sp;               /* expect: member 'sp' is not accessible here */
    int e7 = Base::get();            /* expect: qualified non-static call requires a compatible this object */
    PrivCtor pc;                     /* expect: constructor of 'PrivCtor' is not accessible here */
    PrivCtor *ppc = new PrivCtor();  /* expect: constructor of 'PrivCtor' is not accessible here */
    PrivDtor *pd = new PrivDtor(); delete pd;        /* expect: destructor of 'PrivDtor' is not accessible here */
    PrivDtor *pda = new PrivDtor[2]; delete[] pda;   /* expect: destructor of 'PrivDtor' is not accessible here */
    Ctor2 *pc2 = new Ctor2();        /* expect: function 'Ctor2' expects 1 argument(s), got 0 */
    Ctor2 c3 = Ctor2(1, 2);          /* expect: function 'Ctor2' expects 1 argument(s), got 2 */
    int e8 = b + d;                  /* expect: operator '+' requires arithmetic operands */
    int i = 1;
    i.f();                           /* expect: member access on non-aggregate 'f' */
    return 0;
}
