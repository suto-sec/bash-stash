# checker spec for 1126 (see lib/engine.sh)
SEEDS=1
extra_check() {
  must_use 'NOMBRE=Ada'
  ans_code | grep -qE '\$\{?NOMBRE' || fail "print the value with \$NOMBRE"
}
