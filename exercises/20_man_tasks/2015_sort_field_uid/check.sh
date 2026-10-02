# checker spec for 2015 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq "$(randr 5 9)"); do echo "$(word)$i:x:$(randr 100 3000):$(randr 100 3000):$(word):/home/x:/bin/bash"; done > cuentas.txt; }
extra_check() { must_use sort; }
