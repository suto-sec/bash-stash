# checker spec for 0823 (see lib/engine.sh)
SCRIPT_NAME=permsave.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "proj/src/mis cosas" proj/doc proj/.git
  local i f
  for i in $(seq 1 8); do
    f="proj/$(pick . src "src/mis cosas" doc .git)/$(pick "$(word)$i.c" "$(word) $i.md" ".$(word)$i")"
    touch "$f"; chmod "$(pick 644 600 755 640 700 664 444)" "$f"
  done
  chmod "$(pick 755 700 750)" proj/doc "proj/src/mis cosas"
  ln -s src proj/link
  (cd proj && find . -mindepth 1 \( -type f -o -type d \) | sed 's#^\./##' | sort |
     while IFS= read -r p; do echo "$(stat -c %a "$p") $p"; done) > "saved modes.txt"
  (cd proj && find . -mindepth 1 -type f) | while IFS= read -r p; do
    (( $(rand 3) == 0 )) && chmod "$(pick 777 600 666 640)" "proj/$p"
  done
  chmod "$(pick 777 711 755)" proj/src
  rm -f "$(find proj -type f | sort | head -n 1)"
  touch proj/src/nuevo.c fich
}
ARGS=('save proj modos.txt' 'save "$W/proj/src" "$W/src modes"' 'restore proj "saved modes.txt"' 'restore "$W/proj" "$W/saved modes.txt"' 'backup proj x' 'save fich x' 'restore proj noexiste' 'restore proj' '')
