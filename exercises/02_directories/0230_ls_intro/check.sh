# checker spec for 0230 (see lib/engine.sh)
setup() { mkdir d; touch "d/$(word)" "d/.$(word)rc"; }
extra_check() { must_use ls; }
