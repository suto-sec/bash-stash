# checker spec for 0565 (see lib/engine.sh)
SEEDS=1
input() { words "$(randr 3 6)"; }
extra_check() { must_use tr; }
