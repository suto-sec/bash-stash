# checker spec for 0321 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir caos
  local i j d n
  n=$(randr 2 4)
  for ((i = 1; i <= n; i++)); do
    d="caos/$(word)$i"; (( i == 2 )) && d="caos/$(word) $i"
    mkdir "$d"
    for ((j = 1; j <= $(randr 1 3); j++)); do randtext 1 > "$d/$(pick "$(word)$j.txt" "$(word) $j.log")"; done
  done
  mkdir "caos/$(word)_empty"
  randtext 1 > "caos/$(word).md"
}
extra_check() { must_use rmdir; must_not_use 'rm -r'; }
