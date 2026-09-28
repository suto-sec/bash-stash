# checker spec for 0802 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { touch a b c e; mkdir d; chmod "$(pick 777 000 111)" a b c e; }
extra_check() { must_use chmod; }
