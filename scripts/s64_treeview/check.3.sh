# checker spec for s64 step 3 (see lib/engine.sh)
SCRIPT_NAME=treeview.sh
setup() {
  mkdir -p proj/src/deep proj/docs empty; echo a > proj/readme.txt; echo b > proj/src/main.c; echo c > proj/src/deep/util.c; echo d > proj/docs/guide.md
  echo e > proj/zeta.txt; mkdir proj/assets; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *treeview.sh* ]]; }
ARGS=('proj' 'empty' '' 'proj empty' 'nothing' 'notadir.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
