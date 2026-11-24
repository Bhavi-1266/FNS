#!/usr/bin/env bash
# Regression gate for the front end: grammar conflict counts, every IR-phase
# program in test/ir_phase/, IR structure checks and expected-error checks.
cd "$(dirname "$0")/.."
fail=0
out=$(bison -Wcounterexamples -o /dev/null --defines=/dev/null src/parser.y 2>&1) ||
    { echo "FAIL bison could not process src/parser.y"; printf '%s\n' "$out" | tail -5; exit 1; }
sr=$(printf '%s\n' "$out" | awk '/shift\/reduce/ { for (i = 1; i <= NF; i++) if ($i == "shift/reduce") { print $(i - 1); exit } }')
rr=$(printf '%s\n' "$out" | awk '/reduce\/reduce/ { for (i = 1; i <= NF; i++) if ($i == "reduce/reduce") { print $(i - 1); exit } }')
echo "conflicts: s/r=${sr:-0} r/r=${rr:-0}"
if [ "${sr:-0}" -ne 0 ] || [ "${rr:-0}" -ne 0 ]; then echo "FAIL grammar has conflicts"; fail=1; fi
make -s >/dev/null 2>&1 || { echo "BUILD FAILED"; make 2>&1 | tail -5; exit 1; }
mkdir -p test/output
for f in test/ir_phase/*.c test/ir_phase/*.cpp; do
    name=$(basename "$f"); ir="test/output/${name%.*}.ir"
    rm -f "$ir"
    log=$(./fnsc "$f" -o /dev/null --emit-ir "$ir" 2>&1); rc=$?
    n=$(printf '%s\n' "$log" | awk '/Total errors:/ { print $3; exit }')
    sem=$(echo "$log" | grep -c "^  line" || true)
    printf "%-36s syntax-errors=%s errors=%s\n" "$name" "${n:-0}" "$sem"
    case "$name" in
        valid_*) # must compile cleanly and produce a fresh IR file for check_ir.py
            if [ $rc -ne 0 ] || [ "${n:-0}" -ne 0 ] || [ "$sem" -ne 0 ] || [ ! -s "$ir" ]; then
                echo "FAIL $name did not compile cleanly (exit $rc)"; fail=1
            fi ;;
        *)       # deliberate error files must be rejected
            if [ $rc -eq 0 ]; then echo "FAIL $name was accepted but contains deliberate errors"; fail=1; fi ;;
    esac
done
python3 -I tools/check_ir.py $(ls test/output/*.ir | grep -v -e syntax_errors -e semantic_); rc1=$?
python3 -I tools/check_errors.py test/ir_phase/semantic_*.c test/ir_phase/semantic_*.cpp; rc2=$?
exit $(( fail || rc1 || rc2 ))
