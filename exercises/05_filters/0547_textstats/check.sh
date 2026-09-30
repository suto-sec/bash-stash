# checker spec for 0547 (see lib/engine.sh)
SCRIPT_NAME=textstats.sh
SEEDS=3
COMPARE="stdout exit errmsg"
ARGS=('*' '"notes 1.txt" a.txt' 'empty.txt' '' 'missing.txt a.txt' 'sub')
setup() {
  randtext "$(randr 2 9)" > a.txt
  randtext "$(randr 2 9)" > "notes 1.txt"
  randtext "$(randr 2 9)" > B.md
  randtext "$(randr 1 9)" > chapter2
  [[ $(rand 2) == 0 ]] && cp a.txt "copy of a.txt"
  sed 's/^/x /' B.md > "b 2.md"
  : > empty.txt
  mkdir sub
  words 3 > locked.txt; chmod 000 locked.txt
}
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *textstats.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) [[ $CASE == *missing.txt* ]] && mentions missing.txt
       [[ $CASE == '*' ]] && mentions locked.txt ;;
  esac
}
