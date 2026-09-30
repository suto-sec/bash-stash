# checker spec for 0815 (see lib/engine.sh)
COMPARE="stdout exit files"
extra_check() { must_use umask; must_not_use chmod; }
