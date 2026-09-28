# checker spec for 0906 (see lib/engine.sh)
COMPARE="stdout exit files"
extra_check() { ans_code | grep -q '<<' || fail "use here documents (<<)"; }
