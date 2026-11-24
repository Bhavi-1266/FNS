/* Deliberate semantic errors: type compatibility of assignment, initialisation,
   arguments and returns; declarations; labels. */
struct S { int a; int b; };
struct T { int c; };
void nothing(void) { return 1; }          /* expect: return with a value in a function returning void */
int no_value(void) { return; }            /* expect: return without a value in a function returning 'int' */
int ret_struct(void) { struct S s; return s; }   /* expect: incompatible types in return: cannot convert 'struct S' to 'int' */
struct S ret_int(void) { return 1; }      /* expect: incompatible types in return: cannot convert 'int' to 'struct S' */
int proto(int a);
int proto(int a, int b) { return a + b; } /* expect: conflicting declaration of function 'proto' */
int dup_param(int a, int a) { return a; } /* expect: redeclaration of 'a' */
int takes_s(struct S s) { return s.a; }
int g = 1;
int g = 2;                                /* expect: redeclaration of 'g' */
enum E { A, A };                          /* expect: redeclaration of 'A' */
struct Dup { int a; int a; };             /* expect: duplicate member 'a' in Dup */
struct Rec { int a; struct Rec inner; };  /* expect: member 'inner' has incomplete type 'Rec' */
int main(void) {
    struct S s1, s2; struct T t; int i = 1; double d = 2.0; int *p = &i; void *vp = 0; int arr[3]; int brr[3];
    s1 = 5;                               /* expect: incompatible types in assignment: cannot convert 'int' to 'struct S' */
    i = s1;                               /* expect: incompatible types in assignment: cannot convert 'struct S' to 'int' */
    s1 = t;                               /* expect: incompatible types in assignment: cannot convert 'struct T' to 'struct S' */
    p = d;                                /* expect: incompatible types in assignment: cannot convert 'double' to 'int*' */
    d = p;                                /* expect: incompatible types in assignment: cannot convert 'int*' to 'double' */
    arr = brr;                            /* expect: cannot assign to an array */
    int e1 = nothing();                   /* expect: void value used in initialization */
    i += nothing();                       /* expect: void value used in compound assignment */
    int e2 = nothing() + 1;               /* expect: void value used as an operand of '+' */
    int e3 = *vp;                         /* expect: dereference of a void pointer */
    takes_s(i);                           /* expect: incompatible types in argument passing: cannot convert 'int' to 'struct S' */
    takes_s(t);                           /* expect: incompatible types in argument passing: cannot convert 'struct T' to 'struct S' */
    if (s1) i++;                          /* expect: condition must have a scalar type, got 'struct S' */
    while (s2) i++;                       /* expect: condition must have a scalar type, got 'struct S' */
    int e4 = s1 && 1;                     /* expect: condition must have a scalar type, got 'struct S' */
    int i = 2;                            /* expect: redeclaration of 'i' */
    void v;                               /* expect: variable 'v' has incomplete type 'void' */
    int e5 = sizeof(void);                /* expect: sizeof applied to an incomplete type */
    char small[2] = "abc";                /* expect: string literal of 4 bytes does not fit in char[2] */
    int e6 = i(1);                        /* expect: called object is not a function or function pointer */
    int (*fp)(int, int) = 0;
    int e7 = fp(1);                       /* expect: function pointer call expects 2 argument(s), got 1 */
    int e8 = (struct S) i;                /* expect: cannot cast between aggregate and scalar types */
    goto nowhere;                         /* expect: goto to undefined label 'nowhere' */
twice: i++;
twice: i++;                               /* expect: duplicate label 'twice' */
    return 0;
}
