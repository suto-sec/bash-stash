# checker spec for 2010 (see lib/engine.sh)
SEEDS=3
setup() { local i n=$(randr 5 9); for i in $(seq "$n"); do echo "$(word)$i:x:$(( 9 + (n - i) * (n - i) * 37 + $(rand 20) )):$(randr 100 3000):$(word):/home/x:/bin/bash"; done > cuentas.txt; }
extra_check() { must_use sort; }
