#!/usr/bin/env python3
"""List functions longer than 30 lines that have no comment right above them
(the assignment requires a comment on every function over 30 lines).
usage: tools/check_long_functions.py [files...]   (default: src/)"""
import glob
import re
import sys

NAME = re.compile(r'^[A-Za-z_][\w:<>,\*&\s~]*?\b([A-Za-z_~][\w:~]*)\s*\(')
SKIP = ('if', 'for', 'while', 'switch', 'return', 'else', 'do', 'sizeof')


def check(path):
    lines = open(path, encoding='utf-8', errors='replace').read().split('\n')
    bad = []
    i = 0
    while i < len(lines):
        m = NAME.match(lines[i])
        if not m or lines[i].startswith((' ', '\t', '#')) or m.group(1).split('::')[-1] in SKIP:
            i += 1
            continue
        # the signature may span several lines; the body starts at the first '{'
        j = i
        while j < len(lines) and j < i + 6 and '{' not in lines[j] and ';' not in lines[j]:
            j += 1
        if j >= len(lines) or '{' not in lines[j] or ';' in lines[j].split('{')[0]:
            i += 1
            continue
        depth, k = 0, j
        while k < len(lines):
            depth += lines[k].count('{') - lines[k].count('}')
            if depth == 0:
                break
            k += 1
        length = k - i + 1
        # the comment must end on the line directly above the signature
        prev = lines[i - 1].strip() if i > 0 else ''
        commented = prev.startswith('//') or prev.endswith('*/') or prev.startswith('*')
        if length > 30 and not commented:
            bad.append((i + 1, m.group(1), length))
        i = k + 1
    return bad


files = sys.argv[1:] or sorted(glob.glob('src/*.cpp') + glob.glob('src/lib/*.c') + ['src/parser.y', 'src/lexer.l'])
total = 0
for f in files:
    for line, name, n in check(f):
        print(f'{f}:{line}: {name} is {n} lines and has no comment')
        total += 1
print(f'{total} long function(s) without a comment')
sys.exit(1 if total else 0)
