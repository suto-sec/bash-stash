# checker spec for 0611 (see lib/engine.sh)
setup() { local i; for i in $(seq 30); do [[ $(rand 9) == 0 ]] && echo "$i PANIC $(words 2)" || echo "$i $(pick INFO DEBUG WARN) $(words 2)"; done > server.log; echo "31 PANIC final" >> server.log; }
