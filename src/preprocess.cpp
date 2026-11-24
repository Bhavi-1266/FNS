// ===========================================================================
// FNS preprocessor: a small C preprocessor run before the flex scanner.
// ===========================================================================

#include "preprocess.hpp"

#include <cctype>
#include <cstring>
#include <map>
#include <regex>
#include <sstream>

namespace fns {
namespace {

struct Macro {
    bool function_like = false;
    bool variadic = false;
    std::vector<std::string> params;
    std::string body;
};

bool ident_start(char c) { return isalpha((unsigned char)c) || c == '_'; }
bool ident_char(char c) { return isalnum((unsigned char)c) || c == '_'; }

// Library functions the runtime provides, with their prototypes.  A prototype
// is injected only when the program mentions the name followed by '('.
const char *LIB_PROTOS[][2] = {
    {"printf", "int printf(const char *f, ...);"},
    {"scanf", "int scanf(const char *f, ...);"},
    {"sprintf", "int sprintf(char *b, const char *f, ...);"},
    {"snprintf", "int snprintf(char *b, unsigned int n, const char *f, ...);"},
    {"fprintf", "int fprintf(FILE *fp, const char *f, ...);"},
    {"fscanf", "int fscanf(FILE *fp, const char *f, ...);"},
    {"sscanf", "int sscanf(const char *s, const char *f, ...);"},
    {"vprintf", "int vprintf(const char *f, va_list ap);"},
    {"vfprintf", "int vfprintf(FILE *fp, const char *f, va_list ap);"},
    {"vsprintf", "int vsprintf(char *b, const char *f, va_list ap);"},
    {"vsnprintf", "int vsnprintf(char *b, unsigned int n, const char *f, va_list ap);"},
    {"putchar", "int putchar(int c);"},
    {"getchar", "int getchar();"},
    {"puts", "int puts(const char *s);"},
    {"fputc", "int fputc(int c, FILE *fp);"},
    {"putc", "int putc(int c, FILE *fp);"},
    {"fgetc", "int fgetc(FILE *fp);"},
    {"getc", "int getc(FILE *fp);"},
    {"ungetc", "int ungetc(int c, FILE *fp);"},
    {"fputs", "int fputs(const char *s, FILE *fp);"},
    {"fgets", "char *fgets(char *s, int n, FILE *fp);"},
    {"fopen", "FILE *fopen(const char *name, const char *mode);"},
    {"fclose", "int fclose(FILE *fp);"},
    {"fseek", "int fseek(FILE *fp, long off, int whence);"},
    {"ftell", "long ftell(FILE *fp);"},
    {"rewind", "void rewind(FILE *fp);"},
    {"feof", "int feof(FILE *fp);"},
    {"ferror", "int ferror(FILE *fp);"},
    {"fflush", "int fflush(FILE *fp);"},
    {"fread", "unsigned int fread(void *p, unsigned int sz, unsigned int n, FILE *fp);"},
    {"fwrite", "unsigned int fwrite(const void *p, unsigned int sz, unsigned int n, FILE *fp);"},
    {"malloc", "void *malloc(unsigned int n);"},
    {"calloc", "void *calloc(unsigned int n, unsigned int sz);"},
    {"realloc", "void *realloc(void *p, unsigned int n);"},
    {"free", "void free(void *p);"},
    {"exit", "void exit(int code);"},
    {"abort", "void abort();"},
    {"abs", "int abs(int x);"},
    {"labs", "long labs(long x);"},
    {"atoi", "int atoi(const char *s);"},
    {"atol", "long atol(const char *s);"},
    {"atof", "double atof(const char *s);"},
    {"strtol", "long strtol(const char *s, char **end, int base);"},
    {"strtod", "double strtod(const char *s, char **end);"},
    {"rand", "int rand();"},
    {"srand", "void srand(unsigned int seed);"},
    {"time", "long time(void *t);"},
    {"qsort", "void qsort(void *base, unsigned int n, unsigned int sz, int (*cmp)(const void *, const void *));"},
    {"bsearch", "void *bsearch(const void *k, const void *b, unsigned int n, unsigned int sz, int (*cmp)(const void *, const void *));"},
    {"remove", "int remove(const char *name);"},
    {"strspn", "unsigned int strspn(const char *s, const char *a);"},
    {"strcspn", "unsigned int strcspn(const char *s, const char *r);"},
    {"strpbrk", "char *strpbrk(const char *s, const char *a);"},
    {"strlen", "unsigned int strlen(const char *s);"},
    {"strcpy", "char *strcpy(char *d, const char *s);"},
    {"strncpy", "char *strncpy(char *d, const char *s, unsigned int n);"},
    {"strcat", "char *strcat(char *d, const char *s);"},
    {"strncat", "char *strncat(char *d, const char *s, unsigned int n);"},
    {"strcmp", "int strcmp(const char *a, const char *b);"},
    {"strncmp", "int strncmp(const char *a, const char *b, unsigned int n);"},
    {"strchr", "char *strchr(const char *s, int c);"},
    {"strrchr", "char *strrchr(const char *s, int c);"},
    {"strstr", "char *strstr(const char *h, const char *n);"},
    {"strdup", "char *strdup(const char *s);"},
    {"strtok", "char *strtok(char *s, const char *delim);"},
    {"memset", "void *memset(void *p, int c, unsigned int n);"},
    {"memcpy", "void *memcpy(void *d, const void *s, unsigned int n);"},
    {"memmove", "void *memmove(void *d, const void *s, unsigned int n);"},
    {"memcmp", "int memcmp(const void *a, const void *b, unsigned int n);"},
    {"isdigit", "int isdigit(int c);"},
    {"isalpha", "int isalpha(int c);"},
    {"isalnum", "int isalnum(int c);"},
    {"isspace", "int isspace(int c);"},
    {"isupper", "int isupper(int c);"},
    {"islower", "int islower(int c);"},
    {"ispunct", "int ispunct(int c);"},
    {"isxdigit", "int isxdigit(int c);"},
    {"isprint", "int isprint(int c);"},
    {"toupper", "int toupper(int c);"},
    {"tolower", "int tolower(int c);"},
    {"sqrt", "double sqrt(double x);"},
    {"pow", "double pow(double x, double y);"},
    {"fabs", "double fabs(double x);"},
    {"floor", "double floor(double x);"},
    {"ceil", "double ceil(double x);"},
    {"round", "double round(double x);"},
    {"fmod", "double fmod(double x, double y);"},
    {"exp", "double exp(double x);"},
    {"log", "double log(double x);"},
    {"log10", "double log10(double x);"},
    {"sin", "double sin(double x);"},
    {"cos", "double cos(double x);"},
    {"tan", "double tan(double x);"},
    {"fmax", "double fmax(double a, double b);"},
    {"fmin", "double fmin(double a, double b);"},
};

class Preprocessor {
public:
    Preprocessor(bool cpp, bool runtime) : cplusplus_(cpp), runtime_(runtime) { predefine(); }
    PreprocessResult run(const std::string &source);
    void define_file(const std::string &f) { define("__FILE__", "\"" + f + "\""); }

private:
    void predefine();
    void define(const std::string &name, const std::string &body) {
        Macro m;
        m.body = body;
        macros_[name] = m;
    }
    std::string strip_comments(const std::string &src);
    void directive(const std::string &line, int lineno);
    void parse_define(const std::string &rest, int lineno);
    bool active() const {
        for (const auto &c : conds_) if (!c.taking) return false;
        return true;
    }
    std::string expand(const std::string &text, std::set<std::string> &hidden, int depth);
    std::string substitute(const Macro &m, const std::vector<std::string> &args,
                           std::set<std::string> &hidden, int depth);
    long eval_condition(const std::string &expr, int lineno);
    std::string prelude(const std::string &text);

    struct Cond {
        bool taking;     // this branch is being compiled
        bool done;       // some branch of this #if has already been taken
        bool parent;     // the enclosing region is active
    };

    bool cplusplus_;
    bool runtime_;
    std::map<std::string, Macro> macros_;
    std::vector<Cond> conds_;
    PreprocessResult res_;
};

// Predefined macros: NULL, EOF, limits, stdin/stdout/stderr and the stdarg.h macros.
// Comment: >30 lines because it is a list of definitions.
void Preprocessor::predefine() {
    define("__FNS__", "1");
#ifdef __APPLE__
    // SPIM forwards syscall 13 flags to the host OS. The runtime uses this
    // marker to select Darwin's open(2) flag values when fnsc is built there.
    define("__FNS_DARWIN__", "1");
#endif
    if (cplusplus_) define("__cplusplus", "201703L");
    define("NULL", "((void*)0)");
    define("EOF", "(-1)");
    define("SEEK_SET", "0");
    define("SEEK_CUR", "1");
    define("SEEK_END", "2");
    define("INT_MAX", "2147483647");
    define("INT_MIN", "(-2147483647-1)");
    define("UINT_MAX", "4294967295u");
    define("LONG_MAX", "2147483647L");
    define("LONG_MIN", "(-2147483647L-1)");
    define("ULONG_MAX", "4294967295ul");
    define("SHRT_MAX", "32767");
    define("SHRT_MIN", "(-32768)");
    define("USHRT_MAX", "65535");
    define("CHAR_BIT", "8");
    define("CHAR_MAX", "127");
    define("CHAR_MIN", "(-128)");
    define("SCHAR_MAX", "127");
    define("SCHAR_MIN", "(-128)");
    define("UCHAR_MAX", "255");
    define("RAND_MAX", "2147483647");
    define("EXIT_SUCCESS", "0");
    define("EXIT_FAILURE", "1");
    define("BUFSIZ", "512");
    define("M_PI", "3.14159265358979323846");
    define("M_E", "2.7182818284590452354");
    define("stdin", "((FILE*)1)");
    define("stdout", "((FILE*)2)");
    define("stderr", "((FILE*)3)");
    // <stdarg.h>: arguments are 4-byte stack words (doubles take two)
    Macro m;
    m.function_like = true;
    m.params = {"ap", "last"};
    m.body = "((ap) = __builtin_va_start())";
    macros_["va_start"] = m;
    m.params = {"ap", "T"};
    m.body = "(*(T*)(((ap) += (sizeof(T) + 3) / 4 * 4) - (sizeof(T) + 3) / 4 * 4))";
    macros_["va_arg"] = m;
    m.params = {"ap"};
    m.body = "((ap) = 0)";
    macros_["va_end"] = m;
    m.params = {"d", "s"};
    m.body = "((d) = (s))";
    macros_["va_copy"] = m;
}

// Replace comments with spaces (keeping newlines) so directives and macro
// expansion never see them.  String and character literals are preserved.
std::string Preprocessor::strip_comments(const std::string &src) {
    std::string out;
    size_t i = 0, n = src.size();
    while (i < n) {
        char c = src[i];
        if (c == '"' || c == '\'') {
            char q = c;
            out += src[i++];
            while (i < n && src[i] != q && src[i] != '\n') {
                if (src[i] == '\\' && i + 1 < n) out += src[i++];
                out += src[i++];
            }
            if (i < n && src[i] == q) out += src[i++];
        } else if (c == '/' && i + 1 < n && src[i + 1] == '/') {
            while (i < n && src[i] != '\n') ++i;
        } else if (c == '/' && i + 1 < n && src[i + 1] == '*') {
            i += 2;
            out += ' ';
            while (i < n && !(src[i] == '*' && i + 1 < n && src[i + 1] == '/')) {
                if (src[i] == '\n') out += '\n';
                ++i;
            }
            i += 2;
        } else {
            out += src[i++];
        }
    }
    return out;
}

// Comment: >30 lines because it parses both macro forms (object-like and
// function-like with an optional `...`) and validates the parameter list.
void Preprocessor::parse_define(const std::string &rest, int lineno) {
    size_t i = 0;
    while (i < rest.size() && isspace((unsigned char)rest[i])) ++i;
    size_t s = i;
    while (i < rest.size() && ident_char(rest[i])) ++i;
    std::string name = rest.substr(s, i - s);
    if (name.empty() || !ident_start(name[0])) {
        res_.errors.push_back("line " + std::to_string(lineno) + ": macro name missing in #define");
        return;
    }
    Macro m;
    if (i < rest.size() && rest[i] == '(') {          // function-like: no space before '('
        m.function_like = true;
        ++i;
        std::string cur;
        while (i < rest.size() && rest[i] != ')') {
            char c = rest[i++];
            if (c == ',') { m.params.push_back(cur); cur.clear(); }
            else if (!isspace((unsigned char)c)) cur += c;
        }
        if (i >= rest.size()) {
            res_.errors.push_back("line " + std::to_string(lineno) + ": missing ')' in #define " + name);
            return;
        }
        ++i;
        if (!cur.empty()) m.params.push_back(cur);
        if (!m.params.empty() && m.params.back() == "...") {
            m.variadic = true;
            m.params.back() = "__VA_ARGS__";
        }
    }
    std::string body = rest.substr(i);
    size_t a = body.find_first_not_of(" \t");
    size_t b = body.find_last_not_of(" \t\r");
    m.body = a == std::string::npos ? "" : body.substr(a, b - a + 1);
    macros_[name] = m;
}

// Comment: >30 lines because it dispatches every directive and maintains the
// conditional-compilation stack.
void Preprocessor::directive(const std::string &line, int lineno) {
    size_t i = line.find('#') + 1;
    while (i < line.size() && isspace((unsigned char)line[i])) ++i;
    size_t s = i;
    while (i < line.size() && ident_char(line[i])) ++i;
    std::string kw = line.substr(s, i - s);
    std::string rest = line.substr(i);
    auto first_word = [&]() {
        std::istringstream is(rest);
        std::string w;
        is >> w;
        return w;
    };
    bool parent = active();
    if (kw == "ifdef" || kw == "ifndef") {
        bool def = macros_.count(first_word()) > 0;
        bool take = parent && (kw == "ifdef" ? def : !def);
        conds_.push_back({take, take, parent});
        return;
    }
    if (kw == "if") {
        bool take = parent && eval_condition(rest, lineno) != 0;
        conds_.push_back({take, take, parent});
        return;
    }
    if (kw == "elif" || kw == "else" || kw == "endif") {
        if (conds_.empty()) {
            res_.errors.push_back("line " + std::to_string(lineno) + ": #" + kw + " without #if");
            return;
        }
        Cond &c = conds_.back();
        if (kw == "endif") { conds_.pop_back(); return; }
        if (kw == "else") { c.taking = c.parent && !c.done; c.done = true; return; }
        bool take = c.parent && !c.done && eval_condition(rest, lineno) != 0;
        c.taking = take;
        if (take) c.done = true;
        return;
    }
    if (!parent) return;
    if (kw == "define") parse_define(rest, lineno);
    else if (kw == "undef") macros_.erase(first_word());
    else if (kw == "error")
        res_.errors.push_back("line " + std::to_string(lineno) + ": #error" + rest);
    // #include, #pragma, #line and unknown directives are ignored
}

// Collect one macro argument list starting at text[i] == '('.  Returns false
// when the parentheses are not closed.
bool collect_args(const std::string &text, size_t &i, std::vector<std::string> &args) {
    int depth = 0;
    std::string cur;
    for (; i < text.size(); ++i) {
        char c = text[i];
        if (c == '"' || c == '\'') {
            char q = c;
            cur += text[i++];
            while (i < text.size() && text[i] != q) {
                if (text[i] == '\\') cur += text[i++];
                if (i < text.size()) cur += text[i++];
            }
            if (i < text.size()) cur += text[i];
            continue;
        }
        if (c == '(') { if (depth++ > 0) cur += c; continue; }
        if (c == ')') {
            if (--depth == 0) { args.push_back(cur); ++i; return true; }
            cur += c;
            continue;
        }
        if (c == ',' && depth == 1) { args.push_back(cur); cur.clear(); continue; }
        cur += c;
    }
    return false;
}

std::string trim_ws(const std::string &s) {
    size_t a = s.find_first_not_of(" \t\n");
    if (a == std::string::npos) return "";
    size_t b = s.find_last_not_of(" \t\n");
    return s.substr(a, b - a + 1);
}

// Substitute arguments into a function-like macro body (handles # and ##).
// Comment: >30 lines because stringizing, token pasting and ordinary
// parameter replacement are three different rules.
std::string Preprocessor::substitute(const Macro &m, const std::vector<std::string> &args,
                                     std::set<std::string> &hidden, int depth) {
    auto arg_index = [&](const std::string &id) {
        for (size_t k = 0; k < m.params.size(); ++k) if (m.params[k] == id) return (int)k;
        return -1;
    };
    auto arg_text = [&](int k) {
        if (m.variadic && k == (int)m.params.size() - 1) {
            std::string all;
            for (size_t j = k; j < args.size(); ++j) all += (j > (size_t)k ? "," : "") + args[j];
            return trim_ws(all);
        }
        return k < (int)args.size() ? trim_ws(args[k]) : std::string();
    };
    std::string out;
    const std::string &b = m.body;
    size_t i = 0;
    while (i < b.size()) {
        if (b[i] == '#' && i + 1 < b.size() && b[i + 1] == '#') {   // token paste
            while (!out.empty() && isspace((unsigned char)out.back())) out.pop_back();
            i += 2;
            while (i < b.size() && isspace((unsigned char)b[i])) ++i;
            size_t s = i;
            while (i < b.size() && ident_char(b[i])) ++i;
            std::string id = b.substr(s, i - s);
            int k = arg_index(id);
            out += k >= 0 ? arg_text(k) : id;
            continue;
        }
        if (b[i] == '#') {                                           // stringize
            size_t j = i + 1;
            while (j < b.size() && isspace((unsigned char)b[j])) ++j;
            size_t s = j;
            while (j < b.size() && ident_char(b[j])) ++j;
            int k = arg_index(b.substr(s, j - s));
            if (k >= 0) {
                std::string a = arg_text(k), q = "\"";
                for (char c : a) { if (c == '"' || c == '\\') q += '\\'; q += c; }
                out += q + "\"";
                i = j;
                continue;
            }
        }
        if (b[i] == '"' || b[i] == '\'') {
            char q = b[i];
            out += b[i++];
            while (i < b.size() && b[i] != q) {
                if (b[i] == '\\') out += b[i++];
                if (i < b.size()) out += b[i++];
            }
            if (i < b.size()) out += b[i++];
            continue;
        }
        if (ident_start(b[i])) {
            size_t s = i;
            while (i < b.size() && ident_char(b[i])) ++i;
            std::string id = b.substr(s, i - s);
            int k = arg_index(id);
            size_t j = i;
            while (j < b.size() && isspace((unsigned char)b[j])) ++j;
            bool pasted = j + 1 < b.size() && b[j] == '#' && b[j + 1] == '#';
            if (k >= 0) out += pasted ? arg_text(k) : expand(arg_text(k), hidden, depth + 1);
            else out += id;
            continue;
        }
        out += b[i++];
    }
    return out;
}

// Expand every macro in `text`.  `hidden` holds the macros currently being
// expanded so a self-referential macro stops instead of recursing forever.
// Comment: >30 lines because it must skip literals and handle both macro kinds.
std::string Preprocessor::expand(const std::string &text, std::set<std::string> &hidden, int depth) {
    if (depth > 64) return text;
    std::string out;
    size_t i = 0;
    while (i < text.size()) {
        char c = text[i];
        if (c == '"' || c == '\'') {
            char q = c;
            out += text[i++];
            while (i < text.size() && text[i] != q && text[i] != '\n') {
                if (text[i] == '\\' && i + 1 < text.size()) out += text[i++];
                out += text[i++];
            }
            if (i < text.size() && text[i] == q) out += text[i++];
            continue;
        }
        if (isdigit((unsigned char)c)) {           // pp-number: 1e5, 0x1F, 2.5f
            while (i < text.size() && (ident_char(text[i]) || text[i] == '.')) out += text[i++];
            continue;
        }
        if (!ident_start(c)) { out += text[i++]; continue; }
        size_t s = i;
        while (i < text.size() && ident_char(text[i])) ++i;
        std::string id = text.substr(s, i - s);
        auto it = macros_.find(id);
        if (it == macros_.end() || hidden.count(id)) { out += id; continue; }
        const Macro &m = it->second;
        if (!m.function_like) {
            hidden.insert(id);
            out += expand(m.body, hidden, depth + 1);
            hidden.erase(id);
            continue;
        }
        size_t j = i;
        while (j < text.size() && isspace((unsigned char)text[j])) ++j;
        if (j >= text.size() || text[j] != '(') { out += id; continue; }
        std::vector<std::string> args;
        size_t k = j;
        if (!collect_args(text, k, args)) { out += id; continue; }
        if (args.size() == 1 && trim_ws(args[0]).empty() && m.params.empty()) args.clear();
        // keep the newlines inside a multi-line invocation so line numbers stay put
        int newlines = 0;
        for (size_t p = i; p < k; ++p) if (text[p] == '\n') ++newlines;
        std::string body = substitute(m, args, hidden, depth);
        hidden.insert(id);
        out += expand(body, hidden, depth + 1);
        hidden.erase(id);
        out += std::string(newlines, '\n');
        i = k;
    }
    return out;
}

// Evaluate a #if expression: integers, defined(X), ! ~ unary -, * / % + -
// << >> < > <= >= == != & ^ | && || and parentheses.
struct CondEval {
    std::string s;
    size_t i = 0;
    bool bad = false;
    void ws() { while (i < s.size() && isspace((unsigned char)s[i])) ++i; }
    bool eat(const char *op) {
        ws();
        size_t n = strlen(op);
        if (s.compare(i, n, op) == 0) {
            // do not split "<<" into "<" or "&&" into "&"
            if (n == 1 && i + 1 < s.size() && (op[0] == '<' || op[0] == '>' || op[0] == '&' || op[0] == '|' || op[0] == '=') &&
                s[i + 1] == op[0]) return false;
            if (n == 1 && (op[0] == '<' || op[0] == '>' || op[0] == '!') && i + 1 < s.size() && s[i + 1] == '=') return false;
            i += n;
            return true;
        }
        return false;
    }
    long primary() {
        ws();
        if (eat("(")) { long v = expr(); eat(")"); return v; }
        if (eat("!")) return !primary();
        if (eat("~")) return ~primary();
        if (eat("-")) return -primary();
        if (eat("+")) return primary();
        if (i < s.size() && isdigit((unsigned char)s[i])) {
            char *end;
            long v = strtol(s.c_str() + i, &end, 0);
            i = end - s.c_str();
            while (i < s.size() && isalpha((unsigned char)s[i])) ++i;   // suffixes
            return v;
        }
        if (i < s.size() && s[i] == '\'') {
            ++i;
            long v = s[i] == '\\' ? s[++i] : s[i];
            while (i < s.size() && s[i] != '\'') ++i;
            ++i;
            return v;
        }
        if (i < s.size() && ident_start(s[i])) {     // unknown identifier = 0
            while (i < s.size() && ident_char(s[i])) ++i;
            return 0;
        }
        bad = true;
        return 0;
    }
    long mul() { long v = primary(); for (;;) { if (eat("*")) v *= primary(); else if (eat("/")) { long d = primary(); v = d ? v / d : 0; } else if (eat("%")) { long d = primary(); v = d ? v % d : 0; } else return v; } }
    long add() { long v = mul(); for (;;) { if (eat("+")) v += mul(); else if (eat("-")) v -= mul(); else return v; } }
    long shift() { long v = add(); for (;;) { if (eat("<<")) v <<= add(); else if (eat(">>")) v >>= add(); else return v; } }
    long rel() { long v = shift(); for (;;) { if (eat("<=")) v = v <= shift(); else if (eat(">=")) v = v >= shift(); else if (eat("<")) v = v < shift(); else if (eat(">")) v = v > shift(); else return v; } }
    long eq() { long v = rel(); for (;;) { if (eat("==")) v = v == rel(); else if (eat("!=")) v = v != rel(); else return v; } }
    long band() { long v = eq(); while (eat("&")) v &= eq(); return v; }
    long bxor() { long v = band(); while (eat("^")) v ^= band(); return v; }
    long bor() { long v = bxor(); while (eat("|")) v |= bxor(); return v; }
    long land() { long v = bor(); while (eat("&&")) { long r = bor(); v = v && r; } return v; }
    long lor() { long v = land(); while (eat("||")) { long r = land(); v = v || r; } return v; }
    long expr() {
        long c = lor();
        if (eat("?")) { long a = expr(); eat(":"); long b = expr(); return c ? a : b; }
        return c;
    }
};

long Preprocessor::eval_condition(const std::string &expr, int lineno) {
    // replace defined(X) / defined X before macro expansion
    std::string t;
    size_t i = 0;
    while (i < expr.size()) {
        if (expr.compare(i, 7, "defined") == 0 && (i == 0 || !ident_char(expr[i - 1])) &&
            (i + 7 >= expr.size() || !ident_char(expr[i + 7]))) {
            i += 7;
            while (i < expr.size() && isspace((unsigned char)expr[i])) ++i;
            bool paren = i < expr.size() && expr[i] == '(';
            if (paren) ++i;
            while (i < expr.size() && isspace((unsigned char)expr[i])) ++i;
            size_t s = i;
            while (i < expr.size() && ident_char(expr[i])) ++i;
            t += macros_.count(expr.substr(s, i - s)) ? " 1 " : " 0 ";
            if (paren) { while (i < expr.size() && expr[i] != ')') ++i; ++i; }
            continue;
        }
        t += expr[i++];
    }
    std::set<std::string> hidden;
    CondEval ev;
    ev.s = expand(t, hidden, 0);
    long v = ev.expr();
    if (ev.bad) res_.errors.push_back("line " + std::to_string(lineno) + ": invalid #if expression");
    return v;
}

// The single-line prelude placed in front of line 1.
std::string Preprocessor::prelude(const std::string &text) {
    auto user_typedefs = [&](const char *name) {
        std::regex r(std::string("typedef[^;]*\\b") + name + "\\s*;");
        return std::regex_search(text, r);
    };
    std::string p;
    bool own_file = user_typedefs("FILE");
    bool own_va = user_typedefs("va_list");
    if (!own_file)
        p += "typedef struct __fns_FILE { int fd; int mode; int ungot; int eof; int err; "
             "int pos; int reopen; char *name; } FILE; ";
    if (!user_typedefs("va_list")) p += "typedef char *va_list; ";
    if (!user_typedefs("size_t")) p += "typedef unsigned int size_t; ";
    if (runtime_) return p;
    for (const auto &e : LIB_PROTOS) {
        std::regex call(std::string("\\b") + e[0] + "\\s*\\(");
        std::regex addr(std::string("[=,(&]\\s*") + e[0] + "\\s*[;,)]");
        if (std::regex_search(text, call) || std::regex_search(text, addr)) {
            // the program's own FILE / va_list come later in the file than this
            // prelude, so their prototypes use void* instead
            std::string proto = e[1];
            if (own_file) proto = std::regex_replace(proto, std::regex("\\bFILE\\b"), "void");
            if (own_va) proto = std::regex_replace(proto, std::regex("\\bva_list\\b"), "char *");
            p += proto;
            p += ' ';
            res_.lib_protos.insert(e[0]);
        }
    }
    return p;
}

// Comment: >30 lines because it joins continued lines, routes directives,
// skips inactive regions and expands macros line by line.
PreprocessResult Preprocessor::run(const std::string &source) {
    std::string src = strip_comments(source);
    std::vector<std::string> lines;
    {
        std::string cur;
        for (char c : src) {
            if (c == '\n') { lines.push_back(cur); cur.clear(); }
            else if (c != '\r') cur += c;
        }
        lines.push_back(cur);
    }
    // Text between directives is expanded with the macros defined at that
    // point; a function-like macro call may span lines inside such a segment
    // (the newlines inside the call are preserved after the expansion).
    std::string expanded, pending;
    auto flush = [&]() {
        std::set<std::string> hidden;
        expanded += expand(pending, hidden, 0);
        pending.clear();
    };
    size_t n = lines.size();
    for (size_t ln = 0; ln < n; ++ln) {
        std::string line = lines[ln];
        size_t extra = 0;
        while (!line.empty() && line.back() == '\\' && ln + extra + 1 < n) {   // continuation
            line.pop_back();
            line += lines[ln + ++extra];
        }
        size_t first = line.find_first_not_of(" \t");
        std::string nl(1 + extra, '\n');
        if (ln + extra + 1 == n) nl.pop_back();      // no newline after the last line
        if (first != std::string::npos && line[first] == '#') {
            flush();
            directive(line, (int)ln + 1);
            expanded += nl;
        } else if (!active()) {
            flush();
            expanded += nl;
        } else {
            // __LINE__ is the line of the use (the macro may not appear in a string)
            if (line.find("__LINE__") != std::string::npos)
                line = std::regex_replace(line, std::regex("\\b__LINE__\\b"), std::to_string(ln + 1));
            pending += line + nl;
        }
        ln += extra;
    }
    flush();
    if (!conds_.empty()) res_.errors.push_back("line " + std::to_string(n) + ": unterminated #if");
    res_.text = prelude(expanded) + expanded;
    return res_;
}

}  // namespace

PreprocessResult preprocess(const std::string &source, bool cplusplus, bool runtime_mode,
                            const std::string &file_name) {
    Preprocessor pp(cplusplus, runtime_mode);
    pp.define_file(file_name);
    return pp.run(source);
}

}  // namespace fns
