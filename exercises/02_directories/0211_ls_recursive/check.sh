# checker spec for 0211 (see lib/engine.sh)
setup() { mkdir -p proyecto/{src/lib,docs,tests}; local d; for d in proyecto proyecto/src proyecto/src/lib proyecto/docs; do touch "$d/$(word).c" "$d/$(word).h"; done; }
extra_check() { must_use ls; }
