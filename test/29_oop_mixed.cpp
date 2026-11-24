/* Feature: object-oriented features: classes, constructors, methods,
 * single inheritance, virtual methods with dynamic dispatch, and
 * dynamic allocation with new/delete.                                      */
#include <cstdio>
#include <cstdlib>


class Shape {
public:
    virtual int area() { return 0; }
    virtual int perimeter() { return 0; }
};

class Rectangle : public Shape {
    int w, h;
public:
    Rectangle(int width, int height) { w = width; h = height; }
    virtual int area() { return w * h; }
    virtual int perimeter() { return 2 * (w + h); }
};

class Square : public Rectangle {
public:
    Square(int side) : Rectangle(side, side) {}
    /* inherits area() and perimeter() from Rectangle */
};

/* works on any Shape through the base pointer -> dynamic dispatch */
int describe(Shape *s) { return s->area() + s->perimeter(); }

/* a small stack built on a dynamic array */
class Stack {
    int *data;
    int top;
public:
    Stack(int cap) { data = new int[cap]; top = 0; }
    void push(int v) { data[top] = v; top = top + 1; }
    int pop() { top = top - 1; return data[top]; }
    int size() { return top; }
};

int main() {
    Rectangle r = Rectangle(3, 4);
    Square sq = Square(5);

    printf("rect area=%d perim=%d\n", r.area(), r.perimeter());   /* 12 14 */
    printf("square area=%d perim=%d\n", sq.area(), sq.perimeter()); /* 25 20 */

    /* virtual dispatch through base-class pointers */
    Shape *shapes[2];
    shapes[0] = &r;
    shapes[1] = &sq;
    int i;
    for (i = 0; i < 2; i++)
        printf("shape%d total=%d\n", i, describe(shapes[i]));     /* 26  45 */

    /* dynamic stack */
    Stack s = Stack(8);
    s.push(10); s.push(20); s.push(30);
    printf("stack size=%d\n", s.size());   /* 3 */
    int first = s.pop();
    int second = s.pop();
    printf("pop=%d pop=%d\n", first, second);  /* 30 20 */
    printf("stack size=%d\n", s.size());   /* 1 */
    return 0;
}
