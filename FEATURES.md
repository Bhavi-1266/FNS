# FNS compiler: features and how they are implemented

This document walks through every feature of the FNS compiler (`fnsc`) and explains
how we implemented it, from the source text to the MIPS32 assembly that runs on spim.
The [README](README.md) covers building, running and testing, and lists every
difference from C/C++ in section 9. The exact IR format is in
[`docs/IR_LANGUAGE_REFERENCE.md`](docs/IR_LANGUAGE_REFERENCE.md).

**Contents**

1. [The compilation pipeline](#1-the-compilation-pipeline)
2. [Three-address code (IR) and how to see it](#2-three-address-code-ir-and-how-to-see-it)
3. [Basic features](#3-basic-features)
4. [Advanced features](#4-advanced-features)
5. [Additional features](#5-additional-features)
6. [The runtime library](#6-the-runtime-library)
7. [The MIPS back end](#7-the-mips-back-end)
8. [Error checking](#8-error-checking)
9. [Testing](#9-testing)
10. [Feature → test → implementation map](#10-feature--test--implementation-map)

---

## 1. The compilation pipeline

```
 source.c / .cpp
      │  src/preprocess.cpp   macros, #if, built-in prelude (FILE, va_list, library prototypes)
      ▼
 expanded source
      │  src/lexer.l (flex)   tokens; typedef names become TYPE_NAME; Class::member is one token
      │  src/parser.y (bison) LALR(1) grammar with 0 conflicts → abstract syntax tree (src/ast.hpp)
      ▼
 AST
      │  src/codegen.cpp      semantic analysis (scopes, types, classes, overloads, access)
      │                       and lowering to three-address code
      ▼
 3AC IR  ──────────────────►  --print-ir / --emit-ir / test/output/*.ir
      │  src/mips.cpp         MIPS32 code generation, linking of the runtime functions used
      ▼
 program.s  ──►  spim -file program.s [arguments]
```

| Stage | File(s) | What it does |
|---|---|---|
| Driver | `src/main.cpp` | Reads options (`-o`, `--emit-ir`, `--print-ir`, `-E`), runs the stages, prints errors with line numbers. A `.c` file is compiled as C and a `.cpp` file as C++. |
| Preprocessor | `src/preprocess.cpp` | Expands `#define` macros (object-like, function-like, `#`, `##`, `__VA_ARGS__`) and evaluates `#if/#ifdef/#ifndef/#elif/#else/#endif`. It drops `#include` lines and adds a one-line prelude with `FILE`, `va_list`, `size_t` and the prototypes of the library functions the program calls. Every directive becomes an empty line, so line numbers stay correct. |
| Lexer | `src/lexer.l` | Produces tokens. It asks the declaration table whether a name is a `typedef`/class name and returns `TYPE_NAME` if so (the standard C "lexer hack"). In `.c` files, C++-only keywords (`class`, `new`, `public`…) are ordinary identifiers. |
| Parser | `src/parser.y` | Bison grammar for the C/C++ subset, with 0 shift/reduce and 0 reduce/reduce conflicts. It builds the AST. |
| Semantic analysis + IR | `src/codegen.cpp` | One pass over the AST. It keeps a scope stack of symbols with full types, lays out structs and classes, builds vtables, resolves overloads, checks access and types, and emits the three-address code. |
| Back end | `src/mips.cpp` | Turns each IR instruction into MIPS32, assigns stack slots, emits `.data`, and appends only the runtime-library functions the program reaches. |
| Runtime | `src/lib/libfns.c`, `src/runtime.s` | The C library (printf, scanf, files, strings, malloc, math), written in FNS and compiled by fnsc itself, plus a few hand-written lines of spim system calls. |

**Bootstrap build.** The library is written in the language we compile. The makefile
first builds `build/fnsc-boot` (the compiler without a library), uses it to compile
`src/lib/libfns.c` into `src/lib/libfns.s`, and then builds the final `./fnsc` with
that assembly embedded as a string. The output `.s` file is therefore self-contained.

---

## 2. Three-address code (IR) and how to see it

Every program is lowered to a textual three-address code before MIPS generation.
Every value-producing instruction is tagged with its type (`; int`, `; double`,
`; char*`), so the back end knows which load/store width and which (integer or
floating-point) instructions to use.

| How | Command |
|---|---|
| Print the IR on the terminal | `./fnsc prog.c --print-ir` (or `-ir`) |
| Write the IR to a file | `./fnsc prog.c --emit-ir` (→ `prog.ir`) or `--emit-ir out.ir` |
| One file through make | `make run FILE=prog.c` (or `RUN=prog.c`, program arguments in `ARGS="…"`): prints the IR and the MIPS assembly on the terminal, keeps them in `prog.ir` and `prog.s`, then runs the program on spim |
| Every test, IR saved | `make test`: PASS/FAIL on the terminal; every test's IR, its program output and the results are saved in `test/output/test_results.txt` |
| Every test, PASS/FAIL only | `make check` (runs `./run.sh ./fnsc`) |
| IR files of the tests | `test/output/NN_name.ir`, written on every run |

Instruction set: `x = y`, `x = y op z`, `x = op y`, `x = &y`, `x = *y`, `*x = y`,
`x = (type) y`, `copy dst, src, n`, labels `L:`, `goto L`, `if x goto L`,
`ifFalse x goto L`, `param x`, `call f, n`, `x = call f, n`, `x = call *p, n`,
`return [x]`. Sections: `.data` (strings, globals, vtables), `.extern` (library
functions used) and `.text` (functions).

---

## 3. Basic features

### 3.1 Arithmetic, relational, logical, bitwise and assignment operators — test 01

**Supported:** `+ - * / %`, unary `- + ! ~`, `== != < > <= >=`, `&& || !`,
`& | ^ << >>`, `= += -= *= /= %= &= |= ^= <<= >>=`, prefix and postfix `++`/`--`,
`?:`, the comma operator, `sizeof`, and casts. They follow C precedence and the
usual arithmetic conversions (char/short → int, int → unsigned, int → double).
Unsigned values wrap, and signed and unsigned operands use different MIPS instructions.

**How:**
- The grammar has one rule level per precedence level, so the AST already has the right shape.
- `codegen.cpp` computes the common type of the two operands, inserts a conversion
  `t = (double) x` when needed, and emits one temporary per operation.
- Pointer `+`/`-` is scaled by the pointee size, and pointer − pointer is divided by it.
- `&&`, `||` and `?:` short-circuit: they become conditional jumps into a result
  temporary, so the right side is evaluated only when needed:

```
// return a && b || !a;
    ifFalse a goto L3
    ifFalse b goto L3
    t2 = 1                               ; int
    goto L4
L3:
    t2 = 0                               ; int
L4:
    if t2 goto L1
    t3 = ! a                             ; int
    if t3 goto L1
    ...
```

- Compound assignment and `++`/`--` compute the address once, then load, operate and store.
- In the back end, `/` and `%` use `div`/`divu` + `mflo`/`mfhi`, and unsigned
  comparisons use `sltu`. Doubles use the coprocessor-1 instructions
  (`add.d`, `c.lt.d` + `bc1t`).

### 3.2 if / else — test 02

**How:** the condition is evaluated into a temporary, then `ifFalse t goto Lelse`,
the then-branch, `goto Lend`, `Lelse:`, the else-branch, `Lend:`. A condition of
type `double` is compared against 0.0 with FP instructions. A pointer or `char`
condition is tested against zero. A dangling `else` binds to the nearest `if`
through the grammar's precedence declaration.

### 3.3 for, while, do-while — test 03

**How:** each loop becomes labels and conditional jumps. The compiler keeps a stack
of `(continue label, break label)` pairs for the innermost loop. `for` has a
separate "step" label so that `continue` runs the increment. Every part of `for`
is optional, and a variable declared in `for (int i …)` gets its own scope.

### 3.4 switch — test 04, errors/e06

**How:** the controlling value is computed once and compared against each case in a
chain (`t = s == 1; if t goto Lcase1` …), then jumps to `default` or out of the
switch. The case bodies follow as labelled blocks in source order, so fallthrough
works as in C, and `break` jumps to the switch's end label. Case labels must be
constant expressions: integers, characters, enumerators or arithmetic on them.
Duplicate case values are reported as errors.

The whole switch body is **one scope**, as in C and C++: a variable declared under
one case can be used under a later case. In C++ a case label that would jump past
an initialised declaration (or an object with a constructor) earlier in the same
body is an error (`jump to case label crosses initialization of 'x'`, as in g++).
Objects declared in the body are destroyed at `break` and at the end of the switch.

```
L7:
    t4 = s == 1                          ; int
    if t4 goto L9
    t5 = s == 10                         ; int
    if t5 goto L10
    goto L11                             // default
L9:
    s = 2                                // case 1: falls through
L10:
    t6 = s + 1
    s = t6
    goto L8                              // break
L11:
    s = 0                                // default:
L8:
```

### 3.5 Arrays (int and char) — tests 05, 23

**Supported:** fixed-size arrays of any element type, initialiser lists (complete,
partial with zero fill, inferred size `int a[] = {…}`), designated initialisers
(`{[3] = 30, 40, [1] = 10}`, `{[WED] = "wed"}`, `{[1][2] = 9}`), char arrays from string
literals, arrays of strings, and arrays as function parameters. The size can be any
constant expression (`int a[N * 2]`).

**How:** an array is one block in the frame (locals) or in `.data` (globals). The
address of `a[i]` is `&a + i * sizeof(element)`. An array used as a value decays to
a pointer to its first element. Local initialisers are emitted as stores, with the
remaining elements zeroed. Global initialisers become `.word`/`.byte`/`.double`
data directives.

### 3.6 Pointers and multi-level pointers — tests 06, 33

**Supported:** `&`, `*`, pointer arithmetic and comparison, `void*`, `NULL`,
pointers to structs (`->`), `int**`, `int***`, pointer-to-pointer function
parameters, jagged arrays built with `malloc`, row pointers into
multi-dimensional arrays: `*(*(a + i) + j)`, and pointer-to-array variables
`int (*p)[4] = m;` (`p++` moves one row, `p[i][j]`, `last - p` counts rows).

**How:** every type is a chain of levels (`int**` = pointer → pointer → int). `&x`
emits `t = &x`, `*p` emits `t = *p` (a load) or `*p = v` (a store), and each extra
level is one more load:

```
// int **pp = &p;  **pp = 4;
    t12 = &p                             ; int**
    pp = t12                             ; int**
    t13 = *pp                            ; int*
    *t13 = 4                             ; int
```

For multi-dimensional arrays, `a + i` has type "pointer to row" (`int[3]*`), so it
is scaled by the row size, and `*(a + i)` gives the row, which decays to `int*`.

### 3.7 Structures — test 07

**Supported:** struct definitions, nested structs, arrays of structs, structs
containing arrays, pointers to structs, struct assignment, pass and return by value,
`typedef struct`, self-referential structs (linked lists, trees), brace initialisers,
and designated initialisers (`{.year = 2026, .day = 24}`, nested `{.lo.x = 0}`, and
`{[2] = {.month = 12}, [0].day = 1}` in arrays of structs).

**How:** `codegen.cpp` lays out the fields in declaration order. Each field is aligned
to its size (at most 4), and the struct size is rounded up to 4. `s.f` becomes
`&s + offset(f)`, and `p->f` becomes `p + offset(f)`. Struct assignment and
by-value passing use the IR instruction `copy dst, src, n`, which the back end
expands into word copies.

**Designated initialisers.** A designator `.f`, `[i]` or a chain such as `.lo.x` is a
`Designator` node in the brace list. The object is zeroed first; `fill_aggregate`
then moves its position to the designated member or element (later plain items
continue from there), and for a chain `designated_member` follows the remaining steps
to the sub-object's address and initialises only that sub-object. An array without a
size takes its size from the largest designated position.

### 3.8 printf and scanf — tests 08, 30

**Supported:** printf with every conversion (`d i u x X o c s f F e E g G p n %`),
flags (`- + space # 0`), width and precision (including `*`), and length modifiers.
scanf with the same conversions plus `%[...]` sets, `%n`, `*` (assignment
suppression), field widths, and correct EOF return values. Also `sprintf`,
`snprintf`, `sscanf`, `getchar`, `putchar`, `puts`, `vprintf`.

**How:** they are not built into the compiler. They are ordinary C functions in
`src/lib/libfns.c`, compiled by fnsc:
- `printf` → `__fns_vformat`, a formatter that writes into a "sink" (console, string
  or file). For `%f`/`%e`/`%g` it converts the `double` to decimal digits with
  correct rounding (ties rounded the same way as glibc), so the output matches gcc.
- `scanf` → `__fns_vscan`, which reads characters through a source (console, string
  or file) with one character of push-back.
- At the bottom, console output is spim syscall 11 (`print_char`), and console input
  is syscall 14 (`read` on fd 0), which reports end of input. That is how `scanf`
  returns `EOF` and `getchar` returns `-1`.

### 3.9 Function calls with arguments — test 09

**How:**
- **IR:** each argument is evaluated, then `param x` is emitted left to right,
  followed by `call f, n` or `t = call f, n`.
- **Calls:** arguments are converted to the parameter types (`int` → `double`,
  array → pointer, …). Function prototypes are registered first, so a function can
  be called before its definition.
- **Arguments in MIPS:** the caller pushes the arguments on the stack (a `double`
  takes two words). The callee reads them in place at positive offsets from `$fp`.
- **Results:** integers come back in `$v0`, `float`/`double` in `$f0`.

### 3.10 goto, break, continue — test 10

**How:** `break` and `continue` jump to the labels at the top of the loop/switch
stack. Using them outside a loop is a compile error. `goto L` and `L:` keep the
user's label name in the IR. The compiler checks that every target label exists in
the function and that no label is defined twice. In C++, destructors of objects
that go out of scope are called before `break` and `continue` jump. A `goto` out of a
block does not run them (README 9.4).

### 3.11 static — test 11

**Supported:** static local variables (keeping their value between calls, also in
recursive functions), static global variables and functions, static arrays, and
static class members.

**How:** a static local is stored as a global named `function_variable`
(`main_cnt` below) and initialised once in `.data`. Every use refers to that global:

```
    t7 = main_cnt + 1                    ; int
    main_cnt = t7                        ; int
```

A static local whose initialiser is not a literal (`static int calls = n * 10;`,
`static T obj(n);`, `static T arr[2];`) is initialised the first time control
reaches it, guarded by a hidden flag `function_variable__guard` (test 31):

```
    t5 = first_use_calls__guard          ; int
    if t5 goto L3
    first_use_calls__guard = 1           ; int
    t6 = n * 10                          ; int
    first_use_calls = t6                 ; int
L3:
```

A static local *object* registers its destructor with the library right after it is
constructed (`__fns_atexit(dtor, &obj)`, like C++'s `__cxa_atexit`). `exit()` and the
end of `main` run the registered destructors in reverse order of construction.

---

## 4. Advanced features

### 4.1 Recursion — test 09

**How:** every call gets its own stack frame. The prologue saves `$ra` and the old
`$fp`, sets `$fp` and reserves space for locals and temporaries. The epilogue
restores them. Locals live in the frame, so each recursive call has its own copy.
Tested with factorial, Fibonacci, gcd, power, Hanoi, Ackermann, permutations,
binary search and mutual recursion. Recursion depth is limited only by spim's
stack, about 9,000 levels.

```mips
U_add:                         # int add(int a, int b)
    move $t8, $fp
    move $t9, $sp
    addiu $sp, $sp, -8
    move $fp, $t9
    sw $ra, -4($fp)            # save return address
    sw $t8, -8($fp)            # save caller's frame pointer
    lw $t0, 0($fp)             # a  (argument 0)
    lw $t1, 4($fp)             # b  (argument 1)
    addu $t2, $t0, $t1
    move $v0, $t2              # result
    lw $ra, -4($fp)
    lw $t8, -8($fp)
    move $sp, $fp
    move $fp, $t8
    jr $ra
```

### 4.2 Classes and objects — tests 16, 29, 31

**Supported:** classes and structs with member functions, constructors (default,
overloaded, with initialiser lists, defined inside or outside the class with
`Class::method`), destructors, `this`, static data members and static methods,
const methods, delegating constructors, arrays of objects, objects created with `new`/`delete`, and objects
passed and returned by value.

**How:**
- **Layout:** a class is laid out like a struct. A method `m` of class `C` becomes
  an ordinary function `C_m` whose first parameter is `C* this`. `obj.m(x)` is
  lowered to `param &obj; param x; call C_m, 2`.
- **Inside methods:** a member name `f` is resolved as `this->f`.
- **Constructors and destructors:** constructors become `C_C(this, …)` and destructors `C__dtor(this)`.
- **Creating objects:** `C obj(args)`, `C obj{args}` and `C obj = C(args)` all
  construct the object in place, in its own storage.
- **Delegating constructors:** `Box() : Box(1)` calls the other constructor on `this`
  and skips the base, vtable and member initialisation (the target does them); other
  initialisers next to a delegating one are an error.
- **Destroying objects:** destructors run in reverse declaration order when a
  block ends, and before `return`, `break` and `continue`. Temporary objects are
  destroyed at the end of the full statement.
- **Global objects:** they are constructed in `__global_init`, called at the start
  of `main`. `__global_fini`, which destroys them in reverse order, is registered as
  the first exit handler, so static locals (constructed later) are destroyed before
  the globals, at the end of `main` or on `exit()`.

### 4.3 Inheritance and virtual functions — tests 17, 29

**Supported:** single inheritance with `public`, `protected` or `private` base
access, multi-level chains, base-class constructor calls in initialiser lists, virtual functions,
overriding, pure virtual functions and abstract classes, virtual destructors,
explicit `Base::method()` calls, and polymorphism through pointers and references.
Multiple and virtual inheritance are not supported (README 9.6).

**How:**
- **Layout:** the base-class fields come first, so a `Derived*` is also a valid `Base*`.
- **vtables:** a class with virtual functions has a hidden *vtable pointer* at
  offset 0. Each class gets a `vtable_Class` table in `.data` listing its virtual
  functions; overrides replace the base's entry in the same slot.
- **Constructors and destructors:** the constructor first calls the base
  constructor, then stores its own vtable address. The destructor resets the vtable
  pointer before running, then calls the base destructor.
- **Pure virtual functions:** the vtable slot of a pure virtual function points to
  `__pure_virtual`, which prints `pure virtual method called` and stops.
- **Virtual calls:** a virtual call loads the vtable pointer, loads the slot, and
  makes an indirect call:

```
// Shape *p = new Sq(3);  int a = p->area();  delete p;
    param 1
    param 12
    param 0
    t1 = call __fns_new, 3               ; void*   1 object of 12 bytes, no header
    param t1
    param 3
    call Sq_Sq, 2                        // construct in the new storage
    ...
    t3 = *p                              ; ptr    vtable pointer
    t4 = *t3                             ; fn*    slot 0 = area
    param p
    t5 = call *t4, 1                     ; int
    ...
    t6 = *p                              ; ptr
    t7 = t6 + 4                          ; ptr    slot 1 = virtual destructor
    t8 = *t7                             ; fn*
    param p
    call *t8, 1
    param p
    call free, 1
```

```mips
U_vtable_Shape: .word U_Shape_area, U_Shape__dtor
U_vtable_Sq:    .word U_Sq_area,    U_Sq__dtor
```

### 4.4 public, private, protected — test 18, errors/e05

**How:** each member records its access level and the class that declared it.
Every member access (field, method, constructor) checks that:
- **public** members can be used from anywhere;
- **protected** members can be used from inside the class or a derived class;
- **private** members can be used only from inside the class.

`class` members default to `private` and `struct` members to `public`.

The base-class access (`class D : public/protected/private B`) is stored on the
class. A member is checked by its access *as a member of the class it is named
through*: walking from the base down to that class, a `protected` base turns
public members into protected ones, a `private` base makes public and protected
members private, and a member that was already private becomes inaccessible
(`access_in` in `codegen.cpp`). Converting a `D*`/`D&` to an inaccessible base is
an error too. The checks also cover constructors and destructors. Violations are
compile errors, which `test/errors/e05_access.cpp` checks:

```
Errors:
  line 17: member 'balance' is not accessible here
  line 27: member 'get' is not accessible here
  line 32: member 'get' is not accessible here
  line 33: 'Account' is an inaccessible base of 'Locked'
  line 35: member 'balance' is not accessible here
  line 36: member 'audit' is not accessible here
  line 37: member 'id' is not accessible here
```

### 4.5 Variable-argument functions — test 13

**Supported:** `int f(int n, ...)` with `va_list`, `va_start`, `va_arg` (int, char,
double, pointers), `va_end`, `va_copy`, and passing a `va_list` on to
`vprintf`/`vsprintf`/`vfprintf`.

**How:**
- All arguments are pushed on the stack, so the unnamed ones lie right after the
  named ones. `call f, n` carries the real count.
- `va_list` is a `char*`. The prelude defines `va_start`, `va_arg` and `va_end` as macros.
- `va_start(ap, n)` uses the built-in `__builtin_va_start`, which the compiler
  lowers to `t = &__va_args`: the address of the first unnamed argument.
- `va_arg(ap, T)` advances `ap` by `sizeof(T)` rounded up to 4 and reads the value
  just before it:

```
function sum(int n, ...) : int
    t1 = &__va_args                      ; char*
    ap = t1                              ; char*      va_start
    ...
    t6 = ap + t5                         ; char*      ap += 4
    ap = t6
    t10 = t6 - t9                        ; char*
    t11 = (int*) t10                     ; int*
    t12 = *t11                           ; int        va_arg(ap, int)
```

As in C, `float` arguments to `...` are promoted to `double`, and `char`/`short` to `int`.

### 4.6 Dynamic memory allocation — tests 14, 16

**Supported:** `malloc`, `calloc`, `realloc`, `free`, and C++ `new T`, `new T(args)`,
`new T[n]`, `delete`, `delete[]`. Tests build dynamic arrays, strings, 2-D arrays,
linked lists, stacks and binary search trees.

**How:**
- `malloc`/`free` are implemented in `src/lib/libfns.c` as a first-fit free-list
  allocator. It gets memory from spim with syscall 9 (`sbrk`) and reuses freed blocks.
- `malloc(n)` with a size larger than the address space (for example `(size_t)-1`)
  returns `NULL`. `calloc` returns `NULL` when `n * size` overflows 32 bits, and a
  failed `realloc` returns `NULL` and leaves the old block untouched. When the heap
  really runs out, spim itself stops the program (`Can't expand data segment`).
- `new T(args)` → `__fns_new(1, sizeof(T), 0)` followed by the constructor call (see
  the IR in 4.3). `__fns_new` is `malloc` plus the C++ failure behaviour: a negative
  array length or a failed allocation prints the same `terminate called after
  throwing an instance of 'std::bad_array_new_length'` / `'std::bad_alloc'` message
  as g++ and aborts, instead of constructing into a null pointer.
- `new T[n]` → `__fns_new(n, sizeof(T), 4)`: the 4-byte header in front of the
  array holds the element count; every element is constructed. `delete[]` destroys
  them in reverse order before freeing the memory.
- `delete p` calls the destructor (through the vtable if it is virtual), then `free`.
  `delete` of a null pointer does nothing.

### 4.7 Lambda functions — test 15

**Supported:** lambdas with parameters, captures by value `[x]`, by reference
`[&x]`, `[=]`, `[&]`, mixed captures, immediately-invoked lambdas, lambdas stored
in `auto` variables and passed as callbacks, deduced return types, and `mutable` lambdas.

**How:**
- Each lambda body becomes a separate top-level function `lambda_N`. The captured
  variables become extra trailing parameters.
- Where the lambda is created, captured values are copied into hidden locals
  (`[=]`), or their addresses are taken (`[&]`). Each call passes them along.
- The return type is deduced from the first `return` statement.
- By-value captures are `const` inside the lambda, so changing one is an error unless
  the lambda is `mutable`. A `mutable` lambda's copies live in a hidden local of the
  creating function (`lambda_N_cap_x_copy`), and the lambda receives their address,
  so changes persist from one call to the next while the original variable is unchanged.

```
// int k = 5;  auto f = [k](int x) { return x + k; };  f(2);
function lambda_1(int x, int cap_k) : int
    t1 = x + cap_k                       ; int
    return t1                            ; int
endfunction
...
    lambda_1_cap_k = k                   ; int     capture by value
    param 2
    param lambda_1_cap_k
    t10 = call lambda_1, 2               ; int
```

### 4.8 Function pointers — test 12

**Supported:** declaring `int (*fp)(int, int)`, assigning functions with or without
`&`, calling with `fp(a)` or `(*fp)(a)`, typedef'd function-pointer types, arrays of
function pointers (dispatch tables), passing them as callbacks (including `qsort`
comparators), returning them from functions (with a typedef or written out:
`int (*pick(char op))(int, int)`), and pointers to function pointers `int (**pp)(int, int)`.

**Parenthesised declarators.** The grammar has one rule for the parenthesised part
`( * … * name [dims] )` (`paren_declarator` in `parser.y`). Followed by a parameter
list it declares a function pointer (with as many extra pointer levels as stars, or an
array of them); followed by `[N]` it declares a pointer to an array, which uses the same
representation as an array parameter `int a[][N]` (a pointer to the first row), so all
row arithmetic is shared. A separate rule handles a function whose return type is a
function pointer.

**How:** a function name used as a value is the address of its label. A call
through a pointer becomes an indirect call `t = call *fp, n`, which the back end
emits as `jalr`:

```
function apply(fn* fp, int a) : int
    param a
    param a
    t1 = call *fp, 2                     ; int
...
    param add                            // address of function add
    param 4
    t11 = call apply, 2
```

### 4.9 Command-line input — test 20

**Supported:** `int main(int argc, char *argv[])` (also `char **argv`). `argv[0]` is
the assembly file name given to spim, and `argv[argc]` is `NULL`. The test parses numbers with `atoi`
and prints strings.

**How:** spim's start-up code calls `main` with `argc` in `$a0` and `argv` in `$a1`.
The prologue of `main` stores the two registers into the parameter slots, so from
then on they are ordinary parameters. The arguments come from the spim command line:
`spim -file prog.s mul 6 -7`. On macOS, SPIM 9.1 drops arguments after `-file`.
`run.sh` detects this and runs the test through a small start-up wrapper
(`tools/spim_args.py`) that puts the same values in `$a0`/`$a1`.

### 4.10 typedef — test 22

**Supported:** typedefs of scalars, pointers, arrays, structs (named and anonymous),
unions, enums and function-pointer types, typedefs of typedefs, and casts to typedef names.

**How:** a `typedef` registers the name in the declaration table that the lexer
consults, so the parser receives a `TYPE_NAME` token instead of an identifier. This
is how `T * x;` is parsed as a declaration and `(T) x` as a cast. In semantic
analysis the typedef stands for the full type it was declared with, so it produces
the same code as writing that type directly.

### 4.11 References — test 19

**Supported:** reference variables, pass-by-reference, return-by-reference
(`int& at(int i)`, which can be assigned to), `const` references to temporaries,
references to objects, references to pointers, and references to the result of `?:`.

**How:** a reference is a hidden pointer. Declaring it stores an address, and every
use loads or stores through that address. A call passes `&x`:

```
// void inc(int &r) { r++; }     inc(k);
function inc(int& r) : void
    t1 = *r                              ; int
    t2 = t1 + 1                          ; int
    *r = t2                              ; int
    return
...
    t9 = &k                              ; int*
    param t9
    call inc, 1
```

A `const T&` bound to a temporary value first stores the value in a hidden local,
then passes that local's address.

### 4.12 enum and union — tests 22, 32

**Supported:** enums with automatic and explicit values (including negative and
expressions of earlier enumerators), enums in `switch`, `typedef enum`, C++
`enum class` with an optional underlying type, unions (including anonymous unions
inside structs and tagged unions), and union initialisation.

**How:** enumerators are compile-time integer constants stored in the symbol table;
they never occupy memory. Unions are laid out like structs except that every field
is at offset 0 and the size is that of the largest field (rounded to 4). The type
system also allows the classic type pun: writing a `float` and reading the `int`
in the same union.

### 4.13 File manipulation — test 21

**Supported:** `fopen` (modes `r w a r+ w+ a+`, with optional `b`), `fclose`,
`fseek`/`ftell`/`rewind` (`SEEK_SET`, `SEEK_CUR`, `SEEK_END`),
`fprintf`, `fscanf`, `fgets`, `fputs`, `fgetc`/`getc`, `fputc`/`putc`, `ungetc`,
`fread`, `fwrite`, `feof`, `ferror`, `fflush`, and `stdin`/`stdout`/`stderr`.

**How:**
- `FILE` is a small struct in the runtime holding the descriptor, the mode, one
  pushed-back character and the EOF/error flags.
- `fopen` turns the mode string into `open(2)` flags and calls spim syscall 13.
  spim passes these flags to the host, so the runtime chooses the Linux or macOS
  values depending on where fnsc was built.
- Reading and writing use syscalls 14 and 15, and closing uses syscall 16.
- **Seeking:** spim has no seek system call, so the `FILE` also keeps the file name, the
  flags to reopen it (without `O_TRUNC`) and the current position (counted on every
  read and write). `fseek` computes the target (`SEEK_END` measures the file by reading
  it), reopens the file and reads forward to the target. `ftell` returns the counted
  position, and `rewind` is `fseek(f, 0, SEEK_SET)` that also clears the error flag.
- `stdin`, `stdout` and `stderr` are fixed pseudo-pointers mapped to descriptors 0, 1 and 2.
- `fprintf` and `fscanf` reuse the same formatter and scanner as `printf` and `scanf`.

### 4.14 until loop — test 24

FNS adds a loop that C and C++ do not have:

```c
do {
    body
} until (condition);
```

The body runs once, then repeats **until** the condition becomes true, which is the
same as `do { body } while (!(condition));`. `break` and `continue` work inside it.

**How:** `until` is a keyword in `src/lexer.l`. The grammar rule
`do_until_stmt : DO stmt UNTIL ( expr ) ;` builds an `NK::DoUntil` node. Code
generation emits the body, then a jump **back while the condition is false**
(`ifFalse`, where do-while uses `if`):

```
L5:                                      // body
    t1 = s + i
    s = t1
    t2 = i + 1
    i = t2
L6:                                      // continue target
    t3 = i >= 5                          ; int
    ifFalse t3 goto L5                   // repeat until i >= 5
L7:                                      // break target
```

### 4.15 Multi-dimensional arrays — tests 23, 33

**Supported:** 2-D and 3-D arrays of any element type, nested, flat and partial
initialisers (with brace elision), passing them to functions (`int m[][3]`),
row-pointer arithmetic, and matrix algorithms.

**How:** the array type records every dimension, and indexing is row-major:
`&m[i][j] = &m + i * (cols * size) + j * size`. Each `[ ]` peels off one dimension:
`m[i]` has type `int[3]` (a row, which decays to `int*` when needed), and `m[i][j]`
is an `int`. With constant indices the offsets are added directly:

```
// int m[2][3];  m[1][2] = 7;
    t8 = &m                              ; int[3]*
    t9 = t8 + 12                         ; int*     row 1 = 1 * 12 bytes
    t10 = t9 + 8                         ; int*     column 2 = 2 * 4 bytes
    *t10 = 7                             ; int
```

---

## 5. Additional features

Beyond the required list, these were needed to compile normal C/C++ test programs:

| Feature | How |
|---|---|
| **Preprocessor** (test 25) | `src/preprocess.cpp` provides object-like and function-like macros, `#` stringising, `##` pasting, `__VA_ARGS__`, `#if` with full constant-expression evaluation and `defined`, `__LINE__`, `__FILE__`, and predefined `NULL`, `EOF`, `INT_MAX`… |
| **Function / method / constructor overloading** (test 27) | Each overload gets its own IR name (`f`, `f__1`, `f__2`). A call is resolved by ranking each argument: exact match, promotion, then conversion. Ambiguous or missing matches are errors. In `.c` files a redefinition is an error, as in C. |
| **Default arguments** (tests 27, 31) | Stored with the function. The call site appends the missing default expressions as ordinary `param`s. |
| **Copy constructors** (test 31) | `T b = a;` and passing an object by value call the copy constructor if the class has one; otherwise the object is copied byte for byte. A temporary returned from a function is moved directly, without a copy (copy elision). |
| **Converting constructors** | `T x = 5;` and passing `5` to a `const T&` / `T` parameter call `T(int)`. |
| **Object lifetime** (test 31) | Scope-exit destructors, end-of-statement destruction of temporaries, lazily initialised static locals, and destruction of static objects in reverse construction order at the end of `main` or on `exit()`. |
| **Range-based for** (test 32) | `for (int x : arr)` over arrays of known size becomes a hidden index loop. `for (auto &x : arr)` binds a reference to each element. |
| **enum class** (test 32) | Scoped enumerators `Color::Red`, with an optional underlying type `enum class E : char`. |
| **C++ casts** (test 33) | `static_cast`, `reinterpret_cast`, `const_cast`, `dynamic_cast` (no run-time check), functional casts `int(x)` and C-style casts, including casts to typedef and enum names. |
| **Floating point** (test 28) | `float` (4 bytes) and `double` (8 bytes) using the MIPS FPU. Includes conversions in both directions and comparisons. Literals are emitted in a form spim's assembler accepts. |
| **String library** (test 26) | `string.h`, `ctype.h`, `stdlib.h` and `math.h` functions in the runtime (see section 6). |
| **Constant-expression array sizes** | `int a[N * 2 + 1]` with `const int` and enum constants. |

---

## 6. The runtime library

All library functions are written in C in `src/lib/libfns.c` and compiled by fnsc
itself. Only `src/runtime.s` is hand-written, and it contains just the spim system
calls:

| Stub | spim syscall |
|---|---|
| `__sys_putc` | 11 print_char |
| `__sys_open` / `__sys_read` / `__sys_write` / `__sys_close` | 13 / 14 / 15 / 16 |
| `__sys_sbrk` | 9 sbrk |
| `__sys_exit` | 17 exit2 (so `exit(n)` returns status `n`) |

| Header | Functions |
|---|---|
| stdio | `printf scanf sprintf snprintf sscanf fprintf fscanf vprintf vfprintf vsprintf vsnprintf putchar getchar puts fopen fclose fseek ftell rewind fputc putc fgetc getc ungetc fputs fgets fread fwrite feof ferror fflush remove` |
| stdlib | `malloc calloc realloc free exit abort abs labs atoi atol atof strtol strtod rand srand qsort bsearch` |
| string | `strlen strcpy strncpy strcat strncat strcmp strncmp strchr strrchr strstr strdup strtok strspn strcspn strpbrk memset memcpy memmove memcmp` |
| ctype | `isdigit isalpha isalnum isspace isupper islower ispunct isxdigit isprint toupper tolower` |
| math | `sqrt pow fabs floor ceil round fmod exp log log10 sin cos tan fmax fmin` |

Details worth knowing:
- **No `#include` needed.** `#include` lines are accepted and ignored. The
  preprocessor declares the prototypes of exactly the library functions the program calls.
- **Only what is used.** Each library function is marked in `libfns.s`. The back
  end follows calls from the user's program and copies in only the functions it
  needs (with everything they call). This keeps programs well inside spim's 64 KB
  text segment.
- **`rand`/`srand`** produce exactly glibc's sequence, so programs using `rand()`
  print the same numbers as with gcc.
- **Math** is computed in software (range reduction plus series) on top of the FPU's
  `sqrt.d`.

---

## 7. The MIPS back end

`src/mips.cpp` translates the IR function by function:

- **Frames.** Each local and temporary gets a stack slot at a negative offset from
  `$fp`, and arguments sit at positive offsets. Large arrays are placed at the end of
  the frame. Offsets beyond the 16-bit range are computed with an extra register.
- **Register use.** A temporary that is used only by the very next instruction stays
  in a register (`$t2`) instead of being stored and reloaded. Constants become
  immediate operands (`addiu`, `slti`, `andi` …) where MIPS allows it.
- **Typed loads and stores.** The `; type` annotation selects `lb`/`lbu`/`lh`/`lw`/`l.s`/`l.d`
  and the matching stores. Doubles use even/odd FPU register pairs.
- **Data.** Globals are emitted with their real types (`.word`, `.byte`, `.half`,
  `.float`, `.double`, `.asciiz`), and strings are escaped correctly. Large
  uninitialised globals (32 KB or more) are allocated from the heap at program start
  because spim's static data area is small.
- **Names.** User symbols are emitted as `U_name` and library symbols as `R_name`, so
  a user function called `abs`, `move` or `add` never clashes with a MIPS
  instruction or a library function.
- **Program start.** `main` stores `argc`/`argv`, allocates large globals, calls
  `__global_init` (dynamic initialisers and global constructors), registers
  `__global_fini`, and runs the exit handlers (`__fns_run_atexit`) before returning.
- **Size warning.** If a program is larger than spim's default 64 KB text segment,
  fnsc warns and suggests `spim -stext 262144`.

---

## 8. Error checking

The compiler reports every error with its line number and writes no assembly when
there are errors (exit status 1). Checks include:

- **Syntax:** syntax errors, with the offending token.
- **Names and calls:** undeclared identifiers, redeclarations, calls
  with the wrong number of arguments, functions that are used but never defined,
  and no matching overload.
- **Types:** incompatible types in assignments, arguments and returns, dereferencing
  a non-pointer, `.`/`->` on a non-struct, and a missing return value.
- **Statements:** `break`/`continue` outside a loop, `goto` to an undefined label,
  duplicate labels, duplicate `case` values, non-constant case labels, and (C++) a
  case label that jumps past an initialisation.
- **const:** assigning to a `const` variable.
- **Classes:** access violations (public/private/protected, including through a
  private or protected base), conversion to an inaccessible base, unknown members,
  no matching constructor, and a missing default constructor.
- **Untranslatable code:** a construct the compiler cannot translate to MIPS is an
  error, never a warning, so no assembly file is written for it.

The negative tests `test/errors/e01_syntax.c` … `e06_switch_scope.cpp` check that these
errors are reported, with the exact expected messages in `test/errors/expected/`.
`tools/gate.sh` runs two larger files with 67 deliberate semantic errors.

---

## 9. Testing

```bash
make test     # build, run all 39 tests on spim; full log with each test's IR and
              #   program output in test/output/test_results.txt
make check    # the same tests, PASS/FAIL only
make run FILE=test/09_functions_recursion.c   # one program: IR + assembly + run
./run.sh ./fnsc 16_classes      # one test
```

For every program `test/NN_name.c|cpp`, `run.sh`:
1. compiles it to `test/output/NN_name.s` (MIPS) and `test/output/NN_name.ir` (IR);
2. runs it on spim with stdin from `test/input/` and arguments from `test/args/`;
3. compares the output byte for byte with `test/expected/NN_name.expected`.

The expected outputs were generated by compiling the **same sources with gcc/g++**
(`tools/make_expected.sh`), so a passing test means fnsc + spim printed exactly what
the native compiler printed. Current result: **39 / 39 pass**. Other checks:
`tools/gate.sh` (grammar conflicts, semantic-error coverage, IR structure) and
`tools/check_long_functions.py` (every function longer than 30 lines has a comment).

---

## 10. Feature → test → implementation map

| Feature | Test | Main implementation |
|---|---|---|
| Operators | 01 | `parser.y` precedence levels; `codegen.cpp` `gen_binary`/`gen_unary`; `mips.cpp` `emit_binop` |
| if-else | 02 | `codegen.cpp` statement lowering |
| for / while / do-while | 03 | loop lowering with the break/continue label stack |
| switch | 04 | compare chain + labelled bodies |
| Arrays | 05, 23 | array types with dimensions; row-major addressing |
| Pointers, multi-level pointers | 06, 33 | pointer type levels; `&`/`*`; scaled arithmetic |
| Structures | 07 | `layout_class`; `copy` for aggregates |
| printf / scanf | 08, 30 | `libfns.c` `__fns_vformat` / `__fns_vscan`; syscalls 11 and 14 |
| Functions, recursion | 09 | `param`/`call`; `$fp` frames in `mips.cpp` |
| goto / break / continue | 10 | label stack; label checks |
| static | 11, 31 | `function_variable` globals; guarded first-use initialisation; exit-handler registration |
| Function pointers | 12 | `call *p` → `jalr` |
| Variadic functions | 13 | `__builtin_va_start` → `&__va_args`; stdarg macros in the prelude |
| Dynamic memory | 14, 16 | `libfns.c` malloc/free on `sbrk`, `__fns_new`; `new`/`delete` lowering |
| Lambdas | 15 | `lambda_N` functions with capture parameters |
| Classes and objects | 16, 29, 31 | `Class_method(this, …)`; constructors/destructors; lifetime tracking |
| Inheritance, virtual | 17, 29 | base-first layout; vptr + `vtable_Class`; indirect calls |
| public / private / protected | 18, e05 | access check on every member use |
| References | 19 | hidden pointers |
| Command-line input | 20 | `$a0`/`$a1` stored into `argc`/`argv` |
| File manipulation | 21 | `libfns.c` FILE functions; syscalls 13–16 |
| typedef, enum, union | 22, 32 | `TYPE_NAME` lexer feedback; enum constants; offset-0 union layout |
| until loop | 24 | `UNTIL_KW` token; `do_until_stmt` rule; `ifFalse` back-jump |
| Preprocessor | 25 | `preprocess.cpp` |
| Library | 26 | `libfns.c` |
| Overloading, default arguments | 27 | `pick_overload` ranking; `f__N` names |
| Floating point | 28 | typed IR; FPU instructions |
| Object lifetime | 31 | scope/temporary destructor lists; `__global_init`/`__global_fini`; `__fns_atexit` in `libfns.c` |
| Range-for, enum class | 32 | `gen_range_for`; scoped enumerators |
| IR output | all | `--print-ir`, `--emit-ir`, `make run`, `make test` (`test/output/test_results.txt`), `test/output/*.ir` |
