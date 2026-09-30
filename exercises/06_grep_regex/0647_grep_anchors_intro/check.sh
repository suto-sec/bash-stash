# checker spec for 0647 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 5 8)"); do echo "$(pick b c d e i o)$(word)"; done > nombres.txt; echo ana >> nombres.txt; echo luz >> nombres.txt; }
