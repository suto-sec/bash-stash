# checker spec for 0514 (see lib/engine.sh)
setup() { local i; for i in $(seq 8); do echo "$(pick sys sysadm $(word))$i:x:$((i+100)):100:$(word) sys:/home/$(word):$(pick /bin/bash /bin/sh)"; done > passwd; }
extra_check() { must_use sed; }
