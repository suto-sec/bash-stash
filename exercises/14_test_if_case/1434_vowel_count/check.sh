# checker spec for 1434 (see lib/engine.sh)
SEEDS=1
ARGS=('' 'hola' 'xyz' 'AEIOU' 'Programacion' 'brrr' 'hola mundo bash')
extra_check() { must_use case; }
