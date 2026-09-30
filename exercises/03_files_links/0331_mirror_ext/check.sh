# checker spec for 0331 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p "origen/a/b" "origen/c" destino
  local i f
  for i in $(seq 10); do
    f="origen/$(pick . a "a/b" c)/$(pick "$(word)$i.log" "$(word) $i.log" "$(word)$i.txt" "$(word)$i.dat")"
    randtext "$(randr 1 3)" > "$f"
  done
  randtext 1 > destino/ya_estaba.txt
}
