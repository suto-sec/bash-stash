# checker spec for 0552 (see lib/engine.sh)
setup() {
  local n i
  n=$(( 3 * $(randr 3 6) ))
  : > datos.txt
  for i in $(seq "$n"); do echo "$(word)$i"; done > datos.txt
}
