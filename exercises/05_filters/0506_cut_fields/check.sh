# checker spec for 0506 (see lib/engine.sh)
setup() { local i; for i in $(seq "$(randr 8 15)"); do echo "$(word)$i:x:$((999+i)):$((999+i)):$(word):/home/$(word)$i:$(pick /bin/bash /bin/sh /usr/sbin/nologin)"; done > passwd; }
extra_check() { must_use cut; }
