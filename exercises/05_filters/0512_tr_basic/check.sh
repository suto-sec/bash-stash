# checker spec for 0512 (see lib/engine.sh)
input() { local i; for i in $(seq 4); do echo "$(word):$(word) $(word):$(randr 1 99)"; done; }
extra_check() { must_use tr; }
