# checker spec for 1114 (see lib/engine.sh)
setup() {
  local i n=$(randr 3 6) c
  : > precios.txt
  for i in $(seq "$n"); do
    c=$(randr 2000 9999)
    printf '%d.%02d\n' "$((c / 100))" "$((c % 100))" >> precios.txt
  done
  randr 10 50 > descuento.txt
}
extra_check() { must_use bc; }
