# checker spec for 0206 (see lib/engine.sh)
setup() { mkdir -p Datos/{Inversiones,Nominas,Stocks} Textos/{Cartas,Informes}; local d; for d in Datos/* Textos/*; do touch "$d/$(word).txt" "$d/$(word).dat"; done; }
extra_check() { must_not_use cd; }
