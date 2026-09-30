# checker spec for 1121 (see lib/engine.sh)
SCRIPT_NAME=sumbases.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n=$(randr 5 8) c
  : > vals.txt
  for i in $(seq "$n"); do
    case $(rand 8) in
      0) echo "" >> vals.txt ;;
      1) echo "hexa $(randr 1 99)" >> vals.txt ;;
      2) echo "bin 1$(randr 2 9)0" >> vals.txt ;;
      3) echo "oct 8$(randr 0 9)" >> vals.txt ;;
      4) echo "hex 1G$(word)" >> vals.txt ;;
      5) echo "dec 12a" >> vals.txt ;;
      6) echo "bin" >> vals.txt ;;
      *)
        c=$(rand 4)
        if [ "$c" = 0 ]; then printf 'dec %d\n' "$(randr 0 999)" >> vals.txt
        elif [ "$c" = 1 ]; then
          if [ "$(rand 2)" = 1 ]; then printf 'hex %x\n' "$(randr 0 4095)" >> vals.txt
          else printf 'hex %X\n' "$(randr 0 4095)" >> vals.txt
          fi
        elif [ "$c" = 2 ]; then printf 'oct %o\n' "$(randr 0 511)" >> vals.txt
        else printf 'bin %d%d%d%d%d%d\n' "$(rand 2)" "$(rand 2)" "$(rand 2)" "$(rand 2)" "$(rand 2)" "$(rand 2)" >> vals.txt
        fi
        ;;
    esac
  done
  printf 'dec %d\n' "$(randr 1 999)" >> vals.txt
  printf 'hex %X\n' "$(randr 1 4095)" >> vals.txt
  echo "hexa 1" > allbad.txt
  echo "bin 29" >> allbad.txt
}
ARGS=('vals.txt' '' 'vals.txt extra' 'noexiste.txt' 'allbad.txt')
extra_check() {
  [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sage* || $ERR == *sumbases* ]] || fail "the usage message should show how to call the script"; }
  true
}
