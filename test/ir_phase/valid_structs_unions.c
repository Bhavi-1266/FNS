/* Valid: nested structs, unions, struct-in-struct offsets, aggregate copy, struct
   parameters by value/pointer, struct return, self-referential typedef'd struct. */
struct Inner { char a; int b; };
struct Outer { char c; struct Inner in; double d; short s; int arr[3]; };
union U { int i; char c; double d; };
struct WithU { int tag; union U u; };
typedef struct Node { int val; struct Node *next; } Node;
struct Outer make(void) { struct Outer o; o.c = 1; o.in.b = 2; return o; }
int take(struct Outer o) { o.c = 5; return o.in.b; }
int takep(struct Outer *o) { return o->in.b + o->arr[2]; }
int main(void) {
    struct Outer o; struct Outer o2;
    o.in.a = 'x'; o.in.b = 3; o.d = 1.5; o.s = 2; o.arr[1] = 9; o.arr[o.in.b - 2] = 1;
    o2 = o;                                      /* copy size */
    struct Outer o3 = o;
    struct Outer o4 = make();
    struct Outer *po = &o; po->in.b++; po->arr[0] = po->d;
    struct Inner *pi = &o.in; pi->b = 4; (&o)->s = 1;
    union U u; u.i = 1; u.c = 'c'; u.d = 2.0;
    struct WithU wu; wu.u.i = 5; wu.tag = 1;
    Node n1; Node n2; n1.val = 1; n1.next = &n2; n2.next = 0; n1.next->val = 2; n1.next->next = &n1;
    Node *cur = &n1; while (cur != 0) { cur = cur->next; if (cur == &n1) break; }
    int r = take(o) + takep(&o) + sizeof(struct Outer) + sizeof(union U) + sizeof(struct Inner) + sizeof(Node) + sizeof(o.in);
    return r + o2.in.b + o3.s + o4.c;
}
