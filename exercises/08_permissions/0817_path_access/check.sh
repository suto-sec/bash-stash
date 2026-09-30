# checker spec for 0817 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p privado/compartir "privado/$(word)" privado/compartir/sub
  local i
  for i in $(seq "$(randr 2 4)"); do touch "privado/compartir/$(pick "$(word)$i.txt" "$(word) $i.txt")"; done
  touch "privado/compartir/$(word).md" "privado/$(word).txt" "privado/compartir/sub/$(word).txt"
  chmod -R "$(pick go+r go+rw a+rwX)" privado 2>/dev/null
  chmod 755 privado privado/compartir
}
