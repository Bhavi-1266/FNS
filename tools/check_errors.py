#!/usr/bin/env python3
"""Expected-error checker for FNS negative tests.

A negative test marks each line that must produce a semantic error with a comment:

    int e = s1 + s2;    /* expect: operator '+' requires arithmetic operands */
    class X { ... };    /* expect@0: reference member 'r' requires an initializer */

`expect:` requires an error on that same line whose text contains the message.
`expect@0:` is for diagnostics the compiler currently reports without a line number.
A line may carry several markers separated by ` ;; `.

usage: check_errors.py <source>... (the matching .ir is read from test/output/)
Exit status 1 if any expected error is missing or any unexpected error is reported.
"""
import os
import re
import sys

MARK = re.compile(r"expect(@0)?:\s*(.*?)\s*(?:\*/\s*)?$")
ERR = re.compile(r"^;\s+line (\d+): (.*)$")


def expectations(path):
    exp = []  # (line, msg)
    for n, text in enumerate(open(path, encoding="utf-8"), 1):
        if "expect" not in text:
            continue
        comment = text.split("/*", 1)[1] if "/*" in text else text.split("//", 1)[1] if "//" in text else ""
        for piece in comment.split(";;"):
            m = MARK.search(piece.strip())
            if m:
                exp.append((0 if m.group(1) else n, m.group(2)))
    return exp


def reported(ir_path):
    out = []
    for text in open(ir_path, encoding="utf-8"):
        m = ERR.match(text.rstrip())
        if m:
            out.append((int(m.group(1)), m.group(2)))
    return out


def main(argv):
    bad = 0
    for src in argv:
        name = os.path.basename(src)
        ir = os.path.join("test", "output", os.path.splitext(name)[0] + ".ir")
        if not os.path.exists(ir):
            print(f"MISSING {name}: no {ir}")
            bad += 1
            continue
        exp = expectations(src)
        got = reported(ir)
        if not exp:
            if got:
                print(f"BAD  {name}: no expectations but {len(got)} error(s) reported")
                for ln, msg in got:
                    print(f"       line {ln}: {msg}")
                bad += 1
            else:
                print(f"OK   {name}: no errors expected, none reported")
            continue
        unmatched = list(got)
        missing = []
        for ln, msg in exp:
            hit = next((g for g in unmatched if g[0] == ln and msg in g[1]), None)
            if hit is None:
                missing.append((ln, msg))
            else:
                unmatched.remove(hit)
        if missing or unmatched:
            bad += 1
            print(f"BAD  {name}: {len(exp)} expected, {len(got)} reported")
            for ln, msg in missing:
                print(f"       missing    line {ln}: {msg}")
            for ln, msg in unmatched:
                print(f"       unexpected line {ln}: {msg}")
        else:
            print(f"OK   {name}: {len(exp)} expected error(s) all reported, nothing extra")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
