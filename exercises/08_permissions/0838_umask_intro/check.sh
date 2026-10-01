# checker spec for 0838 (see lib/engine.sh)
COMPARE="stdout exit files"
SEEDS=1
extra_check() { must_use umask touch; }
