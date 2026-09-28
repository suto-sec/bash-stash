# checker spec for 0207 (see lib/engine.sh)
SEEDS=1
setup() { mkdir -p Datos/Stocks Textos/Cartas/Avisos; }
extra_check() { must_use '\.\./\.\./Textos'; }
