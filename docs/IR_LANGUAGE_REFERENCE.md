# FNS three-address code (IR) reference

This document describes the intermediate representation that `fnsc` produces
between semantic analysis and MIPS code generation, and how each source construct
is lowered into it. Print it with `fnsc prog.c --print-ir` or write it to a file
with `--emit-ir [file]`; `run.sh` stores it as `test/output/<test>.ir`.

The source language itself (supported features and every difference from C and
C++) is documented in the [README](../README.md#9-differences-from-c-and-c).

## IR format

```
; FNS three-address code
; source: test/valid_oop.cpp

.data
    str0: "total = %d\n"
    global counter : unsigned int (4) = 0
    vtable_Shape: Shape_compute_area

.extern
    printf

.text

function Circle_Circle(Circle* this, double r) : void
    param this
    call Shape_Shape, 1
    t1 = &vtable_Circle                  ; ptr
    *this = t1                           ; ptr
    t2 = this + 16                       ; double*
    *t2 = r                              ; double
    return
endfunction
```

Sections: `.data` (string literals, globals with size and constant initialiser, vtables),
`.extern` (library functions called but not defined), `.text` (functions). Each function lists
its parameters with types, its locals with type and size, then the code. Every value-producing
instruction ends with `; type` so the MIPS back end knows operand widths (`lb` vs `lw`) and when to
use floating-point instructions.

Instruction set:

| Instruction | Meaning |
|---|---|
| `x = y` | copy |
| `x = y op z` | binary op: `+ - * / % & \| ^ << >> == != < > <= >=` |
| `x = op y` | unary op: `- ! ~` |
| `x = &y` | address of a variable |
| `x = *y` | load through pointer |
| `*x = y` | store through pointer |
| `x = (type) y` | conversion |
| `copy dst, src, n` | copy `n` bytes between two addresses (aggregate assignment) |
| `L:` | label (`Ln` generated, user labels keep their name) |
| `goto L`, `if x goto L`, `ifFalse x goto L` | jumps |
| `param x` | push argument, left to right |
| `call f, n`, `x = call f, n` | direct call with `n` params |
| `x = call *p, n` | indirect call through a function pointer or vtable slot |
| `return`, `return x` | return |

Operands are: temporaries `tN`, local/parameter names, global names, integer/float literals,
`strN` (address of a string literal), `vtable_X` (address of a vtable), function names
(address of a function, used when a function is stored in a pointer).

Sizes: `char`/`bool` 1, `short` 2, `int`/`long`/`float`/pointers/enums 4, `double` 8. Struct
fields are aligned to their size (max 4) and struct sizes are rounded up to 4. Union fields all
sit at offset 0.

## Feature lowering

| Feature | Lowering |
|---|---|
| Arithmetic, bitwise, relational | one temp per operation; scalar operands are converted to the common FNS type; pointer `+`/`-` is scaled by the pointee size |
| `&&`, `\|\|`, `?:` | short-circuit jumps into a temp |
| Compound assignment, `++`/`--` | address computed once, then load, op, store |
| `if`/`else`, `while`, `for`, `do-while`, `do-until` | labels and conditional jumps; `until` jumps back while the condition is false |
| `switch` | compare chain `t = sw == v; if t goto Lcase` then labelled bodies; fallthrough preserved; the body is one scope |
| `break`/`continue`/`goto`/labels | loop-label stack; user labels emitted verbatim |
| Arrays (1-D, N-D) | row-major address arithmetic from the element size |
| Variable-length arrays | `v__size = n * elem`; `t = call malloc, 1`; `v = t`; `param v` / `call free, 1` at block exit; `sizeof v` reads `v__size` |
| Designated initialisers | the object is zeroed, then each designated element/member is stored at its offset |
| Bit-fields | read: `t = *unit`, `t = t << (32 - pos - width)`, `t = t >> (32 - width)` (arithmetic for signed fields); write: load the unit, `& ~mask`, `\|` the shifted value, store |
| Pointer to array `int (*p)[N]` | a pointer variable typed `int[N]*`; `p + i` is scaled by the row size |
| Pointers, multi-level pointers | `&`/`*` chains |
| References | hidden pointers: declaration stores an address, every use loads through it, callers pass `&x` |
| `struct`/`union`/`enum`/`typedef` | field offsets; union offsets 0; enumerators are constants |
| Functions, prototypes, recursion | `param` list then `call`; prototypes register signatures first |
| `printf`, `scanf`, `malloc`, `fopen`, ... | library functions; their prototypes come from the prelude and they are listed under `.extern`; the back end links the runtime functions the program uses |
| Variadic functions | all arguments pushed; `call f, n` carries the count; `va_start` is `t = &__va_args` (address of the first unnamed argument), `va_arg` is pointer arithmetic on that address |
| `static` | static locals become globals named `function_variable` |
| Function pointers | `p = f` stores the label; `x = call *p, n` |
| Classes, access specifiers | members laid out after base-class fields; instance methods become `Class_method(this, ...)`; static members omit `this`; public/private/protected access is checked |
| Constructors, initialiser lists, destructors | `Class_Class(this, ...)`; bases and members initialize in declaration order; delete calls class destructors and frees storage |
| Inheritance, `virtual` | vptr at offset 0; `vtable_X` in `.data`; a virtual call loads the vptr, loads the slot, then `call *t` |
| Object construction `Circle c = Circle(2.5)` | constructed in place; other aggregate assignments use `copy` |
| `new`/`delete` | `t = call __fns_new, 3` (count, element size, header: 0 for `new T`, 4 for `new T[n]`, which stores the count) — `malloc` that aborts like an uncaught `std::bad_alloc` on failure; constructors run for objects and each `new T[n]` element; `delete[]` destroys elements in reverse order |
| Lambdas | emitted as `lambda_N`; captured variables become trailing parameters, copied (`[=]`) or taken by address (`[&]`) into hidden locals at the point of creation; a `mutable` lambda's copies live in `lambda_N_cap_x_copy` and the lambda receives their address |
| `argc`/`argv` | ordinary parameters of `main`; the back end stores spim's `$a0`/`$a1` into them |
| Global initialisers | constants go into `.data`; non-constant initialisers and global constructors run in `__global_init`, called at the top of `main`; destructors of global objects run in `__global_fini`, which `main` registers as the first exit handler; the exit handlers run before each `return` of `main` (`call __fns_run_atexit`) and in `exit()` |
| Block scoping | shadowed locals get unique IR names (`i`, `i_1`) |
| Overloading | each overload gets its own IR name: `f`, `f__1`, `f__2`, …; methods `Class_m__1`; constructors `Class_Class__1` |
| Default arguments | the call site appends the default expressions as ordinary `param`s |
| Copy / move constructor | `T b = a;` and by-value arguments call `Class_Class__k(&dst, &src)` instead of `copy`; `std::move(a)` selects the `T(T&&)` overload |
| Rvalue references | like references (an address); a temporary bound to `T&&` is stored in a hidden local first |
| `new` failure, `fseek` | library calls (`__fns_new`, `fseek`): the IR only shows the call |
| Scope-exit destructors | `param &obj` / `call Class__dtor, 1` emitted at block end, `return`, `break`, `continue`, and before a `goto` for the blocks it leaves, in reverse declaration order |
| Static locals with a non-literal initializer, static local objects | guarded by a hidden global `fn_name_var__guard`; initialised the first time control reaches the declaration; an object then registers its destructor with `call __fns_atexit, 2` |
| Range `for` | hidden index loop `range_i` over the array address `range_base` |
| `enum class` | scoped enumerators are integer constants, like plain enumerators |

## Optimisation

The IR that `--print-ir` / `--emit-ir` show has been optimised by
`src/optimize.cpp`; `-O0` shows the direct lowering described above. Per function,
until nothing changes:

| Rewrite | Example |
|---|---|
| constant folding | `t = 3 * 4` → `t = 12`; `if 0 goto L` → removed; `ifFalse 0 goto L` → `goto L` |
| constant propagation (per basic block) | `n = 4; t = n * k` → `t = 4 * k` |
| copy propagation | `t1 = a; t2 = t1 + 1` → `t2 = a + 1`; `t = e; v = t` → `v = e` |
| strength reduction | `x * 2^k` → `x << k`; unsigned `x / 2^k` → `x >> k`, `x % 2^k` → `x & (2^k - 1)`; `x * 1`, `x + 0`, `x / 1` → `x`; `x * 0` → `0` |
| dead temporaries | a temporary that is no longer read loses its definition (calls stay) |

Only names whose address is never taken (locals, parameters, temporaries) are
propagated, only between operands of identical type, and folding uses the same
32-bit arithmetic as the generated MIPS code. Signed division keeps `div`.

## IR naming

- Locals keep their source name; a shadowing declaration in an inner block gets a numeric
  suffix (`i`, `i_1`, `i_2`).
- Temporaries are `t1, t2, ...`, numbered per function.
- Generated labels are `L1, L2, ...`, numbered per function. User labels are emitted verbatim.
- Methods are `Class_method`, constructors `Class_Class`, destructors `Class__dtor`,
  lambdas `lambda_N`, static locals `function_variable`, string literals `strN`, vtables
  `vtable_Class`, the global initialiser `__global_init`.
- User variables spelled like IR temporaries or string labels (`t1`, `str0`) get a `_v`
  suffix (`t1_v`) so they cannot be confused with them.
- Parameters, locals and globals print as `name : type (size)`. Reference-typed names print
  with `&` (`Vec& v`) but occupy 4 bytes (a pointer).
