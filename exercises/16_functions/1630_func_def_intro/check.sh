# checker spec for 1630 (see lib/engine.sh)
SEEDS=1
extra_check() { ans_code | grep -qE 'saluda *\(\)|function +saluda' || fail "define the function saluda() { ...; }"; }
