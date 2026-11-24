#!/usr/bin/env bash
# Regression gate for the front end: grammar conflict counts, every IR-phase
# program in test/ir_phase/, IR structure checks and expected-error checks.
cd "$(dirname "$0")/.."
out=$(bison -Wcounterexamples -o /dev/null --defines=/dev/null src/parser.y 2>&1)
sr=$(printf '%s\n' "$out" | awk '/shift\/reduce/ { for (i = 1; i <= NF; i++) if ($i == "shift/reduce") { print $(i - 1); exit } }')
rr=$(printf '%s\n' "$out" | awk '/reduce\/reduce/ { for (i = 1; i <= NF; i++) if ($i == "reduce/reduce") { print $(i - 1); exit } }')
echo "conflicts: s/r=${sr:-0} r/r=${rr:-0}"
make -s >/dev/null 2>&1 || { echo "BUILD FAILED"; make 2>&1 | tail -5; exit 1; }
mkdir -p test/output
for f in test/ir_phase/*.c test/ir_phase/*.cpp; do
    name=$(basename "$f"); ir="test/output/${name%.*}.ir"
    log=$(./fnsc "$f" -o /dev/null --emit-ir "$ir" 2>&1)
    n=$(printf '%s\n' "$log" | awk '/Total errors:/ { print $3; exit }')
    sem=$(echo "$log" | grep -c "^  line" || true)
    printf "%-36s syntax-errors=%s errors=%s\n" "$name" "${n:-0}" "$sem"
done
python3 -I tools/check_ir.py $(ls test/output/*.ir | grep -v -e syntax_errors -e semantic_); rc1=$?
python3 -I tools/check_errors.py test/ir_phase/semantic_*.c test/ir_phase/semantic_*.cpp; rc2=$?
exit $(( rc1 || rc2 ))
