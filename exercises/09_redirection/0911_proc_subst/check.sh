# checker spec for 0911 (see lib/engine.sh)
setup() { local i; for i in $(seq 8); do word; done | sort -u > lista1.txt; for i in $(seq 8); do word; done | sort -u > lista2.txt; shuf --random-source=<(yes) lista1.txt -o lista1.txt 2>/dev/null; tac lista2.txt > l2 && mv l2 lista2.txt; }
extra_check() { ans_code | grep -q '<(' || fail "use process substitution <(...)"; }
