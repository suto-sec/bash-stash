# checker spec for the practice exam medium-01 (see lib/engine.sh; graded by objectives with bin/sgrade)
SCRIPT_NAME=lowstock.sh
OBJECTIVES=(
  "args|Argument checking and error messages|3"
  "core|Selecting, sorting and printing the items|4"
  "edge|Special cases (no low items, blank lines, spaces)|3"
)
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i
  echo "item,qty,price" > inv.csv
  for ((i = 1; i <= 12; i++)); do echo "$(word)$i,$(randr 0 12),$(randr 1 90)" >> inv.csv; done
  mkfl many.csv "item,qty,price" "delta,2,10" "alpha,2,5" "charlie,1,100" "bravo,2,1" "echo,7,9" "foxtrot,3,4" "golf,3,6" "hotel,0,50"
  echo "item,qty,price" > none.csv
  for ((i = 1; i <= 6; i++)); do echo "$(word)$i,$(randr 5 20),$(randr 1 90)" >> none.csv; done
  mkfl blanks.csv "item,qty,price" "" "green apple,4,10" "" "red pear,2,7" "kiwi,9,3" "" "big melon,0,25" "plum,4,12" ""
  mkfl locked.csv "item,qty,price" "alpha,1,1"; chmod 000 locked.csv
  mkdir -p adir
}
ARGS=('' 'inv.csv 3 extra' 'nofile.csv' 'adir' 'inv.csv abc' 'inv.csv 0' 'inv.csv -2' 'locked.csv' 'nofile.csv abc'
      'inv.csv' 'inv.csv 10' 'many.csv' 'many.csv 3'
      'none.csv' 'blanks.csv 20' 'inv.csv 1' 'blanks.csv')
CASE_OBJ=(args args args args args args args args args  core core core core  edge edge edge edge)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *lowstock.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|4) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
