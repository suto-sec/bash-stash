# checker spec for 0910 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i; for i in 1 2 3; do words 2; done > entrada.txt; }
extra_check() { ans_code | grep -q 'exec' || fail "use exec to open the file descriptors"; }
