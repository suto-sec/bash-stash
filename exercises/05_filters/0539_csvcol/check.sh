# checker spec for 0539 (see lib/engine.sh)
SCRIPT_NAME=csvcol.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('data.csv city' 'data.csv name' '"sales 2026.csv" "unit price"' '"sales 2026.csv" product' 'data.csv age' 'data.csv' '' 'data.csv city extra' 'nofile.csv city' 'somedir city' 'data.csv nam' '"sales 2026.csv" price')
setup() {
  local hdr i n f row v
  hdr=$(pick "id,name,name2,city,age" "city,id,age,name,name2" "name2,age,city,name,id")
  n=$(randr 5 11)
  { echo "$hdr"
    for ((i = 1; i <= n; i++)); do
      row=
      for f in ${hdr//,/ }; do
        case $f in
          id) v=$i ;;
          name) v=$(pick "$(word)" "$(word)" "") ;;
          name2) v=$(word) ;;
          city) v=$(pick Madrid Bilbao "San Sebastian" Madrid "") ;;
          age) v=$(randr 18 25) ;;
        esac
        row="$row,$v"
      done
      echo "${row#,}"
    done
  } > data.csv
  n=$(randr 3 8)
  { echo "product,unit price,units,product code"
    for ((i = 1; i <= n; i++)); do echo "$(pick "$(word)" "$(word) $(word)"),$(pick "" "$(randr 1 3).99" 2.50),$(randr 1 20),P$(randr 100 999)"; done
  } > "sales 2026.csv"
  mkdir somedir
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *csvcol.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
