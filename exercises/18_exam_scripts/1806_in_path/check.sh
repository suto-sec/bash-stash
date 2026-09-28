# checker spec for 1806 (see lib/engine.sh)
SCRIPT_NAME=inpath.sh
SEEDS=1
COMPARE="stdout stderr exit"
ENV=(PATH="$SB/home/bin:/usr/local/bin:/usr/bin:/bin:/nonexistent:$SB/home/tools")
setup() { mkdir -p "$H/bin" "$H/tools"; printf '#!/bin/sh\n' | tee "$H/bin/mytool" "$H/tools/mytool" "$H/tools/cat" "$H/tools/notes" >/dev/null; chmod +x "$H/bin/mytool" "$H/tools/cat" "$H/tools/mytool"; }
ARGS=('ls' 'mytool' 'cat' 'notes' 'zzznothing' '' 'a b')
