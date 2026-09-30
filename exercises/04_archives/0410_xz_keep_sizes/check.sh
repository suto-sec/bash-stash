# checker spec for 0410 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir reportes
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do randtext "$(randr 3 30)" > "reportes/$(word)$i.rpt"; done
  randtext 2 > reportes/aviso.log
}
