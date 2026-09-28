# checker spec for 0907 (see lib/engine.sh)
setup() { words "$(randr 3 7)" > frase.txt; }
extra_check() { must_not_use '\|'; ans_code | grep -q '<<<' || fail "use here strings (<<<)"; }
