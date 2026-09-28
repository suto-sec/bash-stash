# checker spec for 1402 (see lib/engine.sh)
setup() { touch vacio; randtext "$(randr 1 9)" > lleno; printf 'sin salto' > raro; }
ARGS=('vacio' 'lleno' 'nada' 'vacio lleno nada raro')
