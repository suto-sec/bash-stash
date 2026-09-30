# checker spec for 0814 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir equipo
  local i f
  for i in $(seq "$(randr 4 7)"); do
    f="equipo/$(pick "$(word)$i" "$(word) $i.txt")"
    if (( $(rand 4) == 0 )); then mkdir "$f"; chmod "$(pick 700 750 755 711)" "$f"
    else touch "$f"; chmod "$(pick 600 644 700 755 640 400 500 604 611)" "$f"; fi
  done
}
