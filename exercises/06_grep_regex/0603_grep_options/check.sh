# checker spec for 0603 (see lib/engine.sh)
setup() { local i; for i in $(seq 20); do echo "$(pick INFO warn Warn error ERROR Error debug) $(pick disk net cpu) $(words 3)"; done > log.txt; }
