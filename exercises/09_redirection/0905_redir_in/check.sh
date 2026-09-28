# checker spec for 0905 (see lib/engine.sh)
setup() { local i; for i in $(seq 6); do word; done > nombres.txt; randtext 3 > texto.txt; }
extra_check() { ans_code | grep -qE '(wc|sort|tr)[^<|]*(passwd|nombres|texto)' && fail "pass the files with < (not as arguments)"; }
