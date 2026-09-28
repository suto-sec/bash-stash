# checker spec for 0517 (see lib/engine.sh)
COMPARE="stdout exit files"
input() { randtext 4; }
extra_check() { must_use tee; }
