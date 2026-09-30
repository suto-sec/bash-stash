# checker spec for 0813 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir orig dest
  local i n w
  n=$(randr 4 7)
  for ((i = 1; i <= n; i++)); do
    w="$(word)$i"; (( i == 2 )) && w="$(word) $w"
    touch "orig/$w" "dest/$w"
    chmod "$(pick 644 600 755 640 700 750 664)" "orig/$w"
    chmod "$(pick 644 600 755 666 777)" "dest/$w"
  done
  touch "dest/$(word)_extra" "dest/$(word) extra2"; chmod "$(pick 600 644)" dest/*extra*
  mkdir "dest/$(word)_dir"
}
