/* ===========================================================================
 * libfns.c - the FNS runtime library.
 *
 * Written in the FNS language and compiled to MIPS by the compiler itself:
 *     fnsc --runtime src/lib/libfns.c -o src/lib/libfns.s
 * The makefile embeds the result in fnsc, which appends it to every program.
 * Its symbols are emitted as R_<name>, so a user program may define its own
 * function called e.g. `strlen` without clashing with the library.
 *
 * Only the __sys_* functions are hand-written assembly (src/runtime.s).
 * Rules for this file: no dynamic global initialisers (there is no main to
 * run __global_init), literal array bounds only.
 * ======================================================================== */

/* ---- system-call stubs (src/runtime.s) ---- */
void __sys_putc(int c);
int __sys_open(const char *name, int flags, int mode);
int __sys_read(int fd, char *buf, int n);
int __sys_write(int fd, const char *buf, int n);
int __sys_close(int fd);
char *__sys_sbrk(int n);
void __sys_exit(int code);
double __sys_sqrt(double x);

/* ======================================================================== */
/*  Memory: first-fit free list over sbrk                                   */
/* ======================================================================== */

struct __fns_blk {
    unsigned int size;              /* usable bytes, multiple of 8 */
    struct __fns_blk *next;         /* next free block */
};

static struct __fns_blk *__fns_free_list = 0;

void *memset(void *p, int c, unsigned int n) {
    char *d = (char *)p;
    unsigned int i;
    for (i = 0; i < n; i++) d[i] = (char)c;
    return p;
}

void *memcpy(void *dst, const void *src, unsigned int n) {
    char *d = (char *)dst;
    const char *s = (const char *)src;
    unsigned int i;
    for (i = 0; i < n; i++) d[i] = s[i];
    return dst;
}

void *memmove(void *dst, const void *src, unsigned int n) {
    char *d = (char *)dst;
    const char *s = (const char *)src;
    unsigned int i;
    if (d == s || n == 0) return dst;
    if (d < s) {
        for (i = 0; i < n; i++) d[i] = s[i];
    } else {
        i = n;
        while (i > 0) { i--; d[i] = s[i]; }
    }
    return dst;
}

int memcmp(const void *a, const void *b, unsigned int n) {
    const unsigned char *x = (const unsigned char *)a;
    const unsigned char *y = (const unsigned char *)b;
    unsigned int i;
    for (i = 0; i < n; i++)
        if (x[i] != y[i]) return x[i] < y[i] ? -1 : 1;
    return 0;
}

void *malloc(unsigned int n) {
    struct __fns_blk *prev = 0;
    struct __fns_blk *b = __fns_free_list;
    if (n == 0) n = 1;
    n = (n + 7) & ~7u;
    while (b) {
        if (b->size >= n) {
            if (b->size >= n + 24) {        /* split: the tail stays free */
                struct __fns_blk *rest = (struct __fns_blk *)((char *)b + 8 + n);
                rest->size = b->size - n - 8;
                rest->next = b->next;
                b->size = n;
                if (prev) prev->next = rest; else __fns_free_list = rest;
            } else {
                if (prev) prev->next = b->next; else __fns_free_list = b->next;
            }
            b->next = 0;
            return (char *)b + 8;
        }
        prev = b;
        b = b->next;
    }
    b = (struct __fns_blk *)__sys_sbrk((int)n + 8);
    if (b == 0 || (int)b == -1) return 0;
    b->size = n;
    b->next = 0;
    return (char *)b + 8;
}

void free(void *p) {
    struct __fns_blk *b;
    if (!p) return;
    b = (struct __fns_blk *)((char *)p - 8);
    b->next = __fns_free_list;
    __fns_free_list = b;
}

void *calloc(unsigned int n, unsigned int size) {
    void *p = malloc(n * size);
    if (p) memset(p, 0, n * size);
    return p;
}

void *realloc(void *p, unsigned int n) {
    struct __fns_blk *b;
    void *q;
    if (!p) return malloc(n);
    if (n == 0) { free(p); return 0; }
    b = (struct __fns_blk *)((char *)p - 8);
    if (b->size >= n) return p;
    q = malloc(n);
    if (!q) return 0;
    memcpy(q, p, b->size);
    free(p);
    return q;
}

/* ======================================================================== */
/*  Process                                                                 */
/* ======================================================================== */

/* Destructors of objects with static storage, registered when each object is
   constructed and run in reverse order by exit() and at the end of main. */
struct __fns_exit_entry { void (*fn)(void *); void *obj; struct __fns_exit_entry *next; };
static struct __fns_exit_entry *__fns_exit_list;

void __fns_atexit(void (*fn)(void *), void *obj) {
    struct __fns_exit_entry *e = (struct __fns_exit_entry *)malloc(sizeof(struct __fns_exit_entry));
    if (!e) return;
    e->fn = fn;
    e->obj = obj;
    e->next = __fns_exit_list;
    __fns_exit_list = e;
}

void __fns_run_atexit(void) {
    while (__fns_exit_list) {
        struct __fns_exit_entry *e = __fns_exit_list;
        __fns_exit_list = e->next;
        e->fn(e->obj);
        free(e);
    }
}

void exit(int code) { __fns_run_atexit(); __sys_exit(code); }

void abort() {
    const char *m = "Aborted\n";
    while (*m) __sys_putc(*m++);
    __sys_exit(134);
}

long time(void *t) { return 0; }

/* rand(): the same additive-feedback generator as glibc's random(), so
 * programs print the same sequence as with gcc for a given seed. */
static int __fns_rtab[34];
static int __fns_ridx = 0;
static int __fns_rseeded = 0;

void srand(unsigned int seed) {
    int i;
    int word;
    if (seed == 0) seed = 1;
    __fns_rtab[0] = (int)seed;
    word = (int)seed;
    for (i = 1; i < 31; i++) {
        int hi = word / 127773;
        int lo = word % 127773;
        word = 16807 * lo - 2836 * hi;
        if (word < 0) word += 2147483647;
        __fns_rtab[i] = word;
    }
    for (i = 31; i < 34; i++) __fns_rtab[i] = __fns_rtab[i - 31];
    __fns_ridx = 34;
    __fns_rseeded = 1;
    for (i = 34; i < 344; i++) {
        int k = __fns_ridx % 34;
        __fns_rtab[k] = __fns_rtab[(__fns_ridx - 31) % 34] + __fns_rtab[(__fns_ridx - 3) % 34];
        __fns_ridx++;
    }
}

int rand() {
    int k;
    unsigned int v;
    if (!__fns_rseeded) srand(1);
    k = __fns_ridx % 34;
    __fns_rtab[k] = __fns_rtab[(__fns_ridx - 31) % 34] + __fns_rtab[(__fns_ridx - 3) % 34];
    v = (unsigned int)__fns_rtab[k];
    __fns_ridx++;
    if (__fns_ridx >= 34000) __fns_ridx -= 33966;   /* keep the index small, same residues */
    return (int)(v >> 1);
}

int abs(int x) { return x < 0 ? -x : x; }
long labs(long x) { return x < 0 ? -x : x; }

/* ======================================================================== */
/*  ctype                                                                   */
/* ======================================================================== */

int isdigit(int c) { return c >= '0' && c <= '9'; }
int isupper(int c) { return c >= 'A' && c <= 'Z'; }
int islower(int c) { return c >= 'a' && c <= 'z'; }
int isalpha(int c) { return isupper(c) || islower(c); }
int isalnum(int c) { return isalpha(c) || isdigit(c); }
int isspace(int c) { return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == 11 || c == 12; }
int isxdigit(int c) { return isdigit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'); }
int isprint(int c) { return c >= 32 && c < 127; }
int ispunct(int c) { return isprint(c) && !isalnum(c) && c != ' '; }
int toupper(int c) { return islower(c) ? c - 32 : c; }
int tolower(int c) { return isupper(c) ? c + 32 : c; }

/* ======================================================================== */
/*  string.h                                                                */
/* ======================================================================== */

unsigned int strlen(const char *s) {
    unsigned int n = 0;
    while (s[n]) n++;
    return n;
}

char *strcpy(char *d, const char *s) {
    int i = 0;
    while (s[i]) { d[i] = s[i]; i++; }
    d[i] = 0;
    return d;
}

char *strncpy(char *d, const char *s, unsigned int n) {
    unsigned int i = 0;
    while (i < n && s[i]) { d[i] = s[i]; i++; }
    while (i < n) { d[i] = 0; i++; }
    return d;
}

char *strcat(char *d, const char *s) {
    strcpy(d + strlen(d), s);
    return d;
}

char *strncat(char *d, const char *s, unsigned int n) {
    char *e = d + strlen(d);
    unsigned int i = 0;
    while (i < n && s[i]) { e[i] = s[i]; i++; }
    e[i] = 0;
    return d;
}

int strcmp(const char *a, const char *b) {
    while (*a && *a == *b) { a++; b++; }
    return (int)(unsigned char)*a - (int)(unsigned char)*b;
}

int strncmp(const char *a, const char *b, unsigned int n) {
    unsigned int i;
    for (i = 0; i < n; i++) {
        if (a[i] != b[i] || !a[i])
            return (int)(unsigned char)a[i] - (int)(unsigned char)b[i];
    }
    return 0;
}

char *strchr(const char *s, int c) {
    while (1) {
        if (*s == (char)c) return (char *)s;
        if (!*s) return 0;
        s++;
    }
    return 0;
}

char *strrchr(const char *s, int c) {
    const char *last = 0;
    while (1) {
        if (*s == (char)c) last = s;
        if (!*s) return (char *)last;
        s++;
    }
    return 0;
}

char *strstr(const char *h, const char *n) {
    unsigned int ln = strlen(n);
    if (ln == 0) return (char *)h;
    while (*h) {
        if (strncmp(h, n, ln) == 0) return (char *)h;
        h++;
    }
    return 0;
}

char *strdup(const char *s) {
    char *d = (char *)malloc(strlen(s) + 1);
    if (d) strcpy(d, s);
    return d;
}

unsigned int strspn(const char *s, const char *accept) {
    unsigned int n = 0;
    while (s[n] && strchr(accept, s[n])) n++;
    return n;
}

unsigned int strcspn(const char *s, const char *reject) {
    unsigned int n = 0;
    while (s[n] && !strchr(reject, s[n])) n++;
    return n;
}

char *strpbrk(const char *s, const char *accept) {
    while (*s) {
        if (strchr(accept, *s)) return (char *)s;
        s++;
    }
    return 0;
}

static char *__fns_tok_next = 0;

char *strtok(char *s, const char *delim) {
    char *start;
    if (s) __fns_tok_next = s;
    if (!__fns_tok_next) return 0;
    s = __fns_tok_next;
    while (*s && strchr(delim, *s)) s++;
    if (!*s) { __fns_tok_next = 0; return 0; }
    start = s;
    while (*s && !strchr(delim, *s)) s++;
    if (*s) { *s = 0; __fns_tok_next = s + 1; }
    else __fns_tok_next = 0;
    return start;
}

/* ======================================================================== */
/*  math (double precision)                                                 */
/* ======================================================================== */

union __fns_dbits {
    double d;
    unsigned int w[2];              /* little-endian: w[1] holds sign/exponent */
};

double fabs(double x) { return x < 0 ? -x : x; }

/* Truncate toward zero by clearing fraction bits. */
double __fns_trunc(double x) {
    union __fns_dbits u;
    int e;
    u.d = x;
    e = (int)((u.w[1] >> 20) & 0x7ff) - 1023;
    if (e < 0) { u.w[0] = 0; u.w[1] = u.w[1] & 0x80000000u; return u.d; }
    if (e >= 52) return x;
    if (e < 20) {
        u.w[1] = u.w[1] & ~(0x000fffffu >> e);
        u.w[0] = 0;
    } else {
        u.w[0] = u.w[0] & ~(0xffffffffu >> (e - 20));
    }
    return u.d;
}

double floor(double x) {
    double t = __fns_trunc(x);
    if (t > x) t = t - 1.0;
    return t;
}

double ceil(double x) {
    double t = __fns_trunc(x);
    if (t < x) t = t + 1.0;
    return t;
}

double round(double x) {
    if (x < 0) return -floor(-x + 0.5);
    return floor(x + 0.5);
}

double fmod(double x, double y) {
    if (y == 0) return 0.0 / 0.0;
    return x - __fns_trunc(x / y) * y;
}

double sqrt(double x) {
    if (x < 0) return 0.0 / 0.0;
    return __sys_sqrt(x);
}

double fmax(double a, double b) { return a > b ? a : b; }
double fmin(double a, double b) { return a < b ? a : b; }

/* 2^k as a double, built from its exponent bits. */
double __fns_pow2(int k) {
    union __fns_dbits u;
    double r = 1.0;
    while (k > 1023) { r = r * 8.98846567431158e307; k -= 1023; }
    while (k < -1022) { r = r * 2.2250738585072014e-308; k += 1022; }
    u.w[0] = 0;
    u.w[1] = (unsigned int)(k + 1023) << 20;
    return r * u.d;
}

double exp(double x) {
    double ln2 = 0.6931471805599453;
    double r, term, sum;
    int k, i;
    if (x > 709.0) return 1.0 / 0.0;
    if (x < -745.0) return 0.0;
    k = (int)round(x / ln2);
    r = x - k * ln2;
    term = 1.0;
    sum = 1.0;
    for (i = 1; i < 30; i++) {
        term = term * r / i;
        sum = sum + term;
    }
    return sum * __fns_pow2(k);
}

double log(double x) {
    union __fns_dbits u;
    int e;
    double m, s, s2, term, sum;
    int i;
    if (x < 0) return 0.0 / 0.0;
    if (x == 0) return -1.0 / 0.0;
    u.d = x;
    e = (int)((u.w[1] >> 20) & 0x7ff) - 1023;
    u.w[1] = (u.w[1] & 0x800fffffu) | 0x3ff00000u;     /* mantissa in [1,2) */
    m = u.d;
    if (m > 1.4142135623730951) { m = m / 2.0; e = e + 1; }
    s = (m - 1.0) / (m + 1.0);
    s2 = s * s;
    term = s;
    sum = 0.0;
    for (i = 1; i < 60; i += 2) {
        sum = sum + term / i;
        term = term * s2;
    }
    return 2.0 * sum + e * 0.6931471805599453;
}

double log10(double x) { return log(x) / 2.302585092994046; }

double pow(double x, double y) {
    double r = 1.0;
    double b = x;
    int neg = 0;
    long n;
    if (y == 0) return 1.0;
    if (y == __fns_trunc(y) && y < 2147483647.0 && y > -2147483647.0) {
        n = (long)y;
        if (n < 0) { neg = 1; n = -n; }
        while (n > 0) {                 /* exact for integer powers that fit */
            if (n & 1) r = r * b;
            b = b * b;
            n = n >> 1;
        }
        return neg ? 1.0 / r : r;
    }
    if (x < 0) return 0.0 / 0.0;
    if (x == 0) return 0.0;
    return exp(y * log(x));
}

double sin(double x) {
    double twopi = 6.283185307179586;
    double term, sum, x2;
    int i;
    x = x - round(x / twopi) * twopi;
    x2 = x * x;
    term = x;
    sum = x;
    for (i = 1; i < 25; i++) {
        term = -term * x2 / ((2 * i) * (2 * i + 1));
        sum = sum + term;
    }
    return sum;
}

double cos(double x) {
    double twopi = 6.283185307179586;
    double term, sum, x2;
    int i;
    x = x - round(x / twopi) * twopi;
    x2 = x * x;
    term = 1.0;
    sum = 1.0;
    for (i = 1; i < 25; i++) {
        term = -term * x2 / ((2 * i - 1) * (2 * i));
        sum = sum + term;
    }
    return sum;
}

double tan(double x) { return sin(x) / cos(x); }

/* ======================================================================== */
/*  Number parsing                                                          */
/* ======================================================================== */

long strtol(const char *s, char **end, int base) {
    const char *p = s;
    long v = 0;
    int neg = 0, any = 0, d;
    while (isspace(*p)) p++;
    if (*p == '-') { neg = 1; p++; } else if (*p == '+') p++;
    if ((base == 0 || base == 16) && p[0] == '0' && (p[1] == 'x' || p[1] == 'X') && isxdigit(p[2])) {
        p += 2;
        base = 16;
    } else if (base == 0 && p[0] == '0') {
        base = 8;
    } else if (base == 0) {
        base = 10;
    }
    while (1) {
        if (isdigit(*p)) d = *p - '0';
        else if (*p >= 'a' && *p <= 'z') d = *p - 'a' + 10;
        else if (*p >= 'A' && *p <= 'Z') d = *p - 'A' + 10;
        else break;
        if (d >= base) break;
        v = v * base + d;
        any = 1;
        p++;
    }
    if (end) *end = (char *)(any ? p : s);
    return neg ? -v : v;
}

int atoi(const char *s) { return (int)strtol(s, 0, 10); }
long atol(const char *s) { return strtol(s, 0, 10); }

/* 10^k as a double; exact for 0 <= k <= 22. */
double __fns_pow10(int k) {
    double r = 1.0;
    double b = 10.0;
    int neg = k < 0;
    if (neg) k = -k;
    while (k > 0) {
        if (k & 1) r = r * b;
        b = b * b;
        k = k >> 1;
    }
    return neg ? 1.0 / r : r;
}

/* strtod: sign, digits, fraction and exponent; scaled with exact powers of ten.
 * Comment: >30 lines because of the separate mantissa and exponent parsing. */
double strtod(const char *s, char **end) {
    const char *p = s;
    double m = 0.0;
    int neg = 0, any = 0, exp10 = 0, digits = 0;
    while (isspace(*p)) p++;
    if (*p == '-') { neg = 1; p++; } else if (*p == '+') p++;
    while (isdigit(*p)) {
        if (digits < 18) { m = m * 10.0 + (*p - '0'); digits++; } else exp10++;
        any = 1;
        p++;
    }
    if (*p == '.') {
        p++;
        while (isdigit(*p)) {
            if (digits < 18) { m = m * 10.0 + (*p - '0'); digits++; exp10--; }
            any = 1;
            p++;
        }
    }
    if (any && (*p == 'e' || *p == 'E')) {
        const char *q = p + 1;
        int eneg = 0, ev = 0, eany = 0;
        if (*q == '-') { eneg = 1; q++; } else if (*q == '+') q++;
        while (isdigit(*q)) { ev = ev * 10 + (*q - '0'); eany = 1; q++; }
        if (eany) { p = q; exp10 += eneg ? -ev : ev; }
    }
    if (end) *end = (char *)(any ? p : s);
    if (!any) return 0.0;
    if (exp10 < 0 && exp10 >= -22) m = m / __fns_pow10(-exp10);
    else if (exp10 < -22) { m = m / __fns_pow10(22); m = m / __fns_pow10(-exp10 - 22); }
    else if (exp10 > 0) m = m * __fns_pow10(exp10);
    return neg ? -m : m;
}

double atof(const char *s) { return strtod(s, 0); }

/* ======================================================================== */
/*  qsort (insertion sort on raw bytes)                                     */
/* ======================================================================== */

void qsort(void *base, unsigned int n, unsigned int size, int (*cmp)(const void *, const void *)) {
    char *a = (char *)base;
    char *tmp;
    unsigned int i, j;
    if (n < 2) return;
    tmp = (char *)malloc(size);
    for (i = 1; i < n; i++) {
        memcpy(tmp, a + i * size, size);
        j = i;
        while (j > 0 && cmp(a + (j - 1) * size, tmp) > 0) {
            memcpy(a + j * size, a + (j - 1) * size, size);
            j--;
        }
        memcpy(a + j * size, tmp, size);
    }
    free(tmp);
}

void *bsearch(const void *key, const void *base, unsigned int n, unsigned int size,
              int (*cmp)(const void *, const void *)) {
    const char *a = (const char *)base;
    int lo = 0, hi = (int)n - 1;
    while (lo <= hi) {
        int mid = (lo + hi) / 2;
        int c = cmp(key, a + mid * size);
        if (c == 0) return (void *)(a + mid * size);
        if (c < 0) hi = mid - 1; else lo = mid + 1;
    }
    return 0;
}

/* ======================================================================== */
/*  Files                                                                   */
/*  stdin/stdout/stderr are the pseudo pointers (FILE*)1, 2, 3.  Console     */
/*  output goes through spim's print_char so it stays in order with spim's   */
/*  own messages; console input uses read(0) so EOF is reported correctly.  */
/* ======================================================================== */

static FILE __fns_std[4];

FILE *__fns_file(FILE *fp) {
    unsigned int k = (unsigned int)fp;
    if (k >= 1 && k <= 3) {
        FILE *f = &__fns_std[k];
        f->fd = (int)k - 1;
        f->mode = k == 1 ? 1 : 2;
        return f;
    }
    return fp;
}

/* spim passes open(2) flags to the host system */
#ifdef __FNS_DARWIN__
#define __FNS_O_CREAT 512
#define __FNS_O_TRUNC 1024
#define __FNS_O_APPEND 8
#else
#define __FNS_O_CREAT 64
#define __FNS_O_TRUNC 512
#define __FNS_O_APPEND 1024
#endif

/* Number of bytes in a file (spim has no lseek/stat: read it through). */
long __fns_size(const char *name) {
    char buf[64];
    long total = 0;
    int k, fd = __sys_open(name, 0, 0);
    if (fd < 0) return -1;
    while ((k = __sys_read(fd, buf, 64)) > 0) total += k;
    __sys_close(fd);
    return total;
}

/* Comment: >30 lines because it maps the C modes to open(2) flags, opens the file
   and initializes the runtime FILE object (including what fseek needs to reopen it). */
FILE *fopen(const char *name, const char *mode) {
    int access, extra = 0, fd;
    int plus = 0;
    const char *m;
    FILE *f;
    for (m = mode; *m; m++) if (*m == '+') plus = 1;
    access = plus ? 2 : (mode[0] == 'r' ? 0 : 1);
    if (mode[0] == 'w') extra = __FNS_O_CREAT | __FNS_O_TRUNC;
    else if (mode[0] == 'a') extra = __FNS_O_CREAT | __FNS_O_APPEND;
    else if (mode[0] != 'r') return 0;
    fd = __sys_open(name, access | extra, 420);
    if (fd < 0) return 0;
    f = (FILE *)malloc(sizeof(FILE));
    f->fd = fd;
    f->mode = mode[0] == 'r' && !plus ? 1 : 3;
    f->ungot = 0;
    f->eof = 0;
    f->err = 0;
    f->pos = mode[0] == 'a' && !plus ? -1 : 0;   /* -1: at the end of the file */
    f->reopen = access | (mode[0] == 'a' ? __FNS_O_APPEND : 0);
    f->name = strdup(name);
    return f;
}

int fclose(FILE *fp) {
    if (!fp) return -1;
    if ((unsigned int)fp <= 3) return 0;
    __sys_close(fp->fd);
    free(fp->name);
    free(fp);
    return 0;
}

long ftell(FILE *fp) {
    FILE *f = __fns_file(fp);
    if (!f || f->fd <= 2) return -1;
    if (f->pos < 0) f->pos = __fns_size(f->name);
    return f->pos - (f->ungot ? 1 : 0);
}

/* spim cannot move a file offset: reopen the file (never truncating) and read
   forward to the requested position. */
int fseek(FILE *fp, long off, int whence) {
    FILE *f = __fns_file(fp);
    char buf[64];
    long target, done = 0;
    int k, fd;
    if (!f || f->fd <= 2) return -1;
    if (whence == 0) target = off;
    else if (whence == 1) target = ftell(f) + off;
    else if (whence == 2) target = __fns_size(f->name) + off;
    else return -1;
    if (target < 0) return -1;
    fd = __sys_open(f->name, f->reopen, 0);
    if (fd < 0) { f->err = 1; return -1; }
    __sys_close(f->fd);
    f->fd = fd;
    while (done < target) {
        k = __sys_read(fd, buf, target - done < 64 ? target - done : 64);
        if (k <= 0) break;
        done += k;
    }
    f->pos = done;
    f->ungot = 0;
    f->eof = 0;
    return 0;
}

void rewind(FILE *fp) {
    FILE *f = __fns_file(fp);
    if (fseek(fp, 0, 0) == 0) f->err = 0;
}

int fflush(FILE *fp) { return 0; }

/* spim has no system call for deleting a file */
int remove(const char *name) { return -1; }

int fputc(int c, FILE *fp) {
    FILE *f = __fns_file(fp);
    char ch = (char)c;
    if (!f) return -1;
    if (f->fd == 1 || f->fd == 2) { __sys_putc(c & 255); return c & 255; }
    if (__sys_write(f->fd, &ch, 1) != 1) { f->err = 1; return -1; }
    if (f->pos >= 0) f->pos = (f->reopen & __FNS_O_APPEND) ? -1 : f->pos + 1;
    return c & 255;
}

int putc(int c, FILE *fp) { return fputc(c, fp); }
int putchar(int c) { return fputc(c, (FILE *)2); }

int fgetc(FILE *fp) {
    FILE *f = __fns_file(fp);
    char ch;
    if (!f) return -1;
    if (f->ungot) { int c = f->ungot - 1; f->ungot = 0; return c; }
    if (f->eof) return -1;
    if (__sys_read(f->fd, &ch, 1) != 1) { f->eof = 1; return -1; }
    if (f->pos >= 0) f->pos++;
    return (int)(unsigned char)ch;
}

int getc(FILE *fp) { return fgetc(fp); }
int getchar() { return fgetc((FILE *)1); }

int ungetc(int c, FILE *fp) {
    FILE *f = __fns_file(fp);
    if (c == -1 || !f) return -1;
    f->ungot = (c & 255) + 1;
    f->eof = 0;
    return c & 255;
}

int feof(FILE *fp) { FILE *f = __fns_file(fp); return f ? f->eof : 1; }
int ferror(FILE *fp) { FILE *f = __fns_file(fp); return f ? f->err : 1; }

int fputs(const char *s, FILE *fp) {
    while (*s) { if (fputc(*s, fp) < 0) return -1; s++; }
    return 1;
}

int puts(const char *s) {
    if (fputs(s, (FILE *)2) < 0) return -1;
    fputc('\n', (FILE *)2);
    return 1;
}

char *fgets(char *s, int n, FILE *fp) {
    int i = 0, c;
    if (n <= 0) return 0;
    while (i < n - 1) {
        c = fgetc(fp);
        if (c == -1) break;
        s[i++] = (char)c;
        if (c == '\n') break;
    }
    if (i == 0) return 0;
    s[i] = 0;
    return s;
}

unsigned int fwrite(const void *p, unsigned int size, unsigned int n, FILE *fp) {
    const char *b = (const char *)p;
    unsigned int total = size * n, i;
    for (i = 0; i < total; i++)
        if (fputc(b[i], fp) < 0) break;
    return size ? i / size : 0;
}

unsigned int fread(void *p, unsigned int size, unsigned int n, FILE *fp) {
    char *b = (char *)p;
    unsigned int total = size * n, i;
    int c;
    for (i = 0; i < total; i++) {
        c = fgetc(fp);
        if (c == -1) break;
        b[i] = (char)c;
    }
    return size ? i / size : 0;
}

/* ======================================================================== */
/*  printf family                                                           */
/* ======================================================================== */

/* Output sink: a FILE, or a buffer for sprintf/snprintf. */
struct __fns_sink {
    FILE *fp;
    char *buf;
    int pos;
    int cap;                        /* buffer size including the NUL; -1 = unbounded */
};

void __fns_put(struct __fns_sink *s, int c) {
    if (s->buf) {
        if (s->cap < 0 || s->pos < s->cap - 1) s->buf[s->pos] = (char)c;
    } else if (s->fp) {
        fputc(c, s->fp);
    }
    s->pos++;
}

void __fns_pad(struct __fns_sink *s, int c, int n) {
    while (n-- > 0) __fns_put(s, c);
}

/* Emit body text with sign/prefix and padding: the common tail of every
 * numeric conversion.  `zero` pads with zeros between prefix and body. */
void __fns_emit(struct __fns_sink *s, const char *prefix, const char *body, int len,
                int width, int left, int zero) {
    int plen = (int)strlen(prefix);
    int pad = width - plen - len;
    int i;
    if (!left && !zero) __fns_pad(s, ' ', pad);
    for (i = 0; i < plen; i++) __fns_put(s, prefix[i]);
    if (!left && zero) __fns_pad(s, '0', pad);
    for (i = 0; i < len; i++) __fns_put(s, body[i]);
    if (left) __fns_pad(s, ' ', pad);
}

/* Integer conversion (d i u x X o p). */
void __fns_fmt_int(struct __fns_sink *s, unsigned int mag, int neg, int base, int upper,
                   int plus, int space, int alt, int width, int prec, int left, int zero) {
    char tmp[40];
    char body[48];
    char prefix[4];
    const char *digs = upper ? "0123456789ABCDEF" : "0123456789abcdef";
    int n = 0, len = 0, p = 0;
    while (mag) { tmp[n++] = digs[mag % base]; mag = mag / base; }
    if (prec < 0) prec = 1;
    else zero = 0;
    while (n < prec) tmp[n++] = '0';
    if (alt && base == 8 && (n == 0 || tmp[n - 1] != '0')) tmp[n++] = '0';
    while (n > 0) body[len++] = tmp[--n];
    if (neg) prefix[p++] = '-';
    else if (plus) prefix[p++] = '+';
    else if (space) prefix[p++] = ' ';
    if (alt && base == 16 && len > 0 && !(len == 1 && body[0] == '0')) {
        prefix[p++] = '0';
        prefix[p++] = upper ? 'X' : 'x';
    }
    prefix[p] = 0;
    __fns_emit(s, prefix, body, len, width, left, zero);
}

/* Error of the product a*b (Dekker/Veltkamp), so ties can be decided exactly. */
double __fns_mul_err(double a, double b, double p) {
    double c = 134217729.0;
    double ta = c * a, tb = c * b;
    double ah = ta - (ta - a), al = a - ah;
    double bh = tb - (tb - b), bl = b - bh;
    return ((ah * bh - p) + ah * bl + al * bh) + al * bl;
}

/* Digits of a non-negative integer-valued double into out (no NUL); returns count. */
int __fns_int_digits(double v, char *out) {
    char tmp[340];
    int n = 0, len = 0;
    double q;
    if (v < 1.0) { out[0] = '0'; return 1; }
    while (v >= 1.0 && n < 330) {
        q = __fns_trunc(v / 10.0);
        tmp[n++] = (char)('0' + (int)(v - q * 10.0));
        v = q;
    }
    while (n > 0) out[len++] = tmp[--n];
    return len;
}

/* Round |x| * 10^prec to the nearest integer (ties to even, decided exactly). */
double __fns_scaled_round(double x, int prec) {
    double scale = __fns_pow10(prec);
    double r = x * scale;
    double fl = floor(r);
    double diff = r - fl;
    if (diff > 0.5) return fl + 1.0;
    if (diff < 0.5) return fl;
    {
        double err = prec <= 22 ? __fns_mul_err(x, scale, r) : 0.0;
        if (err > 0) return fl + 1.0;
        if (err < 0) return fl;
        if (fmod(fl, 2.0) != 0) return fl + 1.0;
        return fl;
    }
}

/* %f body: digits of |x| with `prec` decimals; returns length. */
int __fns_fixed(double x, int prec, int alt, char *out) {
    char digs[360];
    double n = __fns_scaled_round(x, prec);
    int len = __fns_int_digits(n, digs);
    int i, o = 0, intlen;
    if (n < 1.0) len = 0;
    while (len < prec + 1) {                    /* left-pad with zeros */
        for (i = len; i > 0; i--) digs[i] = digs[i - 1];
        digs[0] = '0';
        len++;
    }
    intlen = len - prec;
    for (i = 0; i < intlen; i++) out[o++] = digs[i];
    if (prec > 0 || alt) out[o++] = '.';
    for (i = intlen; i < len; i++) out[o++] = digs[i];
    return o;
}

/* Decimal exponent of |x| after rounding to prec+1 significant digits. */
int __fns_exp10(double x, int prec) {
    int e = 0;
    double m;
    if (x == 0) return 0;
    while (x >= __fns_pow10(e + 1) && e < 308) e++;
    while (x < __fns_pow10(e) && e > -320) e--;
    m = __fns_scaled_round(x / __fns_pow10(e), prec);
    if (m >= __fns_pow10(prec + 1)) e++;
    return e;
}

/* %e body; returns length. */
int __fns_expo(double x, int prec, int alt, int upper, char *out) {
    int e = __fns_exp10(x, prec);
    double m = x == 0 ? 0.0 : x / __fns_pow10(e);
    int o = __fns_fixed(m, prec, alt, out);
    int ae = e < 0 ? -e : e;
    if (o > 0 && out[0] != '0' && o > prec + 2 + (prec > 0 || alt ? 0 : -1)) {
        /* rounding produced 10.xxx: renormalise */
        e++;
        ae = e < 0 ? -e : e;
        o = __fns_fixed(x / __fns_pow10(e), prec, alt, out);
    }
    out[o++] = upper ? 'E' : 'e';
    out[o++] = e < 0 ? '-' : '+';
    if (ae >= 100) out[o++] = (char)('0' + ae / 100);
    out[o++] = (char)('0' + (ae / 10) % 10);
    out[o++] = (char)('0' + ae % 10);
    return o;
}

/* Floating conversion (f F e E g G). */
void __fns_fmt_float(struct __fns_sink *s, double x, int conv, int plus, int space, int alt,
                     int width, int prec, int left, int zero) {
    char body[400];
    char prefix[2];
    union __fns_dbits u;
    int len = 0, neg, upper = conv == 'F' || conv == 'E' || conv == 'G';
    u.d = x;
    neg = (u.w[1] & 0x80000000u) != 0;
    if (neg) x = -x;
    prefix[0] = neg ? '-' : plus ? '+' : space ? ' ' : 0;
    prefix[1] = 0;
    if (prec < 0) prec = 6;
    if (x != x || x > 1.7976931348623157e308) {
        const char *t = x != x ? (upper ? "NAN" : "nan") : (upper ? "INF" : "inf");
        __fns_emit(s, prefix, t, 3, width, left, 0);
        return;
    }
    if (conv == 'f' || conv == 'F') {
        len = __fns_fixed(x, prec, alt, body);
    } else if (conv == 'e' || conv == 'E') {
        len = __fns_expo(x, prec, alt, upper, body);
    } else {
        int P = prec == 0 ? 1 : prec;
        int X = __fns_exp10(x, P - 1);
        if (P > X && X >= -4) len = __fns_fixed(x, P - 1 - X, alt, body);
        else len = __fns_expo(x, P - 1, alt, upper, body);
        if (!alt) {                             /* strip trailing zeros */
            int epos = len, i, k;
            for (i = 0; i < len; i++) if (body[i] == 'e' || body[i] == 'E') { epos = i; break; }
            k = epos;
            for (i = 0; i < epos; i++) if (body[i] == '.') break;
            if (i < epos) {
                while (k > 0 && body[k - 1] == '0') k--;
                if (k > 0 && body[k - 1] == '.') k--;
                for (i = 0; epos + i < len; i++) body[k + i] = body[epos + i];
                len = k + (len - epos);
            }
        }
    }
    __fns_emit(s, prefix, body, len, width, left, zero);
}

/* The formatter behind every printf-family function.
 * Comment: >30 lines because it parses the full conversion specification
 * (flags, width, precision, length) and dispatches each conversion. */
int __fns_vformat(struct __fns_sink *s, const char *f, va_list ap) {
    while (*f) {
        int left = 0, plus = 0, space = 0, alt = 0, zero = 0, width = 0, prec = -1, lng = 0;
        int c;
        if (*f != '%') { __fns_put(s, *f++); continue; }
        f++;
        while (1) {
            if (*f == '-') left = 1;
            else if (*f == '+') plus = 1;
            else if (*f == ' ') space = 1;
            else if (*f == '#') alt = 1;
            else if (*f == '0') zero = 1;
            else break;
            f++;
        }
        if (*f == '*') {
            width = va_arg(ap, int);
            if (width < 0) { left = 1; width = -width; }
            f++;
        } else {
            while (isdigit(*f)) width = width * 10 + (*f++ - '0');
        }
        if (*f == '.') {
            f++;
            prec = 0;
            if (*f == '*') { prec = va_arg(ap, int); f++; }
            else while (isdigit(*f)) prec = prec * 10 + (*f++ - '0');
        }
        while (*f == 'h' || *f == 'l' || *f == 'L' || *f == 'z' || *f == 'j' || *f == 't') {
            if (*f == 'h') lng--;
            f++;
        }
        if (left) zero = 0;
        c = *f;
        if (!c) break;
        f++;
        if (c == 'd' || c == 'i') {
            int v = va_arg(ap, int);
            unsigned int mag;
            if (lng == -1) v = (short)v;
            if (lng <= -2) v = (char)v;
            mag = v < 0 ? (unsigned int)(-(v + 1)) + 1u : (unsigned int)v;
            __fns_fmt_int(s, mag, v < 0, 10, 0, plus, space, alt, width, prec, left, zero);
        } else if (c == 'u' || c == 'x' || c == 'X' || c == 'o') {
            unsigned int v = va_arg(ap, unsigned int);
            if (lng == -1) v = v & 0xffffu;
            if (lng <= -2) v = v & 0xffu;
            __fns_fmt_int(s, v, 0, c == 'u' ? 10 : c == 'o' ? 8 : 16, c == 'X', 0, 0, alt,
                          width, prec, left, zero);
        } else if (c == 'p') {
            unsigned int v = va_arg(ap, unsigned int);
            if (v == 0) __fns_emit(s, "", "(nil)", 5, width, left, 0);
            else __fns_fmt_int(s, v, 0, 16, 0, plus, space, 1, width, prec, left, zero);
        } else if (c == 'c') {
            char ch = (char)va_arg(ap, int);
            __fns_emit(s, "", &ch, 1, width, left, 0);
        } else if (c == 's') {
            const char *str = va_arg(ap, char *);
            int len = 0;
            if (!str) str = "(null)";
            while (str[len] && (prec < 0 || len < prec)) len++;
            __fns_emit(s, "", str, len, width, left, 0);
        } else if (c == 'f' || c == 'F' || c == 'e' || c == 'E' || c == 'g' || c == 'G') {
            double d = va_arg(ap, double);
            __fns_fmt_float(s, d, c, plus, space, alt, width, prec, left, zero);
        } else if (c == 'n') {
            int *np = va_arg(ap, int *);
            *np = s->pos;
        } else if (c == '%') {
            __fns_put(s, '%');
        } else {
            __fns_put(s, '%');
            __fns_put(s, c);
        }
    }
    return s->pos;
}

int vfprintf(FILE *fp, const char *f, va_list ap) {
    struct __fns_sink s;
    s.fp = fp;
    s.buf = 0;
    s.pos = 0;
    s.cap = -1;
    return __fns_vformat(&s, f, ap);
}

int vprintf(const char *f, va_list ap) { return vfprintf((FILE *)2, f, ap); }

int vsnprintf(char *buf, unsigned int n, const char *f, va_list ap) {
    struct __fns_sink s;
    int r;
    s.fp = 0;
    s.buf = n ? buf : 0;
    s.pos = 0;
    s.cap = (int)n;
    r = __fns_vformat(&s, f, ap);
    if (n) buf[r < (int)n ? r : (int)n - 1] = 0;
    return r;
}

int vsprintf(char *buf, const char *f, va_list ap) {
    struct __fns_sink s;
    int r;
    s.fp = 0;
    s.buf = buf;
    s.pos = 0;
    s.cap = -1;
    r = __fns_vformat(&s, f, ap);
    buf[r] = 0;
    return r;
}

int printf(const char *f, ...) {
    va_list ap;
    int r;
    va_start(ap, f);
    r = vfprintf((FILE *)2, f, ap);
    va_end(ap);
    return r;
}

int fprintf(FILE *fp, const char *f, ...) {
    va_list ap;
    int r;
    va_start(ap, f);
    r = vfprintf(fp, f, ap);
    va_end(ap);
    return r;
}

int sprintf(char *buf, const char *f, ...) {
    va_list ap;
    int r;
    va_start(ap, f);
    r = vsprintf(buf, f, ap);
    va_end(ap);
    return r;
}

int snprintf(char *buf, unsigned int n, const char *f, ...) {
    va_list ap;
    int r;
    va_start(ap, f);
    r = vsnprintf(buf, n, f, ap);
    va_end(ap);
    return r;
}

/* ======================================================================== */
/*  scanf family                                                            */
/* ======================================================================== */

/* Input source: a FILE, or a string for sscanf. */
struct __fns_src {
    FILE *fp;
    const char *str;
    int pos;                        /* characters consumed (for %n) */
};

int __fns_get(struct __fns_src *s) {
    int c;
    if (s->str) {
        c = (unsigned char)s->str[s->pos];
        if (!c) return -1;
        s->pos++;
        return c;
    }
    c = fgetc(s->fp);
    if (c != -1) s->pos++;
    return c;
}

void __fns_unget(struct __fns_src *s, int c) {
    if (c == -1) return;
    s->pos--;
    if (!s->str) ungetc(c, s->fp);
}

int __fns_skip_ws(struct __fns_src *s) {
    int c = __fns_get(s);
    while (c != -1 && isspace(c)) c = __fns_get(s);
    __fns_unget(s, c);
    return c;
}

/* Is c in the %[...] set starting at set (just after '[')? */
int __fns_in_set(const char *set, int c) {
    int neg = 0, hit = 0;
    const char *p = set;
    if (*p == '^') { neg = 1; p++; }
    if (*p == ']') { if (c == ']') hit = 1; p++; }
    while (*p && *p != ']') {
        if (p[1] == '-' && p[2] && p[2] != ']') {
            if (c >= (unsigned char)p[0] && c <= (unsigned char)p[2]) hit = 1;
            p += 3;
        } else {
            if (c == (unsigned char)*p) hit = 1;
            p++;
        }
    }
    return neg ? !hit : hit;
}

/* Read the text of a number (at most width chars) into buf. */
int __fns_scan_number(struct __fns_src *s, char *buf, int width, int is_float, int base) {
    int n = 0, c, seen_digit = 0, seen_dot = 0, seen_exp = 0;
    if (width <= 0 || width > 60) width = 60;
    c = __fns_get(s);
    if ((c == '-' || c == '+') && n < width) { buf[n++] = (char)c; c = __fns_get(s); }
    if (!is_float && (base == 16 || base == 0) && c == '0' && n < width) {
        buf[n++] = '0';
        seen_digit = 1;
        c = __fns_get(s);
        if ((c == 'x' || c == 'X') && n < width) { buf[n++] = (char)c; c = __fns_get(s); base = 16; seen_digit = 0; }
        else if (base == 0) base = 8;
    }
    if (base == 0) base = 10;
    while (c != -1 && n < width) {
        if (is_float) {
            if (isdigit(c)) seen_digit = 1;
            else if (c == '.' && !seen_dot && !seen_exp) seen_dot = 1;
            else if ((c == 'e' || c == 'E') && seen_digit && !seen_exp) {
                seen_exp = 1;
                buf[n++] = (char)c;
                c = __fns_get(s);
                if ((c == '-' || c == '+') && n < width) { buf[n++] = (char)c; c = __fns_get(s); }
                continue;
            } else break;
        } else {
            int d = isdigit(c) ? c - '0' : (c >= 'a' && c <= 'f') ? c - 'a' + 10
                  : (c >= 'A' && c <= 'F') ? c - 'A' + 10 : 99;
            if (d >= base) break;
            seen_digit = 1;
        }
        buf[n++] = (char)c;
        c = __fns_get(s);
    }
    __fns_unget(s, c);
    buf[n] = 0;
    return seen_digit ? base : 0;
}

/* The scanner behind every scanf-family function.
 * Comment: >30 lines because it implements whitespace and literal matching,
 * assignment suppression, field widths, length modifiers and every conversion. */
int __fns_vscan(struct __fns_src *s, const char *f, va_list ap) {
    int count = 0;
    while (*f) {
        int suppress = 0, width = 0, lng = 0, c, conv;
        if (isspace(*f)) { __fns_skip_ws(s); f++; continue; }
        if (*f != '%' || f[1] == '%') {
            if (*f == '%') { f++; __fns_skip_ws(s); }
            c = __fns_get(s);
            if (c == -1) return count ? count : -1;
            if (c != (unsigned char)*f) { __fns_unget(s, c); return count; }
            f++;
            continue;
        }
        f++;
        if (*f == '*') { suppress = 1; f++; }
        while (isdigit(*f)) width = width * 10 + (*f++ - '0');
        while (*f == 'h' || *f == 'l' || *f == 'L' || *f == 'z' || *f == 'j') {
            if (*f == 'l' || *f == 'L') lng++;
            if (*f == 'h') lng--;
            f++;
        }
        conv = *f++;
        if (conv == 'n') { if (!suppress) *va_arg(ap, int *) = s->pos; continue; }
        if (conv != 'c' && conv != '[') {
            if (__fns_skip_ws(s) == -1) return count ? count : -1;
        }
        if (conv == 'd' || conv == 'i' || conv == 'u' || conv == 'x' || conv == 'X' || conv == 'o') {
            char buf[64];
            int base = conv == 'i' ? 0 : conv == 'o' ? 8 : (conv == 'x' || conv == 'X') ? 16 : 10;
            long v;
            base = __fns_scan_number(s, buf, width, 0, base);
            if (!base) return count;
            v = strtol(buf, 0, base);
            if (!suppress) {
                if (lng == -1) *va_arg(ap, short *) = (short)v;
                else if (lng <= -2) *va_arg(ap, char *) = (char)v;
                else *va_arg(ap, int *) = (int)v;
                count++;
            }
        } else if (conv == 'f' || conv == 'e' || conv == 'g' || conv == 'E' || conv == 'G' || conv == 'a') {
            char buf[64];
            double d;
            if (!__fns_scan_number(s, buf, width, 1, 10)) return count;
            d = strtod(buf, 0);
            if (!suppress) {
                if (lng >= 1) *va_arg(ap, double *) = d;
                else *va_arg(ap, float *) = (float)d;
                count++;
            }
        } else if (conv == 'c') {
            char *dst = suppress ? 0 : va_arg(ap, char *);
            int i;
            if (width <= 0) width = 1;
            for (i = 0; i < width; i++) {
                c = __fns_get(s);
                if (c == -1) return count ? count : -1;
                if (dst) dst[i] = (char)c;
            }
            if (!suppress) count++;
        } else if (conv == 's' || conv == '[') {
            char *dst = suppress ? 0 : va_arg(ap, char *);
            const char *set = f;
            int n = 0;
            if (conv == '[') {                       /* skip to the closing ] */
                if (*f == '^') f++;
                if (*f == ']') f++;
                while (*f && *f != ']') f++;
                if (*f) f++;
            }
            if (width <= 0) width = 2147483647;
            c = __fns_get(s);
            while (c != -1 && n < width &&
                   (conv == 's' ? !isspace(c) : __fns_in_set(set, c))) {
                if (dst) dst[n] = (char)c;
                n++;
                c = __fns_get(s);
            }
            __fns_unget(s, c);
            if (n == 0) return count ? count : (c == -1 ? -1 : count);
            if (dst) { dst[n] = 0; count++; }
        } else {
            return count;
        }
    }
    return count;
}

int vfscanf(FILE *fp, const char *f, va_list ap) {
    struct __fns_src s;
    s.fp = fp;
    s.str = 0;
    s.pos = 0;
    return __fns_vscan(&s, f, ap);
}

int scanf(const char *f, ...) {
    va_list ap;
    int r;
    va_start(ap, f);
    r = vfscanf((FILE *)1, f, ap);
    va_end(ap);
    return r;
}

int fscanf(FILE *fp, const char *f, ...) {
    va_list ap;
    int r;
    va_start(ap, f);
    r = vfscanf(fp, f, ap);
    va_end(ap);
    return r;
}

int sscanf(const char *str, const char *f, ...) {
    va_list ap;
    struct __fns_src s;
    int r;
    va_start(ap, f);
    s.fp = 0;
    s.str = str;
    s.pos = 0;
    r = __fns_vscan(&s, f, ap);
    va_end(ap);
    return r;
}
