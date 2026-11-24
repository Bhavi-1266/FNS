/* Valid: lambda capture modes, immediate invocation, lambda as argument and
   function pointer, reference params/returns/members, const-ref temporaries,
   enums with expressions, typedefs, new/delete for scalars, arrays, pointer arrays. */
int apply(int (*f)(int), int v) { return f(v); }
void swap(int &a, int &b) { int t = a; a = b; b = t; }
int &pick(int &a, int &b, int which) { if (which) return a; return b; }
const int &cref(const int &x) { return x; }
int g = 5;
int gi = g * 2;
struct R { int &r; int v; R(int &x) : r(x), v(0) {} int get() { return r; } };
enum Day { MON, TUE = 3, WED, THU = WED + 10 };
typedef enum Day Day_t;
typedef int Arr3[3];
typedef int *IntPtr;
int main() {
    int x = 1, y = 2;
    auto f = [](int a) -> int { return a * 2; };
    auto g2 = [=](int a) { return a + x + y; };
    auto h = [&](int a) { x = a; return x; };
    auto k = [x, &y](int a) { y = x + a; return y; };
    auto noret = [](int a) { return a; };
    auto glob = [](int a) { return a + g; };
    auto imm = [](int a) -> int { return a; }(5);
    int r = f(1) + g2(1) + h(3) + k(4) + noret(1) + glob(1) + imm + apply(f, 2) + apply([](int v) -> int { return v - 1; }, 3);
    x = 10; r += g2(0);          /* copy captured earlier */
    int (*fp)(int) = f; r += fp(2);
    swap(x, y); int &rx = x; rx++; int &rr = rx; rr += 2;
    pick(x, y, 1) = 99; int z = pick(x, y, 0); int cz = cref(3) + cref(z);
    const int &cr2 = x + y;
    R robj = R(x); robj.r = 5; r += robj.get() + robj.v;
    R *rp = &robj; rp->r++;
    Day d = THU; Day_t d2 = WED; enum Day d3 = MON; int dv = d + d2 + d3 + TUE;
    d = TUE; int cmp = d == TUE; dv += (int) d;
    Arr3 a3; a3[1] = 2; IntPtr ip = &a3[0]; *ip = 1;
    int *dp = new int; int *dp2 = new int(5); int *dp3 = new int(); int *da = new int[x + 1]; da[1] = *dp2 + *dp3;
    double *dd = new double[2]; dd[1] = 1.0; delete[] dd; delete dp; delete dp2; delete dp3; delete[] da;
    char **tbl = new char*[3]; tbl[0] = new char[4]; tbl[0][0] = 'a'; delete[] tbl[0]; delete[] tbl;
    int ***t3 = new int**; *t3 = &ip; **t3 = &a3[2]; ***t3 = 3; delete t3;
    return r + z + cz + cr2 + dv + cmp + gi + a3[1];
}
