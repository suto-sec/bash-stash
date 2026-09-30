# checker spec for 0835 (see lib/engine.sh)
COMPARE="stdout exit files"
SEEDS=1
setup() { touch script.sh; chmod 644 script.sh; }
extra_check() { ans_code | grep -qE 'chmod +[0-7]{3}' && fail "use symbolic mode (u+x), not octal, in this exercise"; }
