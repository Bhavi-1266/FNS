#!/usr/bin/env bash
# ===========================================================================
# run.sh - end-to-end test harness for the FNS compiler.
#
#   ./run.sh ./fnsc                 run every test
#   ./run.sh ./fnsc --show-ir       also print each program's three-address code
#   ./run.sh ./fnsc 16_classes      run only tests whose name contains "16_classes"
#   SIM=/path/to/spim ./run.sh ./fnsc
#
# For every program test/NN_name.c / .cpp it
#   1. compiles it with the given compiler, writing the MIPS assembly to
#      test/output/NN_name.s and the 3-address code IR to test/output/NN_name.ir;
#   2. runs the assembly on spim inside test/output/run/ (so files a test
#      creates stay there), with stdin from test/input/NN_name.in and
#      command-line arguments from test/args/NN_name.args when they exist;
#   3. drops spim's start-up banner, saves the output as test/output/NN_name.out
#      and compares it with test/expected/NN_name.expected (produced by
#      gcc/g++, see tools/make_expected.sh).
# Every program in test/errors/ must be REJECTED by the compiler; its error
# list is saved in test/output/errors/ and compared with test/errors/expected/.
# Exit status is 0 only when every test passes.
# ===========================================================================

set -u
CC="./fnsc"
SHOW_IR=0
FILTER=""
for a in "$@"; do
    case "$a" in
        --show-ir) SHOW_IR=1 ;;
        -h|--help) sed -n '3,22p' "$0"; exit 0 ;;
        -*) echo "unknown option $a"; exit 2 ;;
        *) if [ -x "$a" ] && [ ! -d "$a" ]; then CC="$a"; else FILTER="$a"; fi ;;
    esac
done
case "$CC" in /*) ;; *) CC="$(pwd)/$CC" ;; esac

SIM="${SIM:-spim}"
TESTDIR="test"
OUTDIR="test/output"
mkdir -p "$OUTDIR/run" "$OUTDIR/errors"

if [ ! -x "$CC" ]; then echo "error: compiler '$CC' not found (run make first)"; exit 2; fi
if ! command -v "$SIM" >/dev/null 2>&1; then
    echo "error: MIPS simulator '$SIM' not found on PATH."
    echo "       install it with:  sudo apt-get install spim"
    exit 2
fi
TIMEOUT=""
command -v timeout >/dev/null 2>&1 && TIMEOUT="timeout 60"

# Drop spim's start-up banner (the lines up to "Loaded: …exceptions.s") when it
# is present in the first lines; otherwise keep the output unchanged.
strip_banner() {
    local raw k
    raw=$(mktemp)
    cat > "$raw"
    k=$(head -n 8 "$raw" | grep -n '^Loaded:' | head -n 1 | cut -d: -f1)
    tail -n +$(( ${k:-0} + 1 )) "$raw"
    rm -f "$raw"
}

pass=0
fail=0
failed=""

# ---- positive tests: compile, run on spim, compare -----------------------
for src in "$TESTDIR"/*.c "$TESTDIR"/*.cpp; do
    [ -e "$src" ] || continue
    name="$(basename "$src")"
    stem="${name%.*}"
    case "$stem" in *"$FILTER"*) ;; *) continue ;; esac
    asm="$OUTDIR/$stem.s"
    ir="$OUTDIR/$stem.ir"
    exp="$TESTDIR/expected/$stem.expected"
    in="$TESTDIR/input/$stem.in"
    args=""
    [ -f "$TESTDIR/args/$stem.args" ] && args="$(cat "$TESTDIR/args/$stem.args")"

    if ! "$CC" "$src" -o "$asm" --emit-ir "$ir" > "$OUTDIR/$stem.log" 2>&1; then
        echo "FAIL  $name  (compilation failed)"
        sed 's/^/        /' "$OUTDIR/$stem.log"
        fail=$((fail + 1)); failed="$failed $name"
        continue
    fi
    [ "$SHOW_IR" -eq 1 ] && { echo "----- IR for $name -----"; cat "$ir"; }

    if [ -f "$in" ]; then in="$(pwd)/$in"; else in=/dev/null; fi
    # shellcheck disable=SC2086
    (cd "$OUTDIR/run" && $TIMEOUT "$SIM" -file "../$stem.s" $args < "$in" 2>&1) \
        | strip_banner > "$OUTDIR/$stem.out"

    if [ ! -f "$exp" ]; then
        echo "?     $name  (no expected output; got test/output/$stem.out)"
        continue
    fi
    if diff -q "$exp" "$OUTDIR/$stem.out" >/dev/null; then
        echo "PASS  $name"
        pass=$((pass + 1))
    else
        echo "FAIL  $name   (diff: expected < > got)"
        diff "$exp" "$OUTDIR/$stem.out" | head -20 | sed 's/^/        /'
        fail=$((fail + 1)); failed="$failed $name"
    fi
done

# ---- negative tests: the compiler must report errors -----------------------
for src in "$TESTDIR"/errors/*.c "$TESTDIR"/errors/*.cpp; do
    [ -e "$src" ] || continue
    name="$(basename "$src")"
    stem="${name%.*}"
    case "$stem" in *"$FILTER"*) ;; *) continue ;; esac
    log="$OUTDIR/errors/$stem.err"
    "$CC" "$src" -o "$OUTDIR/errors/$stem.s" > "$OUTDIR/errors/$stem.log" 2>&1
    rc=$?
    sed -n '/^Errors:/,$p' "$OUTDIR/errors/$stem.log" > "$log"
    exp="$TESTDIR/errors/expected/$stem.err"
    if [ "$rc" -ne 1 ]; then
        echo "FAIL  errors/$name  (expected a compile error, exit status $rc)"
        fail=$((fail + 1)); failed="$failed errors/$name"
    elif [ -f "$exp" ] && ! diff -q "$exp" "$log" >/dev/null; then
        echo "FAIL  errors/$name  (different diagnostics: expected < > got)"
        diff "$exp" "$log" | sed 's/^/        /'
        fail=$((fail + 1)); failed="$failed errors/$name"
    else
        echo "PASS  errors/$name  ($(grep -c '^  ' "$log") error(s) reported)"
        pass=$((pass + 1))
    fi
done

echo "------------------------------------------------------------"
echo "Passed: $pass   Failed: $fail"
echo "Assembly (.s), IR (.ir) and program output (.out) are in $OUTDIR/"
[ -n "$failed" ] && echo "Failures:$failed"
[ "$fail" -eq 0 ]
