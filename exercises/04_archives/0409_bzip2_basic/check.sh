# checker spec for 0409 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p datos/normal
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do randtext 3 > "datos/normal/$(word)$i.dat"; done
  randtext 4 > datos/plantilla.dat
  randtext 2 > datos/notas.dat
  bzip2 datos/notas.dat
  randtext 2 > datos/leeme.txt
}
