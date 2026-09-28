# checker spec for 1504 (see lib/engine.sh)
setup() { local i; for i in $(seq 12); do echo "$(word)$i:x:$(pick 0 1 33 999 1000 1001 1500 65534):100:$(word) $(word):/home/$(word):$(pick /bin/bash /bin/sh /usr/sbin/nologin)"; done > passwd; }
extra_check() { must_use while read; }
