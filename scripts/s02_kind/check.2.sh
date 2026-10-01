# checker spec for s02 step 2 (see lib/engine.sh)
SCRIPT_NAME=kind.sh
setup() {
  echo hi > notes.txt; echo hello > "my notes.txt"; mkdir docs; mkfifo pipe1
}
ARGS=('notes.txt' 'docs' 'nothing' '"my notes.txt"' '"no such file"')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"; }
