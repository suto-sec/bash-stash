# checker spec for 1325 (see lib/engine.sh)
SCRIPT_NAME=notes.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i
  case $(rand 3) in
    0) ;;
    1) : > "$H/notes.txt" ;;
    *) for ((i = 0; i < $(randr 2 5); i++)); do words "$(randr 1 4)"; done > "$H/notes.txt" ;;
  esac
}
ARGS=('' 'list' 'count' 'add buy milk' 'add "x  y" z' 'del 2' 'del 1' 'del 99' 'del x' 'del 0' 'del' 'list extra' 'count 1' 'add' 'foo' 'del 1 2' 'LIST')
extra_check() {
  local tok
  if [[ $REF_CODE == [24] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
