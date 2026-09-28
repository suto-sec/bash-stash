# checker spec for 1511 (see lib/engine.sh)
SEEDS=4
setup() { local i; for i in $(seq "$(randr 1 4)"); do touch "$(word)$i"; done; }
input() { local i; for i in $(seq "$(randr 1 4)"); do pick 1 2 7 2; done; [[ $(rand 3) != 0 ]] && echo 3; echo 1; }
extra_check() { must_use select; }
