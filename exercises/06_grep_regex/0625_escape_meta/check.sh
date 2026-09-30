# checker spec for 0625 (see lib/engine.sh)
setup() {
  local i
  for i in $(seq 20); do
    echo "$(word) $(pick 'total $12.50 today' '$7.05' 'cost $1.5 only' 'now $12,50' 'was 12.50$' 'x $3.999 y' 'pay $100.00.' 'f(x) = 2' 'fx here' 'g f(y)' 'call f(x)!' '[ok] done' 'ok] x' '(ok)' '[ok' 'status [OK]' 'a*b' '$99.99')"
  done > precios.txt
}
