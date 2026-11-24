#!/usr/bin/env bash
# Regenerate test/expected/*.expected with the host gcc / g++ as the reference
# compiler, so the expected outputs do not come from fnsc itself.
#   - the FNS-only loop `do ... until (c);` is compiled as do ... while (!(c));
#   - each program runs in a scratch directory with the same stdin
#     (test/input/NAME.in) and arguments (test/args/NAME.args) that run.sh uses.
# The negative tests' expected diagnostics (test/errors/expected/*.err) are
# produced by fnsc and were checked by hand.
set -u
cd "$(dirname "$0")/.."
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p test/expected
for src in test/*.c test/*.cpp; do
    name=$(basename "$src"); stem=${name%.*}
    case "$src" in *.cpp) cc="g++ -w" ;; *) cc="gcc -w" ;; esac
    if ! $cc -D'until(c)=while(!(c))' -o "$work/$stem" "$src" -lm; then
        echo "reference compile failed: $src"; continue
    fi
    in=/dev/null; [ -f "test/input/$stem.in" ] && in="$(pwd)/test/input/$stem.in"
    args=""; [ -f "test/args/$stem.args" ] && args=$(cat "test/args/$stem.args")
    mkdir -p "$work/run_$stem"
    # shellcheck disable=SC2086
    (cd "$work/run_$stem" && "$work/$stem" $args < "$in" > "$work/$stem.out" 2>&1)
    cp "$work/$stem.out" "test/expected/$stem.expected"
    echo "expected output written for $name"
done
if [ -x ./fnsc ]; then
    mkdir -p test/errors/expected
    for src in test/errors/*.c test/errors/*.cpp; do
        name=$(basename "$src"); stem=${name%.*}
        ./fnsc "$src" -o /dev/null | sed -n '/^Errors:/,$p' > "test/errors/expected/$stem.err"
    done
fi
