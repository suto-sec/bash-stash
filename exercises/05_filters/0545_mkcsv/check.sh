# checker spec for 0545 (see lib/engine.sh)
SCRIPT_NAME=mkcsv.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
ARGS=('out.csv cols/*' 'out.csv "cols/day 1.txt" cols/day2.txt' '"my table.csv" cols/temps "cols/day 1.txt" cols/day2.txt' 'out.csv' '' 'out.csv cols/day2.txt' 'out.csv cols/day2.txt missing.txt' 'out.csv cols cols/day2.txt' 'existing.csv cols/day2.txt cols/temps')
setup() {
  local f i n
  mkdir cols
  for f in "cols/day 1.txt" cols/day2.txt cols/temps cols/notes.md; do
    n=$(randr 1 7)
    for ((i = 0; i < n; i++)); do pick "$(randr 1 40)" "$(randr 1 9).$(rand 10)" "$(word)" ""; done > "$f"
  done
  echo "a,b" > existing.csv
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *mkcsv.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) [[ $CASE == *missing.txt* ]] && mentions missing.txt
       [[ $CASE == *" cols "* ]] && mentions cols ;;
    3) mentions existing.csv ;;
  esac
  must_use paste
}
