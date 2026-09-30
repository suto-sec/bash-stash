# checker spec for 1322 (see lib/engine.sh)
SCRIPT_NAME=calc.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i e
  for i in 1 2 3; do
    e=$(randr -9 60)
    for ((k = 0; k < $(randr 2 4); k++)); do e+=" $(pick + - x / %) $(pick "$(randr 1 30)" "-$(randr 1 9)")"; done
    echo "$e" > "e$i"
  done
  echo "$(randr 1 9) $(pick + x) $(pick abc 3.5 08 12a --1 '') $(pick / x) 2" > bad2
  echo "$(randr 1 9) + 4 $(pick '^' X '**' plus) $(randr 1 9)" > bad3
  echo "$(randr 10 99) - $(randr 1 9) $(pick / %) 0 + 1" > bad4
}
ARGS=('' '7' '$(cat e1)' '$(cat e2)' '$(cat e3)' '$(cat bad2)' '$(cat bad3)' '$(cat bad4)' '3 +' '1 + 2 x' '5 "*" 2' '4 x 08' '5 ^ abc' '0 - 3' '-7 / 2 % 3')
extra_check() {
  local tok
  if [[ $REF_CODE == [23] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  [[ $REF_CODE == 1 && $ERR != *calc.sh* && $ERR != *sage* ]] && fail "the usage message should show how to call the script"
  true
}
