# checker spec for 0115 (see lib/engine.sh)
SEEDS=4
setup() { local i o=(); for i in $(seq "$(randr 2 6)"); do o+=("$(word)$i" "$(randr 0 1000)"); done; echo "${o[*]}" > scores.txt; }
extra_check() { must_use printf; }
