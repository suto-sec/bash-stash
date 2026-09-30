# checker spec for 0118 (see lib/engine.sh)
SCRIPT_NAME=caja.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  printf '%s  %s %s\n' "$(word)" "$(word)" "$(word)" > t1.txt
  printf '%s * $HOME %s\n' "$(pick -n -e "$(word)")" "$(word)" > t2.txt
  echo "$(words 9) $(words 4)" > long.txt
  touch "$(word).txt" "$(word) $(word).sh" "a*b" 5
}
ARGS=('"$(cat t1.txt)"' '"$(cat t1.txt)" "*"' '"$(cat t2.txt)" "@"' '"$(cat t2.txt)" "*"' 'x =' '' '"$(cat t1.txt)" "**"' '"$(cat t1.txt)" ""' '""' '"$(cat long.txt)"' 'a b c')
extra_check() {
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *caja.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script"; }
  true
}
