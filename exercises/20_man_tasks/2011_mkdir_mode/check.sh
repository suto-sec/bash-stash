# checker spec for 2011 (see lib/engine.sh)
SEEDS=1
COMPARE="files exit"
extra_check() { must_use mkdir; must_not_use chmod; }
