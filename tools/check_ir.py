#!/usr/bin/env python3
"""Sanity checker for FNS (Friendly Neighbourhood Spiderman) 3AC files.

Per function: every jump target is a label defined exactly once, every temporary is
assigned before it is read, and every direct call names a defined function, a known
external, a lambda, or a constructor/destructor emitted in the file.
"""
import re
import sys

TEMP = re.compile(r"\bt\d+\b")
LABEL_DEF = re.compile(r"^([A-Za-z_]\w*):$")
JUMP = re.compile(r"\bgoto (\w+)")
CALL = re.compile(r"\bcall (\*?)(\w+), (\d+)")
ASSIGN = re.compile(r"^(t\d+) = ")


def check(path):
    problems = []
    text = open(path).read().splitlines()
    if any(l.startswith("; Errors") for l in text):
        return problems, 0
    funcs = set()
    externs = set()
    section = None
    for l in text:
        if l.startswith("function "):
            funcs.add(l.split()[1].split("(")[0])
        elif l.strip() == ".extern":
            section = "extern"
        elif l.startswith("."):
            section = None
        elif section == "extern" and l.strip():
            externs.add(l.strip())
    unsupported = sum(1 for l in text if "unsupported:" in l)

    cur = None
    for l in text:
        if l.startswith("function "):
            cur = {"name": l.split()[1].split("(")[0], "labels": {}, "jumps": [], "assigned": set(), "lines": []}
            continue
        if l.startswith("endfunction"):
            for lab, n in cur["labels"].items():
                if n != 1:
                    problems.append(f"{cur['name']}: label {lab} defined {n} times")
            for lab, ln in cur["jumps"]:
                if lab not in cur["labels"]:
                    problems.append(f"{cur['name']}: jump to undefined label {lab} ({ln})")
            cur = None
            continue
        if cur is None:
            continue
        s = l.strip()
        if s.startswith(";") or s.startswith("local "):
            continue
        m = LABEL_DEF.match(s)
        if m:
            cur["labels"][m.group(1)] = cur["labels"].get(m.group(1), 0) + 1
            continue
        code = s.split(" ; ")[0]
        m = JUMP.search(code)
        if m:
            cur["jumps"].append((m.group(1), code))
        m = CALL.search(code)
        if m and not m.group(1):
            name = m.group(2)
            if name not in funcs and name not in externs:
                problems.append(f"{cur['name']}: call to unknown function {name}")
        dst = ASSIGN.match(code)
        rhs = code[len(dst.group(0)):] if dst else code
        for t in TEMP.findall(rhs):
            if t not in cur["assigned"]:
                problems.append(f"{cur['name']}: {t} read before assignment in '{code}'")
        if dst:
            cur["assigned"].add(dst.group(1))
    return problems, unsupported


def main():
    status = 0
    for path in sys.argv[1:]:
        problems, unsupported = check(path)
        tag = "OK " if not problems and not unsupported else "BAD"
        print(f"{tag} {path}: {len(problems)} problem(s), {unsupported} unsupported")
        for p in problems:
            print("     " + p)
        if problems or unsupported:
            status = 1
    sys.exit(status)


if __name__ == "__main__":
    main()
