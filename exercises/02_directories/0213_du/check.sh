# checker spec for 0213 (see lib/engine.sh)
setup() { mkdir -p Datos/{a,b/c,d}; local f; for f in Datos/a/x Datos/b/y Datos/b/c/z Datos/d/w Datos/top; do bigfile "$f" $(( $(randr 1 40) * 1024 )); done; }
SORT_OUTPUT=1
extra_check() { must_use du; }
