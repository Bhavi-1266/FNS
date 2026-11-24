# FNS (Friendly Neighbourhood Spiderman) compiler: source -> MIPS32 assembly (spim)
#
# Build is two-stage:
#   1. build/fnsc-boot  - the compiler without a C library;
#   2. it compiles the runtime library src/lib/libfns.c to src/lib/libfns.s;
#   3. ./fnsc           - the final compiler, with libfns.s embedded.
CXX := g++
CXXFLAGS := -std=c++17 -O1 -Wall -Wextra -Isrc -Ibuild
BISON := bison
FLEX := flex

EXE := fnsc
BUILD := build
BISON_CPP := $(BUILD)/parser.tab.cc
BISON_HDR := $(BUILD)/parser.tab.hpp
LEXER_CPP := $(BUILD)/lex.yy.cc
RUNTIME_INC := $(BUILD)/runtime_asm.inc
LIB_SRC := src/lib/libfns.c
LIB_ASM := src/lib/libfns.s
LIB_INC := $(BUILD)/libfns_asm.inc

HDRS := src/ast.hpp src/ir.hpp src/codegen.hpp src/decl_table.hpp src/symbol_table.hpp \
        src/keywords.hpp src/token.hpp src/mips.hpp src/preprocess.hpp
COMMON_OBJS := $(BUILD)/parser.tab.o $(BUILD)/lex.yy.o $(BUILD)/decl_table.o \
        $(BUILD)/symbol_table.o $(BUILD)/keywords.o $(BUILD)/token.o $(BUILD)/ir.o \
        $(BUILD)/codegen.o $(BUILD)/preprocess.o $(BUILD)/main.o

.PHONY: all help test check run clean

all: $(EXE)

help:
	@echo "FNS (Friendly Neighbourhood Spiderman) compiler: source -> MIPS32 assembly"
	@echo "  make              Build ./$(EXE)"
	@echo "  make test         Build, run every test on spim and print each test's 3AC IR"
	@echo "                    (./run.sh ./$(EXE) --show-ir; IR also saved in test/output/*.ir)"
	@echo "  make check        Same tests without printing the IR (PASS/FAIL only)"
	@echo "  make run FILE=x   Compile one source file (writes x.s and x.ir)"
	@echo "  make clean        Remove generated files and outputs"

$(BUILD):
	@mkdir -p $(BUILD)

# ---- generated front end ----
$(BISON_CPP) $(BISON_HDR): src/parser.y src/ast.hpp src/decl_table.hpp | $(BUILD)
	$(BISON) -d --defines=$(BISON_HDR) -o $(BISON_CPP) src/parser.y

$(LEXER_CPP): src/lexer.l $(BISON_HDR) src/decl_table.hpp | $(BUILD)
	$(FLEX) -o $@ src/lexer.l

# ---- objects ----
$(BUILD)/parser.tab.o: $(BISON_CPP) $(HDRS)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/lex.yy.o: $(LEXER_CPP) $(BISON_HDR) $(HDRS)
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(BUILD)/%.o: src/%.cpp $(HDRS) $(BISON_HDR) | $(BUILD)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Embed an assembly file as a C++ raw string literal.
$(RUNTIME_INC): src/runtime.s | $(BUILD)
	@printf 'R"FNSRT(\n' > $@
	@cat $< >> $@
	@printf '\n)FNSRT"\n' >> $@

$(LIB_INC): $(LIB_ASM) | $(BUILD)
	@printf 'R"FNSRT(\n' > $@
	@cat $< >> $@
	@printf '\n)FNSRT"\n' >> $@

# ---- stage 1: bootstrap compiler (no C library) ----
$(BUILD)/mips_boot.o: src/mips.cpp $(HDRS) $(RUNTIME_INC)
	$(CXX) $(CXXFLAGS) -DFNS_BOOTSTRAP -c -o $@ $<

$(BUILD)/fnsc-boot: $(COMMON_OBJS) $(BUILD)/mips_boot.o
	$(CXX) $(CXXFLAGS) -o $@ $^

# ---- stage 2: the runtime library, compiled by fnsc itself ----
$(LIB_ASM): $(LIB_SRC) $(BUILD)/fnsc-boot
	$(BUILD)/fnsc-boot --runtime $(LIB_SRC) -o $(LIB_ASM) > $(BUILD)/libfns.log || { cat $(BUILD)/libfns.log; exit 1; }

# ---- stage 3: the final compiler ----
$(BUILD)/mips.o: src/mips.cpp $(HDRS) $(RUNTIME_INC) $(LIB_INC)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(EXE): $(COMMON_OBJS) $(BUILD)/mips.o
	$(CXX) $(CXXFLAGS) -o $@ $^

# `make test` prints the three-address code of every test program before its
# PASS/FAIL line; the IR of each test is also kept in test/output/NN_name.ir.
test: $(EXE)
	bash run.sh ./$(EXE) --show-ir

check: $(EXE)
	bash run.sh ./$(EXE)

run: $(EXE)
	@test -n "$(FILE)" || { echo "usage: make run FILE=path/to/source.c"; exit 1; }
	./$(EXE) "$(FILE)" --emit-ir

clean:
	rm -rf $(BUILD) $(EXE) $(LIB_ASM) test/output
	rm -f *.ir *.s decl_table.txt symbol_table.txt
