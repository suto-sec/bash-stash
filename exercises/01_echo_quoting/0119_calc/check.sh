# checker spec for 0119 (see lib/engine.sh)
SCRIPT_NAME=calc.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  echo "$(pick "" "" -)$(randr 1 999)" > a.txt
  echo "$(pick "" -)$(randr 1 99)" > b.txt
  touch "$(word).txt" "$(word) $(word)" 42 x
}
ARGS=('"$(cat a.txt)" + "$(cat b.txt)"' '"$(cat a.txt)" "*" "$(cat b.txt)"' '"$(cat a.txt)" x "$(cat b.txt)"' '"$(cat a.txt)" - "$(cat b.txt)"' '"$(cat a.txt)" / "$(cat b.txt)"' '"$(cat a.txt)" % "$(cat b.txt)"' '0 "*" "$(cat b.txt)"' '"$(cat a.txt)" / 0' '"$(cat a.txt)" % 0' '"$(cat a.txt)" "^" 2' '3.5 + 1' '"$(cat a.txt)" + abc' '"" + 1' '"$(cat a.txt)" +' '' '1 + 2 3')
extra_check() {
  local a=(); mapfile -t a < <(cd "$W" && eval "set -- $CASE" && printf '%s\n' "$@")
  if [[ $REF_CODE == 2 ]]; then
    if [[ ${a[0]} =~ ^-?[0-9]+$ ]]; then mentions "${a[2]}"; else mentions "${a[0]}"; fi
  fi
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
