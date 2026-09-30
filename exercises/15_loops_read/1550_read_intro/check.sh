# checker spec for 1550 (see lib/engine.sh)
SEEDS=3
input() { words "$(randr 1 4)"; }
extra_check() { must_use read; }
