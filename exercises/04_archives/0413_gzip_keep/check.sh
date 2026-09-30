# checker spec for 0413 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir entradas
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do randtext "$(randr 2 20)" > "entradas/$(word)$i.csv"; done
  randtext 2 > entradas/notas.tmp
}
