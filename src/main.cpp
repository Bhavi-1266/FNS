#include <cstdio>
#include <cctype>
#include <cstring>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#include "ast.hpp"
#include "codegen.hpp"
#include "decl_table.hpp"
#include "ir.hpp"
#include "mips.hpp"
#include "optimize.hpp"
#include "preprocess.hpp"
#include "symbol_table.hpp"

extern FILE *yyin;
extern bool fns_cplusplus;
int yyparse();

// Derive "<stem>.s" (or another extension) from an input path.
static std::string with_ext(const std::string &input, const std::string &ext) {
    std::string base = input;
    size_t slash = base.find_last_of('/');
    if (slash != std::string::npos) base = base.substr(slash + 1);
    size_t dot = base.find_last_of('.');
    if (dot != std::string::npos) base = base.substr(0, dot);
    return base + ext;
}

static void usage(const char *prog) {
    std::cerr << "usage: " << prog << " source.c|source.cpp [options]\n"
              << "  Compiles an FNS source file to MIPS32 assembly for the spim simulator.\n"
              << "options:\n"
              << "  -o FILE           write the assembly to FILE (default: <stem>.s)\n"
              << "  --emit-ir [FILE]  also write the three-address code (default: <stem>.ir)\n"
              << "  --print-ir        print the three-address code on standard output\n"
              << "  -O0               do not optimise the three-address code (default: optimise)\n"
              << "  -E                print the preprocessed source and stop\n"
              << "  --runtime         compile the runtime library (used by the makefile)\n"
              << "run the result with:  spim -file out.s [program arguments]\n";
}

struct Options {
    std::string input, asm_out, ir_out;
    bool want_ir = false, print_ir = false, only_pp = false, runtime = false, optimize = true;
};

static int parse_options(int argc, char **argv, Options &o) {
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "-o" && i + 1 < argc) o.asm_out = argv[++i];
        else if (a == "--emit-ir") {
            o.want_ir = true;
            if (i + 1 < argc && argv[i + 1][0] != '-' && o.input.size()) o.ir_out = argv[++i];
            else if (i + 1 < argc && argv[i + 1][0] != '-' && std::string(argv[i + 1]).find(".ir") != std::string::npos)
                o.ir_out = argv[++i];
        } else if (a == "--print-ir" || a == "-ir") o.print_ir = true;
        else if (a == "-E") o.only_pp = true;
        else if (a == "-O0") o.optimize = false;
        else if (a == "-O" || a == "-O1") o.optimize = true;
        else if (a == "--runtime") o.runtime = true;
        else if (a == "-h" || a == "--help") { usage(argv[0]); return 0; }
        else if (a[0] != '-' && o.input.empty()) o.input = a;
        else { usage(argv[0]); return 2; }
    }
    if (o.input.empty()) { usage(argv[0]); return 2; }
    if (o.asm_out.empty()) o.asm_out = with_ext(o.input, ".s");
    if (o.want_ir && o.ir_out.empty()) o.ir_out = with_ext(o.input, ".ir");
    return -1;
}

// Comment: >30 lines because it drives the whole pipeline: preprocessing,
// parsing, IR generation, error reporting, the optional IR dump and the
// MIPS assembly output.
int main(int argc, char **argv) {
    if (argc < 2) { usage(argv[0]); return 2; }
    Options opt;
    int rc = parse_options(argc, argv, opt);
    if (rc >= 0) return rc;

    std::ifstream in(opt.input);
    if (!in) { perror(opt.input.c_str()); return 2; }
    std::stringstream raw;
    raw << in.rdbuf();
    bool cpp = opt.input.size() > 4 && (opt.input.substr(opt.input.size() - 4) == ".cpp" ||
                                       opt.input.substr(opt.input.size() - 3) == ".cc");
    fns::PreprocessResult pp = fns::preprocess(raw.str(), cpp, opt.runtime, opt.input);
    if (opt.only_pp) { std::cout << pp.text; return pp.errors.empty() ? 0 : 1; }

    fns_cplusplus = cpp;
    static std::string source_text;
    source_text = pp.text;
    yyin = fmemopen(&source_text[0], source_text.size(), "r");
    if (!yyin) { perror("fmemopen"); return 2; }
    yyparse();
    fclose(yyin);

    fns::DeclTable &table = fns::DeclTable::instance();
    fns::SymbolTable &lex = fns::SymbolTable::instance();
    fns::Module mod;
    mod.source = opt.input;

    std::cout << "Compiling: " << opt.input << "\n";
    if (lex.has_errors()) lex.print_errors();
    if (table.has_errors()) table.print_errors();
    for (const auto &e : pp.errors) mod.errors.push_back(e);

    bool front_errors = lex.has_errors() || table.has_errors();
    if (front_errors) {
        for (const auto &e : table.errors())
            mod.errors.push_back("line " + std::to_string(e.line) + ": " + e.message);
        for (const auto &e : lex.errors())
            mod.errors.push_back("line " + std::to_string(e.line) +
                                 ": unexpected character '" + e.text + "'");
    } else if (fns::g_ast_root) {
        fns::CodeGen gen(mod);
        gen.set_library_prototypes(pp.lib_protos);
        gen.set_cplusplus(cpp);
        gen.generate(fns::g_ast_root);
    }

    // every external call must be satisfied by the runtime library
    if (!front_errors) {
        for (const auto &e : mod.externs) {
            bool ok = opt.runtime ? e.rfind("__sys_", 0) == 0 : fns::runtime_provides(e);
            if (!ok) mod.errors.push_back("undefined reference to function '" + e + "'");
        }
    }

    // a construct the front end could not lower is an error, not a note
    for (const auto &n : mod.notes) mod.errors.push_back(n);

    if (mod.errors.empty() && opt.optimize) {
        fns::OptStats st = fns::optimize(mod);
        std::cout << "Optimised IR: " << st.folded << " constant(s) folded, " << st.constants
                  << " constant(s) and " << st.copies << " copy(ies) propagated, " << st.reduced
                  << " strength reduction(s), " << st.removed << " instruction(s) removed\n";
    }

    if (opt.want_ir) {
        std::ofstream irf(opt.ir_out);
        mod.write(irf);
    }
    if (opt.print_ir) mod.write(std::cout);

    if (!mod.errors.empty()) {
        std::cout << "Errors:\n";
        for (const auto &e : mod.errors) std::cout << "  " << e << "\n";
        std::cout << "No assembly generated (" << mod.errors.size() << " error(s)).\n";
        return 1;
    }

    std::ostringstream code;
    std::vector<std::string> unsupported;
    fns::emit_mips(mod, code, unsupported, opt.runtime);
    if (!unsupported.empty()) {
        std::cout << "Errors:\n";
        for (const auto &u : unsupported) std::cout << "  not supported by the MIPS back end: " << u << "\n";
        std::cout << "No assembly generated (" << unsupported.size() << " error(s)).\n";
        return 1;
    }
    std::ofstream out(opt.asm_out);
    if (!out) { perror(opt.asm_out.c_str()); return 2; }
    out << code.str();
    out.close();

    std::cout << "Assembly written to " << opt.asm_out << " (" << mod.funcs.size()
              << " function(s))\n";
    if (!opt.runtime) {
        // spim's default text segment holds 64 KB = 16384 instructions
        std::ifstream check(opt.asm_out);
        std::string line;
        long words = 0;
        bool text = false;
        while (std::getline(check, line)) {
            if (line.rfind(".text", 0) == 0) text = true;
            else if (line.rfind(".data", 0) == 0) text = false;
            else if (text && line.rfind("    ", 0) == 0 && line.size() > 4 && isalpha((unsigned char)line[4])) {
                words++;
                if (line.rfind("    li ", 0) == 0 || line.rfind("    la ", 0) == 0) words++;   // may expand to 2
            }
        }
        if (words > 16000)
            std::cout << "Warning: the program needs about " << words << " instructions, more than spim's\n"
                      << "  default 64 KB text segment; run it with:  spim -stext 262144 -file "
                      << opt.asm_out << "\n";
    }
    if (opt.want_ir) std::cout << "IR written to " << opt.ir_out << "\n";
    return 0;
}
