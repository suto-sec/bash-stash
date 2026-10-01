# checker spec for s02 step 1 (see lib/engine.sh)
SCRIPT_NAME=kind.sh
setup() {
  echo hi > notes.txt; echo hello > "my notes.txt"; mkdir docs; mkfifo pipe1
}
ARGS=('notes.txt' 'docs' 'nothing' '"my notes.txt"')
COMPARE="stdout exit"
