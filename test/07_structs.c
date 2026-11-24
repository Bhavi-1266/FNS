/* Feature: struct: nested, arrays of structs, pointers, copy, pass/return by value,
   typedef struct, self-referential struct (linked list), sizeof and layout. */
#include <stdio.h>
#include <string.h>

struct Date { int day, month, year; };
struct Student {
    char name[16];
    int roll;
    float marks;
    struct Date dob;
};
typedef struct { double re, im; } Complex;
typedef struct Node { int val; struct Node *next; } Node;

Complex add(Complex a, Complex b) { Complex r; r.re = a.re + b.re; r.im = a.im + b.im; return r; }

void birthday(struct Student *s) { s->dob.year--; s->marks += 1.5f; }

void try_modify(struct Student s) { s.roll = -1; }      /* works on a copy */

struct Student top(struct Student list[], int n) {
    int best = 0;
    for (int i = 1; i < n; i++) if (list[i].marks > list[best].marks) best = i;
    return list[best];
}

int main() {
    struct Student s[3] = {
        {"Asha", 1, 88.5f, {12, 5, 2004}},
        {"Bilal", 2, 92.0f, {1, 1, 2003}},
        {"Chen", 3, 79.25f, {30, 12, 2004}},
    };
    for (int i = 0; i < 3; i++)
        printf("%-6s %2d %6.2f %02d/%02d/%d\n", s[i].name, s[i].roll, s[i].marks,
               s[i].dob.day, s[i].dob.month, s[i].dob.year);
    struct Student best = top(s, 3);
    printf("top: %s\n", best.name);
    try_modify(best);
    printf("roll still %d\n", best.roll);
    birthday(&s[0]);
    printf("%s now born %d, marks %.2f\n", s[0].name, s[0].dob.year, s[0].marks);

    /* struct assignment copies */
    struct Student copy = s[2];
    strcpy(copy.name, "Copy");
    copy.dob.day = 1;
    printf("%s %d / %s %d\n", s[2].name, s[2].dob.day, copy.name, copy.dob.day);

    Complex a = {1.5, -2.0}, b = {0.5, 4.0};
    Complex c = add(a, b);
    printf("(%.1f, %.1f)\n", c.re, c.im);

    /* linked list built from a local array of nodes */
    Node nodes[4];
    for (int i = 0; i < 4; i++) { nodes[i].val = (i + 1) * 11; nodes[i].next = i < 3 ? &nodes[i + 1] : NULL; }
    for (Node *p = &nodes[0]; p != NULL; p = p->next) printf("%d -> ", p->val);
    printf("NULL\n");

    printf("sizeof(struct Date)=%d sizeof(Complex)=%d\n", (int)sizeof(struct Date), (int)sizeof(Complex));
    struct Date *dp = &s[1].dob;
    printf("via pointer: %d-%d-%d\n", dp->year, dp->month, dp->day);
    return 0;
}
