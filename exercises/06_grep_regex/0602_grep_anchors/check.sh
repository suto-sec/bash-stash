# checker spec for 0602 (see lib/engine.sh)
setup() { local i; for i in $(seq 14); do [[ $(rand 5) == 0 ]] && { echo; continue; }; echo "$(pick sys sysadm $(word) mysys)$i:x:$i:$i:sys:/home/$(word):$(pick /bin/bash /bin/sh /usr/bin/bashx /bin/rbash)"; done > passwd; }
