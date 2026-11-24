// Must fail: in C++ a case label may not jump past the initialisation of a
// variable declared earlier in the same switch body (the body is one scope).
#include <cstdio>

class Res {
public:
    Res() { printf("acquire\n"); }
    ~Res() { printf("release\n"); }
};

int main() {
    int k = 2;
    switch (k) {
    case 1:
        int count = 5;                 // initialised declaration ...
        printf("%d\n", count);
    case 2:                            // ... jumped over by this label
        break;
    }
    switch (k) {
    case 1:
        Res r;                         // object with a constructor
    default:                           // jumps over its construction
        break;
    }
    switch (k) {
    case 1: {
        int scoped = 1;                // fine: inside its own block
        printf("%d\n", scoped);
    }
    case 2:
        break;
    }
    return 0;
}
