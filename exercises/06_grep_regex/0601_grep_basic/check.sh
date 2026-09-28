# checker spec for 0601 (see lib/engine.sh)
setup() { local i; for i in $(seq 12); do echo "$(pick root $(word) $(word) chroot)$i:x:$i:$i:$(pick Root root $(word)):/$(pick root home)/$(word):/bin/bash"; done > passwd; }
