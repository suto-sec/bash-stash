# checker spec for 1003 (see lib/engine.sh)
setup() { local i; for i in $(seq 10); do echo "$(word)$i:x:$((1000+i)):100:$(word):/home/$(word)$i:/bin/bash"; done > passwd; }
