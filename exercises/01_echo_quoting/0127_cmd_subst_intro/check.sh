# checker spec for 0127 (see lib/engine.sh)
SEEDS=1
extra_check() {
  must_use whoami
  ans_code | grep -qF '$(' || fail "use \$( ) command substitution"
}
