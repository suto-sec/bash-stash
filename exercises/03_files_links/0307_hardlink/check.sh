# checker spec for 0307 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p Datos/Stocks; randtext 5 > Datos/borrador; }
extra_check() { must_use ln; must_not_use cp; }
