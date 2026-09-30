# checker spec for 1328 (see lib/engine.sh)
SCRIPT_NAME=samelines.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local pool=() i
  for ((i = 0; i < 8; i++)); do pool+=("$(word)" "$(word) $(word)"); done
  for ((i = 0; i < $(randr 4 9); i++)); do pick "${pool[@]}"; done > "list one.txt"
  for ((i = 0; i < $(randr 4 9); i++)); do pick "${pool[@]}"; done > "list two.txt"
  echo "${pool[0]}" >> "list one.txt"; echo "${pool[0]} pie" >> "list two.txt"
  { tac "list one.txt"; head -n 2 "list one.txt"; } > same.txt
  : > empty.txt
  echo x > locked.txt; chmod 000 locked.txt
}
ARGS=('"list one.txt" "list two.txt"' '-q "list one.txt" "list two.txt"' '"list one.txt" same.txt' '-q same.txt "list one.txt"' '"list two.txt" empty.txt' 'empty.txt empty.txt' '' 'a' '-q a' 'a b c' '"list one.txt" nofile' 'locked.txt same.txt' '-x same.txt empty.txt' '"$W/same.txt" "list one.txt"')
extra_check() {
  local tok
  if [[ $REF_CODE == 3 ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
