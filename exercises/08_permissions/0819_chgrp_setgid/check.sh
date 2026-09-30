# checker spec for 0819 (see lib/engine.sh)
COMPARE="stdout exit files owner"
setup() {
  mkdir -p logs "equipo/sub/deep" "equipo/$(word) dir"
  local i
  for i in $(seq "$(randr 2 4)"); do touch "logs/$(pick "$(word)$i.log" "$(word) $i.log")" "logs/$(word)$i.txt"; done
  for i in 1 2 3; do touch "equipo/$(pick . sub sub/deep)/$(word)$i"; done
}
