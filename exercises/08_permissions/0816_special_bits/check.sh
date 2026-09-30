# checker spec for 0816 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir tmpcomun compartido otros; touch herramienta raro
  chmod "$(pick 755 700 775)" tmpcomun compartido; chmod "$(pick 755 700 644)" herramienta; chmod "$(pick 600 644 664)" raro
  local i f
  for i in 1 2 3 4 5; do
    f="$(pick . otros)/$(word)$i"; touch "$f"; chmod "$(pick 755 4755 2755 1755 644 2711 6750)" "$f"
  done
}
