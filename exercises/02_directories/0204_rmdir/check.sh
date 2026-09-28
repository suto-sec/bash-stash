# checker spec for 0204 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { mkdir -p Datos/{Inversiones,Nominas,Stocks} Textos/Cartas/{Avisos,Circulares} Textos/Informes; }
extra_check() { must_use rmdir; must_not_use rm; }
