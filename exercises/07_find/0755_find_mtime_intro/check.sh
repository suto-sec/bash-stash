# checker spec for 0755 (see lib/engine.sh)
SEEDS=1
setup() { mkdir logs; local i; for i in $(seq 5); do touch -d "$(pick 1 3 8 15 20) days ago" "logs/f$i.log"; done; }
extra_check() { must_use find sort; }
