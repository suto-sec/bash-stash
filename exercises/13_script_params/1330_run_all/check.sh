# checker spec for 1330 (see lib/engine.sh)
SCRIPT_NAME=runall.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i pool
  mkdir sub
  randtext 4 > data.txt
  pool=("true" "false" "test -d sub" "test -f nothere" "grep -q $(word) data.txt" "exit $(randr 3 9)"
        "ls \"no such file\"" "mkdir -p \"out/$(word)\"" "touch \"sub/f $(rand 9)\"" "# a comment" ""
        "cat data.txt" "[ \$(wc -l < data.txt) -gt 2 ]" "cp data.txt \"sub/copy $(rand 9)\"")
  for ((i = 0; i < $(randr 5 9); i++)); do pick "${pool[@]}"; done > "jobs list.txt"
  echo false >> "jobs list.txt"
  printf '%s\n' "# setup" "mkdir -p build" "" "test -d build" "echo done" > "all ok.txt"
  echo true > locked.txt; chmod 000 locked.txt
}
ARGS=('"jobs list.txt"' '-e "jobs list.txt"' '"all ok.txt"' '-e "all ok.txt"' '' '-e' 'a b' '-e a b' 'nofile' 'locked.txt' 'sub' '-x "jobs list.txt"' '"$W/all ok.txt"')
extra_check() {
  local tok
  if [[ $REF_CODE == 3 ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
