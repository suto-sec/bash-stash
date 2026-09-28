# checker spec for 0715 (see lib/engine.sh)
setup() {
  mkdir -p "src/a/b" "src/c d"; local i f
  for i in $(seq 12); do f="src/$(pick . a a/b 'c d')/$(word)$i$(pick .sh .bin .shx .txt .sh.bak)"; touch "$f"; chmod "$(pick 755 644 700 604 601 610 744)" "$f"; done
  mkdir -p src/dir.sh; chmod 755 src/dir.sh
}
