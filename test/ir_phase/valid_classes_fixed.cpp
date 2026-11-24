/* Valid: self-referential classes, forward declarations, out-of-class static member
   definitions, virtual destructors dispatched through the vtable, delete of a null
   pointer, prototype/definition parameter renaming. */
class Node;
class Node {
public:
    int value;
    Node *next;
    static int created;
    Node(int v) : value(v), next(nullptr) { created++; }
    int same(Node &other) { return other.value == value; }
    Node *self() { return this; }
};
int Node::created = 0;
class Shape {
public:
    int sides;
    Shape() : sides(0) {}
    virtual int area() { return 0; }
    virtual ~Shape() { sides = 0; }
};
class Square : public Shape {
public:
    int side;
    Square() : side(2) {}
    int area() override { return side * side; }
    ~Square() { side = 0; }
};
double half(double x);
int main() {
    Node a = Node(1);
    Node b = Node(2);
    a.next = &b;
    int r = a.same(b) + a.next->value + a.self()->value + Node::created;
    Shape *s = new Square();
    r += s->area();
    delete s;
    Shape *arr = new Square[2];
    delete[] arr;
    Shape *none = nullptr;
    delete none;
    return r + (int) half(4.0);
}
double half(double y) { return y / 2; }
