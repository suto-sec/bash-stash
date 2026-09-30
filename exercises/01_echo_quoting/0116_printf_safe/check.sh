# checker spec for 0116 (see lib/engine.sh)
SEEDS=6
setup() {
  local t=('-n' '-e' '-E -n' '100% of' 'tab\there' '-e back\\slash\c' 'say %s and %d\n' '-n\t-e')
  local s=${t[$(rand ${#t[@]})]}
  printf '%s %s\n' "$s" "$(pick "$(word)" "$(word)\\n$(word)" "50%" "\\\\$(word)")" > raw.txt
}
