# checker spec for 0917 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir datos
  local i
  for i in $(seq "$(randr 1 6)"); do touch "datos/$(word)$i"; done
  pick "$(word)" "Ana Maria" "$(word) $(word)" > nombre.txt
}
extra_check() { ans_code | grep -q '<<' || fail "use a here document (<<)"; }
