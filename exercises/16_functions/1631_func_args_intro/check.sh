# checker spec for 1631 (see lib/engine.sh)
SEEDS=1
ARGS=('Ana' 'Luis')
extra_check() { ans_code | grep -qE 'saluda *\(\)|function +saluda' || fail "define the function saluda() { ...; }"; }
