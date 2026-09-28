# checker spec for 0518 (see lib/engine.sh)
setup() { local i; for i in $(seq 7); do [[ $(rand 4) == 0 ]] && echo || words 4; done > poema.txt; }
