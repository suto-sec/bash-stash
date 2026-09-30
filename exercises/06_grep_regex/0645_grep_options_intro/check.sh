# checker spec for 0645 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 8 14)"); do echo "$(pick INFO warn error ERROR Error debug) $(word)"; done > log.txt; }
