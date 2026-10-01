# checker spec for s02 step 3 (see lib/engine.sh)
SCRIPT_NAME=kind.sh
setup() {
  echo hi > notes.txt; echo hello > "my notes.txt"; mkdir docs; mkfifo pipe1
}
ARGS=('notes.txt' 'docs' 'nothing' '' 'notes.txt docs' '"my notes.txt"')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *kind.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the message should show the correct usage"; }
}
