# checker spec for 1409 (see lib/engine.sh)
SEEDS=6
COMPARE="stdout exit"
input() { pick s S si Si SÍ sí y YES yes n N no NO No quizas '' 'si no' maybe; }
extra_check() { must_use case read; }
