#!/usr/bin/env python3
"""Wrap a generated program with an SPIM startup that supplies argv values.

SPIM 9.1 on macOS ignores program arguments after -file. This adapter is used
only by the regression harness when that behavior is detected; normal compiler
output still uses SPIM's standard __start startup path.
"""
import json
import pathlib
import sys


source = pathlib.Path(sys.argv[1]).read_text()
target = pathlib.Path(sys.argv[2])
args = pathlib.Path(sys.argv[3]).read_text().split()

source = source.replace(".globl main\n", ".globl __fns_test_main\n", 1)
source = source.replace("\nmain:\n", "\n__fns_test_main:\n", 1)
data = ["\n.data", "__fns_test_argv0: .asciiz \"program\""]
for i, arg in enumerate(args):
    data.append(f"__fns_test_arg{i}: .asciiz {json.dumps(arg)}")
data.append(".align 2")
data.append("__fns_test_argv:")
data.append("    .word __fns_test_argv0")
for i in range(len(args)):
    data.append(f"    .word __fns_test_arg{i}")
data.append("    .word 0")
data.extend([
    ".text",
    ".globl main",
    "main:",
    f"    li $a0, {len(args) + 1}",
    "    la $a1, __fns_test_argv",
    "    move $a2, $zero",
    "    jal __fns_test_main",
    "    nop",
    "    li $v0, 10",
    "    syscall",
])
target.write_text(source + "\n" + "\n".join(data) + "\n")
