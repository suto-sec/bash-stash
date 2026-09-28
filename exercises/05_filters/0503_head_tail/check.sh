# checker spec for 0503 (see lib/engine.sh)
setup() { local i; for i in $(seq "$(randr 12 25)"); do echo "$(word)$i:x:$((999+i)):$((999+i)):$(word) $(word):/home/$(word)$i:$(pick /bin/bash /bin/sh /usr/sbin/nologin)"; done > passwd; }
