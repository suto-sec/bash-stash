# checker spec for 0304 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p Datos/Stocks Datos/Inversiones; randtext 4 > Datos/Stocks/borrador.txt; touch "Datos/Inversiones/$(word)"; }
extra_check() { must_use mv; must_not_use cp; }
