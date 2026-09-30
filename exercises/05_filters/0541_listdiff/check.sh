# checker spec for 0541 (see lib/engine.sh)
SCRIPT_NAME=listdiff.sh
SEEDS=3
COMPARE="stdout exit errmsg"
ARGS=('old.txt new.txt' '"list v1.txt" "list v2.txt"' 'old.txt old_copy.txt' 'new.txt old.txt' 'old.txt' '' 'a b c' 'old.txt missing.txt' 'missing.txt new.txt' 'old.txt folder')
setup() {
  local pool=() i w n
  for ((i = 0; i < 14; i++)); do
    w=$(word)
    case $(rand 3) in 0) pool+=("${w^}") ;; 1) pool+=("$w $(word)") ;; *) pool+=("$w") ;; esac
  done
  n=$(randr 6 12)
  for ((i = 0; i < n; i++)); do echo "${pool[$(rand 9)]}"; [[ $(rand 5) == 0 ]] && echo; done > old.txt
  n=$(randr 6 12)
  for ((i = 0; i < n; i++)); do echo "${pool[$(randr 3 13)]}"; done > new.txt
  { tac old.txt; head -n 2 old.txt; echo; } > old_copy.txt
  n=$(randr 3 8)
  for ((i = 0; i < n; i++)); do echo "${pool[$(rand 14)]}"; done > "list v1.txt"
  for ((i = 0; i < n; i++)); do echo "${pool[$(rand 14)]}"; done > "list v2.txt"
  mkdir folder
}
extra_check() {
  case $REF_CODE in
    2) [[ $ERR == *listdiff.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    3) [[ $CASE == missing* ]] && mentions missing.txt
       [[ $CASE == *missing.txt ]] && mentions missing.txt
       [[ $CASE == *folder ]] && mentions folder ;;
  esac
}
