# checker spec for 1303 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=mitool.sh
ARGS=('' 'a' 'a b c')
COMPARE="stdout stderr exit"
extra_check() { ans_code | grep -q '\$0' || fail "use \$0 to get the script name"; }
