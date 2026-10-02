# checker spec for 2006 (see lib/engine.sh)
SEEDS=3
setup() { local f n=1; for f in $(words 5); do bigfile "$f" $(( n * 137 + $(randr 0 90) )); n=$(( n + $(randr 1 3) )); done; }
extra_check() { must_use ls; }
