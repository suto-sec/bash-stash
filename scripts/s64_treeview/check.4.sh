# checker spec for s64 step 4 (see lib/engine.sh)
SCRIPT_NAME=treeview.sh
setup() {
  mkdir -p proj/src/deep proj/docs empty; echo a > proj/readme.txt; echo b > proj/src/main.c; echo c > proj/src/deep/util.c; echo d > proj/docs/guide.md
  echo e > proj/zeta.txt; mkdir proj/assets; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *treeview.sh* ]]; }
ARGS=('proj' '-d 1 proj' '-d 2 proj' '-d 9 proj' '-d 1 empty' '-d 0 proj' '-d x proj' '-d' '-d 2' '' 'nothing' '-d 2 nothing' '-d x nothing')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "${@: -1}")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
