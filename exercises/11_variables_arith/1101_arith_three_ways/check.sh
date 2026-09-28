# checker spec for 1101 (see lib/engine.sh)
SEEDS=1
extra_check() { must_use expr bc; ans_code | grep -q '\$((' || fail "use \$(( )) too"; }
