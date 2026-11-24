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
SIM ?= spim
TEST_LOG := test/output/test_results.txt
RUN_FILE := $(or $(FILE),$(RUN))
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
	@echo "  make test         Build and run every test on spim; PASS/FAIL on the terminal,"
	@echo "                    full output (each test's 3AC IR, program output, results)"
	@echo "                    saved in $(TEST_LOG)"
	@echo "  make check        Same tests, PASS/FAIL only, nothing extra saved"
	@echo "  make run FILE=x   Compile x, print its 3AC IR and MIPS assembly, run it on spim"
	@echo "                    (RUN=x works too; program arguments: ARGS=\"a b\")"
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

# `make test` runs every test; the terminal shows the PASS/FAIL lines and the
# whole output (each test's 3AC IR, its program output and the results) is
# saved in $(TEST_LOG). The IR of each test is also kept in test/output/NN_name.ir.
test: $(EXE)
	bash run.sh ./$(EXE) --show-ir --log $(TEST_LOG)

check: $(EXE)
	bash run.sh ./$(EXE)

# `make run FILE=x.c` (or RUN=x.c): compile one file, print its 3AC IR and its
# MIPS assembly on the terminal (also kept in x.ir and x.s), then run it on spim.
# Program arguments: ARGS="a b c".
run: $(EXE)
	@test -n "$(RUN_FILE)" || { echo "usage: make run FILE=path/to/source.c [ARGS=\"arg1 arg2\"]"; exit 1; }
	@stem=$$(basename "$(RUN_FILE)"); stem=$${stem%.*}; \
	./$(EXE) "$(RUN_FILE)" -o "$$stem.s" --emit-ir "$$stem.ir" || exit $$?; \
	echo "==================== 3AC IR: $$stem.ir ===================="; \
	cat "$$stem.ir"; \
	echo "==================== MIPS assembly: $$stem.s ===================="; \
	cat "$$stem.s"; \
	if command -v $(SIM) >/dev/null 2>&1; then \
	    echo "==================== program output: $(SIM) -file $$stem.s $(ARGS) ===================="; \
	    $(SIM) -file "$$stem.s" $(ARGS); \
	else \
	    echo "(spim not found: run it with  spim -file $$stem.s $(ARGS))"; \
	fi

clean:
	rm -rf $(BUILD) $(EXE) $(LIB_ASM) test/output
	rm -f *.ir *.s decl_table.txt symbol_table.txt
