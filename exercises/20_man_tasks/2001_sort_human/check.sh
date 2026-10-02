# checker spec for 2001 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq "$(randr 6 9)"); do echo "$(randr 1 900)$(pick '' K M G) $(word)"; done > sizes.txt; }
extra_check() { must_use sort; }
