# checker spec for 0549 (see lib/engine.sh)
SCRIPT_NAME=sanitize.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
ARGS=('win.txt tabs.txt clean.txt "mixed file.txt"' '*' 'clean.txt' '' 'missing.txt win.txt' 'dir')
setup() {
  local i n
  n=$(randr 2 6); for ((i = 0; i < n; i++)); do printf '%s%s\r\n' "$(words 3)" "$(pick '' ' ' '  ')"; done > win.txt
  n=$(randr 2 6); for ((i = 0; i < n; i++)); do printf '%s%s%s%s\n' "$(pick '' $'\t')" "$(word)" "$(pick ' ' $'\t')" "$(pick "$(word)" '' "$(word)  ")"; done > tabs.txt
  n=$(randr 2 6); for ((i = 0; i < n; i++)); do words 4; done > clean.txt
  n=$(randr 3 8)
  for ((i = 0; i < n; i++)); do printf '%s%s%s\n' "$(pick "$(word)" "  $(word)")" "$(pick '' $'\t' ' ' $' \t ')" "$(pick "$(word)" '' $'\r' "$(word)"$'\r')"; done > "mixed file.txt"
  chmod 600 "mixed file.txt"
  mkdir dir
  words 2 > ro.txt; chmod 444 ro.txt
}
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *sanitize.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) [[ $CASE == *missing.txt* ]] && mentions missing.txt
       [[ $CASE == dir ]] && mentions dir ;;
  esac
}
