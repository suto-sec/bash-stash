# checker spec for 0414 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p datos/a "datos/b/c 1" datos/vacio
  local i n; n=$(randr 3 6)
  for i in $(seq "$n"); do randtext 2 > "datos/$(pick a "b/c 1" .)/$(word)$i.txt"; done
  randtext 2 > afuera.txt
}
