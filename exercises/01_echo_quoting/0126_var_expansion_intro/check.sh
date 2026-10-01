# checker spec for 0126 (see lib/engine.sh)
SEEDS=1
extra_check() {
  must_use 'CURSO=so'
  ans_code | grep -qF '${CURSO}' || fail "use the braces: \${CURSO}"
}
