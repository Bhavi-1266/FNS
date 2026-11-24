/* Valid: three-level inheritance, protected/private access from inside the
   hierarchy, static members and methods, qualified base calls, object members,
   new/delete of objects and object arrays, references to objects, aggregate copies. */
class Base {
protected:
    int prot;
private:
    int priv;
public:
    int pub;
    static int count;
    Base() : prot(1), priv(2), pub(3) { count++; }
    virtual int get() { return prot + priv; }
    virtual void set(int v) { prot = v; }
    int direct() { return priv; }
    static int total() { return count; }
    int compare(int o) { return o == priv; }
    ~Base() { pub = 0; }
};
class Mid : public Base {
public:
    int midv;
    Mid() : midv(5) {}
    int get() override { return prot + midv; }          /* protected via this: OK */
    int callbase() { return Base::get() + Base::direct(); }
    static int smid() { return Base::total(); }
};
class Leaf : public Mid {
public:
    Leaf() : midv2(0) {}
    int midv2;
    void set(int v) override { midv = v; midv2 = prot; }
};
class Holder { public: Mid m; Leaf l; int tail; Holder() : tail(1) {} };
struct Pt { int x, y; Pt(int a, int b) : x(a), y(b) {} int sum() { return x + y; } };
class Noctor { public: int a; int b; int f() { return a; } };
int use(Base *b) { return b->get(); }
int useref(Base &b) { b.set(9); return b.get(); }
int main() {
    Base b; Mid m; Leaf l; Leaf l2 = Leaf(); Pt p = Pt(1, 2); Noctor nc; nc.a = 1;
    Base *pb = &l; Base *pm = &m; Mid *pl = &l;
    int r = b.get() + m.get() + pb->get() + pm->get() + pl->get() + l.get();
    pb->set(3); l.set(4); m.set(2); pl->set(7);
    r += b.direct() + m.direct() + l.pub + m.pub + l.midv + Base::total() + Mid::smid() + b.total() + Base::count + b.count;
    r += b.compare(1) + m.callbase() + use(&l) + useref(l) + p.sum() + nc.f() + nc.b;
    Holder h; h.m.midv = 1; h.l.midv2 = h.m.get(); h.l.set(1);
    Leaf *dyn = new Leaf(); r += dyn->get(); delete dyn;
    Base *arr = new Mid[3]; Mid *marr = new Mid[2]; marr[1].midv = 3; delete[] marr;
    Pt *pp = new Pt(3, 4); r += pp->sum(); delete pp;
    Base &rb = l; r += rb.get(); Mid &rm = l; rm.midv = 2; Leaf &rl = l; rl.midv2 = 1;
    Pt q = p; q = p; Base bb = b;
    Holder *ph = &h; ph->l.midv2 = 0;
    return r + sizeof(Base) + sizeof(Mid) + sizeof(Leaf) + sizeof(Holder) + sizeof(Pt) + sizeof(Noctor) + sizeof(b);
}
