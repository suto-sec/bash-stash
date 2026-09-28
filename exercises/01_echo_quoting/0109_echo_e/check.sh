# checker spec for 0109 (see lib/engine.sh)
SEEDS=1
extra_check() { (( $(ans_code | grep -o 'echo' | wc -l) == 2 )) || fail "use exactly two echo commands"; }
