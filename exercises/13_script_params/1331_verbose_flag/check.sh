# checker spec for 1331 (see lib/engine.sh)
SEEDS=1
ARGS=('' '-v' 'a.txt' '-v a.txt' 'a.txt -v b.txt' '-v -v -v' '"a b.txt" -v -v "c.txt"' 'x -v y -v -v z')
extra_check() { must_use case; }
