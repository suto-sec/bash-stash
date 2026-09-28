# checker spec for 0406 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir logs; local i; for i in 1 2 3; do randtext 4 > "logs/$(word)$i.log"; done; randtext 3 > logs/old.log; gzip logs/old.log; }
