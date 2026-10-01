# checker spec for 1127 (see lib/engine.sh)
SEEDS=1
extra_check() {
  must_use 'A=6' 'B=7'
  ans_code | grep -q '\$((' || fail "use \$(( ))"
}
