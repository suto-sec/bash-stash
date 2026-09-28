# checker spec for 0708 (see lib/engine.sh)
setup() { mkdir logs; local i; for i in $(seq 8); do touch -d "$(pick 1 2 5 9 15 30) days ago" "logs/$(word)$i.log"; done; touch -d "4 days ago" logs/referencia; }
