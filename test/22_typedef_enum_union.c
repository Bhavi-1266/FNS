/* Feature: typedef (scalars, pointers, arrays, structs, function pointers), enum
   (implicit/explicit values, in switch, as array index), union (shared storage, size,
   tagged union). */
#include <stdio.h>

typedef int Integer;
typedef unsigned char Byte;
typedef char *String;
typedef int Vector3[3];
typedef struct { Integer x, y; } Point;
typedef Point *PointPtr;
typedef int (*Op)(int, int);

enum Color { RED, GREEN, BLUE };
enum Level { LOW = 10, MEDIUM = 20, HIGH = MEDIUM + 10, MAX = 100 };
typedef enum { MON = 1, TUE, WED, THU, FRI } Weekday;

union Number { int i; float f; char bytes[4]; };

typedef enum { T_INT, T_DOUBLE, T_STR } Tag;
typedef struct {
    Tag tag;
    union { int i; double d; const char *s; } as;
} Value;

int plus(int a, int b) { return a + b; }

void print_value(Value v) {
    switch (v.tag) {
        case T_INT: printf("int %d\n", v.as.i); break;
        case T_DOUBLE: printf("double %.3f\n", v.as.d); break;
        case T_STR: printf("string %s\n", v.as.s); break;
    }
}

const char *color_name(enum Color c) {
    switch (c) { case RED: return "red"; case GREEN: return "green"; case BLUE: return "blue"; }
    return "?";
}

int main() {
    Integer n = 5;
    Byte b = 250;
    b += 10;                                  /* wraps around */
    String s = "typedef'd string";
    Vector3 v = {1, 2, 3};
    Point p = {4, 5};
    PointPtr pp = &p;
    Op f = plus;
    printf("%d %d %s %d %d %d\n", n, b, s, v[0] + v[1] + v[2], pp->x, f(p.x, p.y));
    printf("sizeof(Point)=%d sizeof(Vector3)=%d\n", (int)sizeof(Point), (int)sizeof(Vector3));

    printf("%d %d %d\n", RED, GREEN, BLUE);
    printf("%d %d %d %d\n", LOW, MEDIUM, HIGH, MAX);
    Weekday d = WED;
    printf("WED=%d FRI=%d\n", d, FRI);
    int counts[3] = {0};
    enum Color seq[5] = {RED, BLUE, BLUE, GREEN, BLUE};
    for (int i = 0; i < 5; i++) counts[seq[i]]++;
    for (int c = RED; c <= BLUE; c++) printf("%s=%d ", color_name((enum Color)c), counts[c]);
    printf("\n");

    union Number num;
    num.i = 0x41424344;
    printf("bytes: %c%c%c%c size=%d\n", num.bytes[0], num.bytes[1], num.bytes[2], num.bytes[3],
           (int)sizeof(union Number));
    num.f = 1.0f;
    printf("float 1.0 bits = 0x%x\n", num.i);

    Value vals[3];
    vals[0].tag = T_INT;    vals[0].as.i = 42;
    vals[1].tag = T_DOUBLE; vals[1].as.d = 2.718;
    vals[2].tag = T_STR;    vals[2].as.s = "union text";
    for (int i = 0; i < 3; i++) print_value(vals[i]);
    return 0;
}
