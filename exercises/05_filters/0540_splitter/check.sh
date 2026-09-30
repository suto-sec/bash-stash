# checker spec for 0540 (see lib/engine.sh)
SCRIPT_NAME=splitter.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
ARGS=('lines.txt 10' '"data/app log.txt" 7' 'lines.txt 100 chunk-' 'notes 4' 'empty.txt 5' 'lines.txt 1 L' 'lines.txt' '' 'lines.txt 5 p q' 'nofile 5' 'data 5' 'lines.txt 0' 'lines.txt abc' 'lines.txt -3' 'lines.txt 5 old_')
setup() {
  local i n
  mkdir data
  n=$(randr 15 45); for ((i = 1; i <= n; i++)); do echo "$i $(words 2)"; done > lines.txt
  n=$(randr 3 30);  for ((i = 1; i <= n; i++)); do echo "$(word) $i"; done > "data/app log.txt"
  n=$(randr 4 12);  for ((i = 1; i <= n; i++)); do words "$(randr 1 5)"; done > notes
  : > empty.txt
  echo old > old_00$(rand 3)
  echo keep > lines_x
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *splitter.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
  must_use split
}
