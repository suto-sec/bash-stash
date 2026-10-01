# checker spec for 0125 (see lib/engine.sh)
SEEDS=1
extra_check() {
  must_use 'NOMBRE=Kernel'
  ans_code | grep -qF "'Hola \$NOMBRE'" || fail "print the first line with single quotes: 'Hola \$NOMBRE'"
  ans_code | grep -qE '"Hola \$\{?NOMBRE\}?"' || fail "print the second line with double quotes and the variable: \"Hola \$NOMBRE\""
}
