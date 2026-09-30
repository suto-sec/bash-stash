# checker spec for 0548 (see lib/engine.sh)
SCRIPT_NAME=dedupe.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
ARGS=('list.txt' '"my words.txt"' 'unique.txt' 'readonly.txt' 'sub' 'missing.txt' '' 'list.txt unique.txt')
setup() {
  local i n pool=()
  for ((i = 0; i < 7; i++)); do pool+=("$(pick "$(word)" "$(word) $(word)" "$(word)")"); done
  n=$(randr 6 16); for ((i = 0; i < n; i++)); do echo "${pool[$(rand 7)]}"; done > list.txt
  n=$(randr 4 10); for ((i = 0; i < n; i++)); do echo "${pool[$(rand 4)]}"; done > "my words.txt"
  printf '%s\n' "${pool[@]}" | sort -u > unique.txt
  [[ $(rand 2) == 0 ]] && echo "old backup" > list.txt.bak
  chmod 640 "my words.txt"
  printf 'a\nb\na\n' > readonly.txt; chmod 444 readonly.txt
  mkdir sub
}
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *dedupe.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
