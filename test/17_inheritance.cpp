// Feature: inheritance (single and multi-level), virtual functions and runtime
// polymorphism through base pointers and references, pure virtual (abstract) classes,
// overriding with calls to Base::method(), constructor/destructor order, virtual dtors,
// struct bases (public by default) and class bases (private by default).
#include <cstdio>

class Shape {
protected:
    const char *name;
public:
    Shape(const char *n) : name(n) { printf("Shape(%s) ", name); }
    virtual ~Shape() { printf("~Shape(%s) ", name); }
    virtual double area() const = 0;
    virtual void describe() const { printf("%s with area %.2f\n", name, area()); }
    const char *get_name() const { return name; }
};

class Circle : public Shape {
    double r;
public:
    Circle(double radius) : Shape("circle"), r(radius) { printf("Circle "); }
    ~Circle() { printf("~Circle "); }
    double area() const { return 3.14 * r * r; }
};

class Rect : public Shape {
protected:
    double w, h;
public:
    Rect(double a, double b) : Shape("rect"), w(a), h(b) { printf("Rect "); }
    Rect(const char *n, double a, double b) : Shape(n), w(a), h(b) { printf("Rect "); }
    double area() const { return w * h; }
};

class Square : public Rect {
public:
    Square(double s) : Rect("square", s, s) { printf("Square "); }
    void describe() const {
        printf("[square side %.1f] ", w);
        Rect::describe();                     // call the overridden base version
    }
};

class Animal {
public:
    virtual const char *sound() { return "..."; }
    const char *kind() { return "animal"; }   // not virtual
    void speak() { printf("%s says %s\n", kind(), sound()); }
};
class Dog : public Animal {
public:
    const char *sound() { return "woof"; }
    const char *kind() { return "dog"; }
};
class Puppy : public Dog {
public:
    const char *sound() { return "yip"; }
};

double total_area(Shape **shapes, int n) {
    double t = 0;
    for (int i = 0; i < n; i++) t += shapes[i]->area();
    return t;
}

void show_ref(Shape &s) { s.describe(); }

// struct bases are public by default, class bases private by default
struct Point2 { int x = 1, y = 2; int sum() const { return x + y; } };
struct Point3 : Point2 { int z = 3; int sum3() const { return sum() + z; } };
class Hidden2 : Point2 { public: int total() const { return sum() * 10; } };

int main() {
    Shape *shapes[3];
    shapes[0] = new Circle(1.0);
    printf("\n");
    shapes[1] = new Rect(2.0, 3.0);
    printf("\n");
    shapes[2] = new Square(2.5);
    printf("\n");
    for (int i = 0; i < 3; i++) shapes[i]->describe();
    printf("total area %.2f\n", total_area(shapes, 3));
    Square sq(1.5);
    printf("\n");
    show_ref(sq);
    for (int i = 0; i < 3; i++) { delete shapes[i]; printf("\n"); }

    Animal a; Dog d; Puppy p;
    Animal *zoo[3] = {&a, &d, &p};
    for (int i = 0; i < 3; i++) zoo[i]->speak();
    printf("%s %s\n", d.kind(), d.sound());
    Animal &ref = p;
    printf("through reference: %s\n", ref.sound());
    Point3 p3;
    Hidden2 h2;
    printf("struct base: %d %d %d, class base: %d\n", p3.x, p3.sum(), p3.sum3(), h2.total());
    return 0;
}
