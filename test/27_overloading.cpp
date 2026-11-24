// Feature: function overloading and overloaded constructors / methods, resolved by the
// number and types of the arguments.
#include <cstdio>

int area(int side) { return side * side; }
int area(int w, int h) { return w * h; }
double area(double r) { return 3.0 * r * r; }

void print(int v) { printf("int %d\n", v); }
void print(double v) { printf("double %.2f\n", v); }
void print(const char *s) { printf("string %s\n", s); }
void print(char c) { printf("char %c\n", c); }

class Vec {
    int x, y;
public:
    Vec() : x(0), y(0) {}
    Vec(int v) : x(v), y(v) {}
    Vec(int a, int b) : x(a), y(b) {}
    void set(int v) { x = y = v; }
    void set(int a, int b) { x = a; y = b; }
    int dot(const Vec &o) const { return x * o.x + y * o.y; }
    int dot(int k) const { return (x + y) * k; }
    void show() const { printf("(%d,%d)\n", x, y); }
};

int main() {
    printf("%d %d %.1f\n", area(4), area(3, 5), area(2.0));
    print(7);
    print(2.5);
    print("text");
    print('z');
    Vec a, b(3), c(1, 2);
    a.show(); b.show(); c.show();
    a.set(4);
    a.show();
    a.set(5, 6);
    a.show();
    printf("dot=%d scaled=%d\n", a.dot(c), c.dot(10));
    return 0;
}
