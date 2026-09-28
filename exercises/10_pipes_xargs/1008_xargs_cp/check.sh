# checker spec for 1008 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p "$H/bin" "$H/a/b"; local i; for i in $(seq 6); do printf '#!/bin/bash\necho %s\n' "$(word)" > "$H/$(pick bin a a/b .)/$(word)$i$(pick .sh .sh .txt)"; done; }
