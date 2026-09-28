# checker spec for 1407 (see lib/engine.sh)
setup() { touch -d "2026-0$(randr 1 5)-10 10:00" a; touch -d "2026-0$(randr 1 5)-10 10:00" b; touch -d "2026-03-03 03:03" c d; }
ARGS=('a b' 'b a' 'c d')
