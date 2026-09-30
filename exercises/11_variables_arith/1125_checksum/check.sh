# checker spec for 1125 (see lib/engine.sh)
SCRIPT_NAME=checksum.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n=$(randr 6 10)
  : > bytes.txt
  for i in $(seq "$n"); do
    case $(rand 5) in
      0) echo "" >> bytes.txt ;;
      1) echo "$(pick abc -3 '' 3.5)" >> bytes.txt ;;
      2) echo "$(randr 256 999)" >> bytes.txt ;;
      *) echo "$(randr 0 255)" >> bytes.txt ;;
    esac
  done
  echo "$(randr 0 255)" >> bytes.txt
  echo "$(randr 0 255)" >> bytes.txt
  echo "no numbers here" > malo.txt
}
ARGS=('bytes.txt' '' 'bytes.txt extra' 'noexiste.txt' 'malo.txt')
extra_check() {
  must_not_use bc
  [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sage* || $ERR == *checksum* ]] || fail "the usage message should show how to call the script"; }
  true
}
