# checker spec for 0608 (see lib/engine.sh)
setup() { local i; for i in $(seq 15); do echo "$(word) from $(ip_rand) port $(randr 1000 65000) $(words 2) $( [[ $(rand 3) == 0 ]] && ip_rand )"; done > acceso.log; }
