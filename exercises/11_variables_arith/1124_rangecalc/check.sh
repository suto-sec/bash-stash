# checker spec for 1124 (see lib/engine.sh)
SCRIPT_NAME=rangecalc.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n=$(randr 6 10)
  : > lecturas.txt
  for i in $(seq "$n"); do
    case $(rand 5) in
      0) echo "" >> lecturas.txt ;;
      1) echo "$(pick abc x12 'n/a')" >> lecturas.txt ;;
      2) echo "$(randr 0 40).5" >> lecturas.txt ;;
      *) echo "$(( $(randr 0 80) - 30 ))" >> lecturas.txt ;;
    esac
  done
  echo "$(( $(randr 0 80) - 30 ))" >> lecturas.txt
  echo "$(( $(randr 0 80) - 30 ))" >> lecturas.txt
  echo "solo texto" > malo.txt
}
ARGS=('lecturas.txt' 'lecturas.txt 5' 'lecturas.txt -10' 'lecturas.txt abc' '' 'lecturas.txt 1 2' 'noexiste.txt' 'malo.txt')
extra_check() {
  must_use expr
  [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sage* || $ERR == *rangecalc* ]] || fail "the usage message should show how to call the script"; }
  true
}
