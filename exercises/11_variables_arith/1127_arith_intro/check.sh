# checker spec for 1127 (see lib/engine.sh)
SEEDS=1
extra_check() { ans_code | grep -q '\$((' || fail "use \$(( ))"; }
