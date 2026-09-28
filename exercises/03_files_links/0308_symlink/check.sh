# checker spec for 0308 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p Datos/Stocks; randtext 3 > Datos/borrador; }
