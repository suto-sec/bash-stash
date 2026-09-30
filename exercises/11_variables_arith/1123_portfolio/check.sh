# checker spec for 1123 (see lib/engine.sh)
SCRIPT_NAME=portfolio.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n=$(randr 6 9) syms=(AAA BBB CCC DDD EEE) c
  : > port.txt
  for i in $(seq "$n"); do
    case $(rand 6) in
      0) echo "" >> port.txt ;;
      1) echo "$(pick "${syms[@]}") $(randr 1 20)" >> port.txt ;;
      2) echo "lowsym $(randr 1 20) 12.00" >> port.txt ;;
      3) echo "$(pick "${syms[@]}") 0 12.00" >> port.txt ;;
      4) echo "$(pick "${syms[@]}") $(randr 1 20) 12" >> port.txt ;;
      *)
        c=$(randr 100 9999)
        printf '%s %d %d.%02d\n' "$(pick "${syms[@]}")" "$(randr 1 20)" "$((c / 100))" "$((c % 100))" >> port.txt
        ;;
    esac
  done
  c=$(randr 100 9999)
  printf 'AAA %d %d.%02d\n' "$(randr 1 20)" "$((c / 100))" "$((c % 100))" >> port.txt
  c=$(randr 100 9999)
  printf 'BBB %d %d.%02d\n' "$(randr 1 20)" "$((c / 100))" "$((c % 100))" >> port.txt
  : > empty.txt
}
ARGS=('port.txt' '' 'port.txt extra' 'noexiste.txt' 'empty.txt')
extra_check() {
  [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sage* || $ERR == *portfolio* ]] || fail "the usage message should show how to call the script"; }
  true
}
