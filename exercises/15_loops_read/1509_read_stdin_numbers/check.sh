# checker spec for 1509 (see lib/engine.sh)
SEEDS=5
input() { local i; for i in $(seq "$(randr 0 6)"); do randr 1 100; done; [[ $(rand 3) != 0 ]] && echo 0; randr 1 9; }
