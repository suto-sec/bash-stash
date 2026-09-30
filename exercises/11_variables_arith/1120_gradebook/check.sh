# checker spec for 1120 (see lib/engine.sh)
SCRIPT_NAME=gradebook.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n=$(randr 4 6)
  : > notas.txt
  for i in $(seq "$n"); do
    case $(rand 6) in
      0) echo "" >> notas.txt ;;
      1) echo "$(word) $(word);$(randr 1 10);$(randr 1 10)" >> notas.txt ;;
      2) echo "$(word) $(word);$(randr 1 10);abc;$(randr 1 10)" >> notas.txt ;;
      3) echo "$(word) $(word);0;$(randr 1 10);$(randr 1 10)" >> notas.txt ;;
      4) echo "$(word) $(word);11;$(randr 1 10);$(randr 1 10)" >> notas.txt ;;
      *) echo "$(word) $(word);$(randr 1 10);$(randr 1 10);$(randr 1 10)" >> notas.txt ;;
    esac
  done
  echo "$(word) $(word);$(randr 1 10);$(randr 1 10);$(randr 1 10)" >> notas.txt
  echo "$(word) $(word);$(randr 1 10);$(randr 1 10);$(randr 1 10)" >> notas.txt
}
ARGS=('notas.txt' 'notas.txt 6' 'notas.txt 0' 'notas.txt 11' 'notas.txt abc' '' 'notas.txt 3 4' 'noexiste.txt' 'noexiste.txt 5')
extra_check() {
  [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sage* || $ERR == *gradebook* ]] || fail "the usage message should show how to call the script"; }
  true
}
