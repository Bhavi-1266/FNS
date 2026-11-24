# FNS — End-to-End Compiler (C / C++ subset → MIPS32 assembly)

`fnsc` compiles programs written in **FNS** (*Friendly Neighbourhood Spiderman*), a
C-like source language that also accepts a large subset of C++ (classes, inheritance,
virtual functions, references, lambdas, overloading, `new`/`delete`) plus the FNS
`do … until` loop, into a **MIPS32 assembly file**.

```
source.c / source.cpp
   │  preprocessor (#define, #if, macros)          src/preprocess.cpp
   │  lexer (flex)                                 src/lexer.l
   │  parser (bison, LALR(1), builds the AST)      src/parser.y
   │  semantic analysis + 3-address code (IR)      src/codegen.cpp
   │  MIPS32 back end                              src/mips.cpp
   │  + runtime library (only the parts used)      src/lib/libfns.c, src/runtime.s
   ▼
program.s   ──►  spim -file program.s [arguments]
```

**[FEATURES.md](FEATURES.md)** explains every feature and how it is implemented,
with IR and MIPS examples.

## Simulator required to run the output

> **Required simulator: James Larus' SPIM, MIPS32.** The recommended target is
> **SPIM Version 8.0 on Linux** (`sudo apt-get install spim`). Run a compiled program
> with `spim -file program.s [program arguments]`. Output uses SPIM system calls and
> fits its default 64 KB text segment. The runtime chooses Linux or macOS `open(2)`
> flags when `fnsc` is built, so build and run the assembly on the same host OS.
> macOS SPIM 9.1 has a command-line argument limitation: it drops arguments after
> `-file`. The test harness detects this and supplies equivalent startup registers
> for the `argc`/`argv` regression test. Programs that need command-line arguments
> should use the recommended Linux SPIM 8.0 setup.

The generated assembly is self-contained: the C library (printf, scanf, files,
strings, malloc, math, …) is part of every output file, and only the library
functions a program actually uses are included.

---

## 1. Build

Prerequisites: `g++` (C++17), `flex`, `bison` 3.x, GNU `make`; `spim` to run programs.

```bash
sudo apt-get install -y g++ make flex bison spim
make            # builds ./fnsc
make test       # builds and runs every test: PASS/FAIL on the terminal; each test's 3AC IR,
                #   program output and the results are saved in test/output/test_results.txt
make check      # the same tests, PASS/FAIL lines only
make run FILE=prog.c   # compile one file, print its IR and assembly, run it on spim
make clean
```

The build has two stages (see `makefile`): a bootstrap compiler `build/fnsc-boot`
compiles the runtime library `src/lib/libfns.c` (written in FNS itself) to
`src/lib/libfns.s`; the final `./fnsc` embeds that assembly.

## 2. Using the compiler

```
fnsc <source.c|source.cpp> [options]
  -o FILE           write the assembly to FILE            (default: <stem>.s)
  --emit-ir [FILE]  also write the three-address code IR   (default: <stem>.ir)
  --print-ir        print the three-address code on standard output
  -E                print the preprocessed source and stop
  --runtime         compile the runtime library (used by the makefile)
```

Examples:

```bash
./fnsc test/09_functions_recursion.c -o fact.s       # compile
spim -file fact.s                                      # run
./fnsc test/16_classes.cpp --print-ir                  # show the 3AC IR on the terminal
./fnsc test/16_classes.cpp --emit-ir classes.ir        # save the IR in a file
./fnsc test/20_command_line.c -o args.s && spim -file args.s add 2 3
make run FILE=test/03_loops.c                          # prints the IR and assembly, then runs it
make run RUN=test/20_command_line.c ARGS="add 2 3"     # RUN= works too; ARGS = program arguments
```

`.c` files are compiled as C (no overloading; C++-only keywords such as `new`,
`class`, `delete` are ordinary identifiers); `.cpp`/`.cc` files as C++.
Exit status: `0` success, `1` the program has errors (they are printed with line
numbers and no assembly is written), `2` usage / file errors.

## 3. Tests — `run.sh`

```bash
./run.sh ./fnsc                 # every test; prints PASS/FAIL and a summary
./run.sh ./fnsc --show-ir       # also prints the three-address code of each test
./run.sh ./fnsc --show-ir --log test/output/test_results.txt
                                # what `make test` runs: everything saved in the log,
                                #   PASS/FAIL lines on the terminal
./run.sh ./fnsc 16_classes      # only tests whose name contains the filter
SIM=/path/to/spim ./run.sh ./fnsc
```

For each program `test/NN_name.c|cpp`, `run.sh`:

1. compiles it, writing **`test/output/NN_name.s`** (MIPS) and **`test/output/NN_name.ir`** (3AC IR);
2. runs it on spim in `test/output/run/` with stdin from `test/input/NN_name.in` and
   arguments from `test/args/NN_name.args` when present;
3. saves the output to `test/output/NN_name.out` and compares it with
   `test/expected/NN_name.expected`.

Every program in `test/errors/` must be **rejected**; its diagnostics are saved in
`test/output/errors/` and compared with `test/errors/expected/`.

The expected outputs were produced by **gcc/g++**, not by fnsc
(`tools/make_expected.sh` regenerates them; `until` is compiled there as
`while(!(…))`), so every passing test means fnsc + spim printed exactly what the
native C/C++ compiler printed.

| Test | Features covered |
|---|---|
| `01_operators.c` | all arithmetic, relational, logical (short-circuit), bitwise, shift, assignment, `++`/`--`, `?:`, comma operators; precedence; unsigned wrap; char escapes |
| `02_if_else.c` | if / else-if chains, nesting, dangling else, conditions of type double/char/pointer |
| `03_loops.c` | for (all parts optional), while, do-while, nested loops, loop-scoped variables |
| `04_switch.c` | switch: fallthrough, default in the middle, nested, char/enum/negative/expression labels, one scope for the whole body |
| `05_arrays.c` | int and char arrays, partial init, inferred size, sorting/searching, strings, arrays of strings, designated initializers, variable-length arrays |
| `06_pointers.c` | pointers, arithmetic, comparison, `void*`, NULL, `**`, `***`, pointers to structs, `int**` jagged arrays |
| `07_structs.c` | structs, nested structs, arrays of structs, by-value/return, copy, typedef struct, linked nodes, designated initializers, bit-fields |
| `08_printf_scanf.c` | printf (all conversions, flags, width, precision, `*`), scanf (ints, chars, strings, float/double, hex/octal, EOF), sprintf, sscanf |
| `09_functions_recursion.c` | prototypes, many/mixed arguments, recursion (factorial, fibonacci, gcd, power, hanoi, ackermann, permutations, binary search), mutual recursion |
| `10_goto_break_continue.c` | goto forward/backward/out of nested loops, break and continue in every loop and in switch |
| `11_static.c` | static locals (incl. in recursion), static globals and functions, static arrays |
| `12_function_pointers.c` | function pointers, typedef'd, arrays of them, callbacks, returning them (also without a typedef), pointers to function pointers, qsort comparators |
| `13_varargs.c` | variable-argument functions with `va_list`/`va_start`/`va_arg`/`va_end`, `vprintf` |
| `14_dynamic_memory.c` | malloc/calloc/realloc/free, dynamic arrays/strings/2-D arrays, linked list, stack, BST, allocation failure |
| `15_lambda.cpp` | lambdas: captures by value/reference/`[=]`/`[&]`/mixed, immediate call, callbacks, deduced return types, `mutable` |
| `16_classes.cpp` | classes and objects, constructors (overloaded, default, init lists, out-of-class, delegating), destructors at scope exit, static members, `this`, object arrays, `new`/`delete`, nested classes and enums |
| `17_inheritance.cpp` | single and multi-level inheritance, virtual functions, abstract classes, `Base::f()`, virtual destructors, polymorphism through pointers and references |
| `18_access_specifiers.cpp` | public / private / protected members and private / protected inheritance (violations are in `test/errors/e05_access.cpp`) |
| `19_references.cpp` | reference variables, pass/return by reference, const references, references to objects and pointers, rvalue references, `std::move`, move constructor |
| `20_command_line.c` | command-line input: `argc`, `argv` (arguments in `test/args/`) |
| `21_file_io.c` | file manipulation: fopen modes, fprintf/fscanf, fgets/fputs, fgetc/fputc, fread/fwrite, feof, append, fseek/ftell/rewind |
| `22_typedef_enum_union.c` | typedef (scalars, pointers, arrays, structs, function pointers), enum, union, tagged unions |
| `23_multidim_arrays.c` | 2-D/3-D arrays, nested/flat/partial initialisers, matrix multiply, arrays passed to functions |
| `24_until_loop.c` | the FNS `do … until (cond);` loop |
| `25_preprocessor.c` | `#define` (objects, functions, `#`, `##`), `#if/#ifdef/#elif/#else/#undef`, NULL/EOF/INT_MAX |
| `26_string_library.c` | string.h, ctype.h, stdlib.h functions of the runtime |
| `27_overloading.cpp` | function, method and constructor overloading |
| `28_floating_point.c` | float/double arithmetic, comparisons and conversions |
| `29_oop_mixed.cpp` | classes, inheritance, virtual dispatch, dynamic objects |
| `30_interactive_io.c` | reading from stdin with scanf / getchar |
| `31_object_lifetime.cpp` | copy constructors, by-value objects, default arguments, global and static-local objects (first-use initialisation, destruction order, `exit()`), destructors on `goto` |
| `32_modern_cpp.cpp` | range-based `for` over arrays, `enum class` |
| `33_array_pointer_arith.c` | multi-level pointers into multi-dimensional arrays `*(*(a+i)+j)`, pointer-to-array variables `int (*p)[4]`, casts to typedef/enum names, constant-expression array bounds |
| `errors/e01_syntax.c` … `e06_switch_scope.cpp` | syntax errors, undeclared names / wrong argument counts / undefined functions, type errors, misplaced break/continue/goto/duplicate case/const assignment, access-control violations (also through private/protected bases), a case label that jumps past an initialisation |

Other checks: `tools/gate.sh` (grammar has 0 conflicts; the earlier-phase IR test
programs in `test/ir_phase/` still compile; IR structure checks; 67 expected
semantic errors), `tools/check_long_functions.py` (every function longer than 30
lines has a comment).

## 4. Feature checklist

| Required feature | Status | Test |
|---|---|---|
| All arithmetic and logical operators | ✔ | 01 |
| if-else | ✔ | 02 |
| for / while / do-while loops | ✔ | 03 |
| switch cases | ✔ | 04 |
| arrays (integer and char) | ✔ | 05, 23 |
| pointers | ✔ | 06, 33 |
| structure | ✔ | 07 |
| printf and scanf | ✔ | 08, 30 |
| function call with arguments | ✔ | 09 |
| goto, break, continue | ✔ | 10 |
| static keyword | ✔ | 11 |
| Recursive function call | ✔ | 09 |
| Class and object | ✔ | 16, 29, 31 |
| Inheritance | ✔ | 17 |
| Function call with variable arguments | ✔ | 13 |
| Dynamic memory allocation | ✔ | 14, 16 |
| Lambda function | ✔ | 15 |
| Function pointer | ✔ | 12 |
| Command line input | ✔ | 20 |
| public, private and protected | ✔ | 18, errors/e05 |
| typedef | ✔ | 22 |
| Reference | ✔ | 19 |
| enum, union | ✔ | 22, 32 |
| File manipulation | ✔ | 21 |
| until loop | ✔ | 24 |
| Multi-level pointers | ✔ | 06, 33 |
| Multi-dimensional arrays | ✔ | 23, 33 |
| Also | preprocessor macros, function/constructor overloading, default arguments, copy/move constructors, delegating constructors, destructors at scope exit, range-for, `enum class`, designated initializers, bit-fields, variable-length arrays, nested classes, rvalue references, `mutable` lambdas, string/ctype/stdlib/math library | 05, 07, 15, 16, 19, 25–27, 31–32 |

## 5. Three-address code (IR)

Every program is lowered to a textual three-address code before code generation
(`--emit-ir`, `--print-ir`, and `test/output/*.ir`). Example (from `test/09`):

```
function gcd(int a, int b) : int
    t1 = b == 0                          ; int
    ifFalse t1 goto L1
    t2 = a                               ; int
    goto L2
L1:
    t3 = a % b                           ; int
    param b
    param t3
    t4 = call gcd, 2                     ; int
    t2 = t4                              ; int
L2:
    return t2                            ; int
endfunction
```

Instructions: `x = y`, `x = y op z`, `x = op y`, `x = &y`, `x = *y`, `*x = y`,
`x = (type) y`, `copy dst, src, n`, labels, `goto L`, `if x goto L`,
`ifFalse x goto L`, `param x`, `call f, n`, `x = call f, n`, `x = call *p, n`,
`return [x]`. Every value-producing instruction carries its type after `;`.
Sections: `.data` (strings, globals, vtables), `.extern` (library functions
used), `.text`. Full format and the lowering of each construct:
[`docs/IR_LANGUAGE_REFERENCE.md`](docs/IR_LANGUAGE_REFERENCE.md).

## 6. Source layout

| Path | Contents |
|---|---|
| `src/preprocess.{hpp,cpp}` | preprocessor: macros, conditionals, built-in prelude (`FILE`, `va_list`, `size_t`, library prototypes) |
| `src/lexer.l` | flex scanner (fuses `Class::member` into one token) |
| `src/parser.y` | bison grammar (0 conflicts) building the AST (`src/ast.hpp`) |
| `src/codegen.{hpp,cpp}` | semantic analysis and IR generation: scopes, types, class layout, vtables, overloading, constructors/destructors, lambdas |
| `src/ir.{hpp,cpp}` | IR data structures and printer |
| `src/mips.{hpp,cpp}` | IR → MIPS32 back end, linking of the used runtime functions |
| `src/lib/libfns.c` | the C runtime library, written in FNS and compiled by fnsc |
| `src/runtime.s` | the only hand-written assembly: spim system-call stubs |
| `src/main.cpp` | command-line driver |
| `src/decl_table.*`, `symbol_table.*` | lexer type-name tracking and front-end diagnostics |
| `test/` | test programs, `input/`, `args/`, `expected/`, `errors/`, `ir_phase/` (earlier-phase IR tests) |
| `run.sh`, `makefile`, `tools/` | test harness, build, helper scripts |

## 7. How the generated code works

* **Calling convention.** Arguments are pushed on the stack left to right (arg 0 at
  the lowest address; a `double` takes two words); the callee uses them in place;
  results return in `$v0` (integers, pointers) or `$f0` (float/double); the caller
  pops the arguments. `$fp` addresses the frame; `$ra` and the old `$fp` are saved.
* **Storage.** Every local and IR temporary has a stack slot; a temporary that is
  used only by the next instruction is kept in a register instead.
* **Objects.** Fields are laid out in declaration order (base-class fields first);
  a class with virtual functions has a vtable pointer at offset 0 and a
  `vtable_Class` table in `.data`; virtual calls load the function from it.
* **Names.** User symbols are emitted as `U_name`, library symbols as `R_name`, so
  user functions called `add`, `move`, `abs`, `strlen`… never clash with MIPS
  mnemonics or the library.
* **Runtime.** printf/scanf/file functions are implemented in C (`src/lib/libfns.c`)
  on top of spim system calls: console output uses `print_char`, console input
  `read(0)` (so end of input is detected), files use spim's `open/read/write/close`
  system calls with host `O_*` flags.
* **Speed.** spim executes roughly 1.5 million MIPS instructions per second, and
  generated loops take about 10–20 instructions per iteration, so a loop of 10⁶
  iterations runs for several seconds in the simulator.
* **Program start/exit.** spim's start-up code calls `main` with `argc`/`argv`;
  `main` first runs the dynamic global initialisers (and global constructors) and,
  before returning, the destructors of global and static objects.

## 8. Runtime library

Declare nothing yourself: `#include` lines are accepted and ignored, and the
prototypes of these functions are supplied automatically.

| Header | Functions |
|---|---|
| stdio | `printf scanf sprintf snprintf sscanf fprintf fscanf vprintf vfprintf vsprintf vsnprintf putchar getchar puts fopen fclose fseek ftell rewind fputc putc fgetc getc ungetc fputs fgets fread fwrite feof ferror fflush remove`, `stdin stdout stderr`, `FILE`, `EOF`, `SEEK_SET SEEK_CUR SEEK_END` |
| stdlib | `malloc calloc realloc free exit abort abs labs atoi atol atof strtol strtod rand srand qsort bsearch`, `NULL`, `RAND_MAX`, `EXIT_SUCCESS/FAILURE` |
| string | `strlen strcpy strncpy strcat strncat strcmp strncmp strchr strrchr strstr strdup strtok strspn strcspn strpbrk memset memcpy memmove memcmp` |
| ctype | `isdigit isalpha isalnum isspace isupper islower ispunct isxdigit isprint toupper tolower` |
| math | `sqrt pow fabs floor ceil round fmod exp log log10 sin cos tan fmax fmin`, `M_PI`, `M_E` |
| stdarg | `va_list va_start va_arg va_end va_copy` |
| limits | `INT_MAX INT_MIN UINT_MAX LONG_MAX LONG_MIN SHRT_MAX SHRT_MIN CHAR_MAX CHAR_MIN UCHAR_MAX CHAR_BIT` |
| time | `time` (always returns 0: spim has no clock) |

printf/scanf support `d i u x X o c s f F e E g G p n %`, flags `- + space # 0`,
width and precision (also `*`), and length modifiers `hh h l ll L z` (all integers
are 32-bit, see below). `%f`/`%e`/`%g` round like glibc for the usual precisions
(up to about 15 significant digits; exact halfway cases are rounded to even as glibc
does); beyond that the last digits can differ.
`rand()`/`srand()` produce exactly glibc's sequence.

## 9. Differences from C and C++

FNS behaves like C (for `.c`) or C++ (for `.cpp`) except for the points below.

### 9.1 Preprocessor and program structure

| Topic | FNS | C / C++ |
|---|---|---|
| `#include` | Accepted and ignored; no header file is read. The library is built in and its prototypes, `FILE`, `va_list` and `size_t` are declared automatically. A program can therefore not include its own header files. | Reads the header. |
| Macros | `#define` (object-like and function-like, `#`, `##`, variadic `__VA_ARGS__`), `#undef`, `#if/#ifdef/#ifndef/#elif/#else/#endif` with `defined`, `__LINE__`, `__FILE__`, `__cplusplus` (C++ files) are supported. `__DATE__`, `__TIME__`, `__func__`, `#pragma`, `#line` are not (directives are ignored). | Full preprocessor. |
| Translation units | One source file per program; no linking of several files, so `static` on globals/functions has no visible effect and `extern` is not a keyword. | Separate compilation. |
| Keywords | `int float double char void bool long short unsigned signed auto const static typedef struct union enum class public private protected virtual mutable if else for while do until switch case default break continue goto return new delete sizeof true false nullptr`. In `.c` files `class public private protected virtual mutable new delete` are ordinary identifiers. `this` is an implicitly declared name, not a keyword. `extern register volatile inline constexpr namespace template using operator friend try catch throw explicit override final` are **not** supported (using them is a syntax error); `mutable` is accepted on lambdas only, not on data members. | More keywords. |
| `until` | FNS-only keyword: `do { … } until (cond);` repeats while `cond` is false. Cannot be used as a name. | Not in C/C++. |

### 9.2 Types

| Topic | FNS (MIPS32) | Typical gcc/g++ on x86-64 |
|---|---|---|
| Sizes | `char`/`bool` 1, `short` 2, `int` 4, **`long` 4, `long long` 4**, `float` 4, `double` 8, `long double` 8, pointers and references 4, enums 4 | `long`/`long long`/pointers 8, `long double` 16 |
| 64-bit integers | Not available: `long long`/`%lld` are 32-bit; literals that do not fit in 32 bits are truncated. | 64-bit |
| `char` | signed | signed |
| Struct layout | members aligned to their size (max 4), size rounded to 4; `double` members are 4-aligned. | `double` 8-aligned |
| Bit-fields | `unsigned a : 3, b : 5; int level : 4; unsigned : 2; int : 0;` in structs, unions and classes, laid out like gcc (a field never straddles a unit of its declared type; a plain `int` bit-field is signed). Reading, assignment, compound assignment, `++`/`--`, brace/designated/constructor initialisation work; `&` of a bit-field is an error. Not supported: a bit-field as the last step of a chained designator (`.flags.ready = 1`). | same |
| Integer conversions | simplified fixed-width model; pointer ↔ integer conversions are implicit (no cast needed); pointer-to-pointer type mismatches are not diagnosed | stricter |
| `const` | const objects are checked; constness of a pointer itself (`T *const`) is not tracked | full |
| `auto` | deduces the type of a local from its initializer (never a reference or array); `auto` variables holding lambdas | full |
| Arithmetic | integer division by zero is not trapped (spim leaves the result undefined); overflow wraps | UB |

### 9.3 Declarations and initialisation

| Topic | FNS | C / C++ |
|---|---|---|
| Array bounds | Integer constant expressions (literals, enumerators, macros, `const int` variables with constant initializers, `sizeof`, arithmetic on these), except that a local array's **first** bound may be any expression: a variable-length array `int v[n]`, `char t[rows][4]` (also accepted in `.cpp` files, as g++ does). Its storage comes from `malloc` and is freed when the block ends (not when a `goto` jumps out of it); `sizeof` gives its run-time size; it cannot have an initializer. An array parameter's first bound may name another parameter (`int a[n]`). Global, static and inner (second and later) bounds must be constant. | C99 VLAs (stack) |
| Initialisers | Nested, flat (brace elision), partial and trailing-comma lists; strings for char arrays; `T x(args)`, `T x{args}`. Designated initialisers: `{[2] = 5}`, `{.x = 1}`, chains `{.lo.x = 0}`, `{[1][2] = 3}`, `{[2].y = 4}`, in any order, with later items continuing after the designated one; an array index must be an integer/character literal, arithmetic on literals (macros expand to literals), a parenthesised constant expression, or a single enumerator/const name (`[RED + 1]` without parentheses is not accepted). Compound literals are not supported; braces are only allowed in declarations (`x = {1,2}` is an error). | supported |
| Parenthesised declarators | `int (*p)[3]` (pointer to an array, also as a parameter or typedef), `int (**pp)(int)`, `int (*ops[4])(int)`, and functions returning function pointers `int (*pick(char c))(int, int)` are supported. Declarators nested more than one level of parentheses (`int (*(*f)(int))[3]`, `int (*(*pf))(int)`) and pointers to pointers to arrays (`int (**p)[3]`) are not: use a typedef. | supported |
| Old-style (K&R) definitions | not supported | C89 |
| Prototypes | optional (all signatures are collected first) | required before use |
| Global initialisers | constants are placed in `.data`; any other initializer (including global objects with constructors) runs at the start of `main`, in source order | static initialisation |
| Static local initialisers | a literal goes into `.data`; any other initializer runs once, the first time control reaches the declaration (C++ semantics). In C files this also accepts a non-constant initializer (`static int x = n;`), which C rejects. | C: constant only |

### 9.4 Expressions and statements

| Topic | FNS | C / C++ |
|---|---|---|
| **Evaluation order** | **Strictly left to right**: operands, function arguments and initializers. E.g. `printf("%d %d", f(), f())` calls the first `f()` first. gcc evaluates arguments right to left on x86-64, so a program whose output depends on this order prints differently. | unspecified |
| Struct values | assignment, pass and return by value, and members of a returned struct (`f().x`, `f().a[i]`) | same |
| `switch` | compiled as a comparison chain; labels must be integer constant expressions. The body is one scope (a variable declared under one case can be used under a later one); in C++ a case label that jumps past an initialised declaration is an error, as in g++. The body must be a `{ }` block that starts with a `case`/`default` label (no statements before the first label, no unbraced `switch (x) case 1: …`). | jump table; any statement as body |
| `goto` | a `goto` out of blocks runs the destructors of the objects in the blocks it leaves, as in C++; a backward `goto` within one block to a label before an object's declaration does not destroy that object, and jumping into a block past a declaration is not diagnosed | same; both cases handled |
| Comma, `?:`, `&&`, `\|\|` | as in C | |

### 9.5 Functions

| Topic | FNS | C / C++ |
|---|---|---|
| Variadic functions | `stdarg.h` works; `va_arg(ap, char)`/`short`/`float` read the promoted `int`/`double` slot as C requires the caller to pass. | same |
| Overloading | C++ files: functions, methods and constructors can be overloaded by parameter count/types; the best match prefers exact matches, then promotions (`char`/`short`/`bool` → `int`, `float` → `double`), then conversions. Methods that differ only in `const` are not overloads. C files: a second definition with another signature is an error. Operator overloading is not supported. | full rules |
| Default arguments | C++ files: supported on functions, methods and constructors | same |
| `main` | `int main()`, `int main(void)`, `int main(int argc, char *argv[])`. The value returned by `main` is **not** the simulator's exit status (spim always exits with 0); `exit(n)` does set it. `argv[0]` is the assembly file name given to spim. | return value = exit status |
| Library functions | always available without declarations; a user function with the same name (e.g. its own `strlen`) replaces the library one for that program | must be declared |

### 9.6 C++ classes and objects

| Topic | FNS | C++ |
|---|---|---|
| Classes | `class`/`struct` with fields, methods (in-class or out-of-class `R C::f() {…}`), constructors with initializer lists, destructors, static data members and static methods, `this`, const methods, nested classes/structs/enums (`Outer::Inner`, `Outer::VALUE`). A nested type's name is also visible without `Outer::` (C++ requires the qualification outside the class), a nested class gets no special access to the outer class's private members, and its methods must be defined inside it. | full |
| Access control | `public`/`private`/`protected` checked, including the protected rule for derived classes; `friend` is not supported | + friend |
| Inheritance | single inheritance (multi-level allowed) for `class` and `struct`, with `public`, `protected` or `private` base access (default: `private` for a class, `public` for a struct), enforced as in C++ (including conversion to an inaccessible base). Multiple and virtual inheritance are not supported. | all |
| Virtual functions | vtable dispatch; pure virtual functions; virtual destructors. Instantiating an abstract class is not rejected (calling the pure function prints `pure virtual method called` and stops). | abstract classes rejected |
| Constructors | overloads, default arguments, initializer lists, `T x(args)`, `T x{args}`, `T x = T(args)`, `new T(args)`, arrays of objects (default constructor), delegating constructors (`A() : A(0)`, which must be the only initializer). | full |
| Converting constructor | a constructor taking one argument is used implicitly: `V v = 7;`, `f(8)` for a `V` or `const V&` parameter. `explicit` is not supported. | same |
| Copy constructor | used for `T b = a;`, `T b(a);` and passing a named object by value (`std::move(a)` uses the move constructor `T(T&&)` when there is one). A temporary (e.g. the result of a call, `T b = make();`) is moved with a byte copy, which matches the copy elision g++ performs. Returning an object by value and assignment `b = a` copy the bytes (no `operator=`). | always used (elided for temporaries) |
| Destructors | run at the end of each block, on `return`, `break` and `continue`, for temporaries (`Point(1, 2)`, objects returned by value, by-value argument copies) at the end of the statement, for `delete`/`delete[]`, and for global and static-local objects when `main` returns or `exit()` is called, in reverse order of construction (static locals register their destructor when they are constructed, as C++ runtimes do with `__cxa_atexit`). Temporaries created in the condition of `if`/`while`/`for` are destroyed after the whole statement. A `goto` out of blocks also runs them (see `goto` in 9.4). | full |
| References | lvalue references (variables, parameters, returns, members), including `return a > b ? a : b;` from a function returning `int&`; rvalue references `T&&` for variables and parameters (they bind temporaries and `std::move(x)`, binding a named variable is an error; overloads on `T&` / `T&&` pick by value category); move constructors `T(T&&)` run for `T b = std::move(a)` and for `std::move(a)` passed by value. `std::move` is the only `std::` function (a builtin); there is no `std::forward`, move assignment (`operator=`) or function returning `T&&`. | full |
| Lambdas | captures by value/reference, `[=]`, `[&]`, mixed lists; return type deduced from the first `return` when `->` is omitted; `mutable` lambdas (copies captured by value can be changed and keep their value between calls); changing a by-value capture in a lambda that is not `mutable` is an error, as in C++. A capture-free lambda converts to a function pointer; a capturing lambda cannot be passed as a function pointer or stored except in an `auto` variable. Generic (`auto` parameter) lambdas are not supported. | closures |
| `enum class` | supported (values written `Color::Red`); the enumerators are also visible unqualified | scoped only |
| Range `for` | `for (T x : array)`, `for (auto &x : array)` over arrays of known size | any range |
| Casts | C casts, functional casts `int(x)`, and `static_cast<T>(x)`, `const_cast`, `reinterpret_cast` (all behave as the C cast). `dynamic_cast` is accepted with the same meaning (no run-time check). | checked casts |
| Not supported | templates, namespaces/`using`, exceptions, operator overloading, the `std::` library apart from `std::move` (`iostream`, `cout`, `cin`, `string`, `vector`, …), RTTI/`typeid` | |

### 9.7 Library and I/O

| Topic | FNS | C |
|---|---|---|
| Console | `stdin`, `stdout`, `stderr` all use spim's console; output is unbuffered (no `fflush` needed) | buffered streams |
| Files | `fopen` modes `r w a r+ w+ a+` (`b` ignored); paths are relative to the directory spim runs in. `fseek`/`ftell`/`rewind` work (`SEEK_SET`/`SEEK_CUR`/`SEEK_END`); spim has no seek system call, so `fseek` reopens the file and reads forward to the position, which takes time proportional to the offset, and seeking past the end stops at the end. `remove()` always returns -1 (no delete system call). | full |
| `time()` | returns 0 | wall clock |
| Math | computed by the library in double precision (sqrt uses the FPU); results may differ from glibc in the last digits | libm |
| Memory | `malloc` gets memory with spim's `sbrk`; freed blocks are reused; a failing `new` (negative array length, no memory) prints g++'s `terminate called after throwing an instance of 'std::bad_alloc'` message and aborts (there are no exceptions to catch); memory errors (double free, out-of-bounds) are not detected; a null or invalid dereference makes spim print an exception message (`Bad address in data/stack read`) and continue | |

### 9.8 Limits of the spim simulator (default settings)

| Resource | Limit | Effect |
|---|---|---|
| Code (text segment) | 64 KB (16K instructions) | the program plus the library functions it uses; typical programs use 5–10K instructions. A very long program (roughly 700+ lines of straight-line code) can exceed it: fnsc then prints a warning and the program must be run with `spim -stext 262144 -file prog.s` |
| Static data (`.data`) | about 192 KB | uninitialised global arrays/objects larger than 32 KB are therefore allocated on the heap when `main` starts (transparent to the program) |
| Data + heap | about 1 MB | beyond this spim stops the program with `Can't expand data segment` (the library cannot ask spim for the limit, so `malloc` returns `NULL` only for sizes larger than the address space, and `calloc` also when `n * size` overflows); e.g. a global `int a[250000]` does not fit |
| Stack | about 512 KB (≈260 KB usable) | recursion of about 9,000 levels for a small function; local arrays of more than ~250 KB do not fit |
| Speed | ~1.5 million instructions per second | a loop of 10⁶ iterations takes several seconds |

These are spim's defaults; `spim -ldata <bytes> -lstack <bytes> -file prog.s` raises them.

## 10. Diagnostics

Lexical, syntax and semantic errors are reported with line numbers (the parser
recovers and reports several errors per file). Semantic checks include:
undeclared identifiers, redeclarations, type mismatches in assignment /
initialisation / arguments / return, `void` values, invalid operands, non-scalar
conditions, wrong argument counts, ambiguous or unmatched overloads, calls to
functions that exist nowhere ("undefined reference"), const assignment, array
assignment, break/continue outside loops, goto to missing labels, duplicate case
labels, non-integer switch/case, access violations (including members reached
through a private or protected base, and conversion to an inaccessible base),
missing default constructors, reference binding errors, non-constant array bounds.
A construct the compiler cannot translate is always an error: no assembly is
written for it. See `test/errors/` and `test/ir_phase/semantic_*` for examples.
