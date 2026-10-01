# checker spec for 0754 (see lib/engine.sh)
SEEDS=1
setup() { mkdir -p files; local i; for i in $(seq 5); do bigfile "files/f$i" "$(pick 100 5000 1500000 2200000 900)"; done; }
extra_check() { must_use find sort; }
