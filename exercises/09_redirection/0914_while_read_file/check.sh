# checker spec for 0914 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  local i
  for i in $(seq "$(randr 4 8)"); do
    pick "  indented $(word)" "back\\slash $(word)" "" $'\ttab '"$(word)" "-n" "*" "$(word)   " "a  b   $(word)" "\\n$(word)" "-e x"
  done > entrada.txt
  printf '%s' "last $(word) *" >> entrada.txt
}
