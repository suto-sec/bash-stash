# checker spec for 1025 (see lib/engine.sh)
setup() {
  local i
  echo "product,region,units" > ventas.csv
  for i in $(seq "$(randr 8 16)"); do
    echo "$(pick apple banana cherry grape lemon mango),$(pick north south east west),$(randr 1 40)"
  done >> ventas.csv
}
