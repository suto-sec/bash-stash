# checker spec for 2016 (see lib/engine.sh)
SEEDS=4
setup() { mkf programa "x"; chmod "$(pick 755 640 600 711 664 700 750)" programa; }
extra_check() { must_use stat; }
