# checker spec for 0219 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
extra_check() { must_use mkdir; must_not_use chmod; }
