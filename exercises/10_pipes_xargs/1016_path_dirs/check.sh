# checker spec for 1016 (see lib/engine.sh)
ARGS=('ls' 'python3' 'cat' 'mytool')
SEEDS=1
ENV=(PATH="$SB/home/bin:/usr/local/bin:/usr/bin:/bin:/nonexistent:$SB/home/tools")
setup() { mkdir -p "$H/bin" "$H/tools"; printf '#!/bin/sh\n' > "$H/bin/mytool"; printf '#!/bin/sh\n' > "$H/tools/mytool"; printf '#!/bin/sh\n' > "$H/tools/cat"; chmod +x "$H"/bin/* "$H"/tools/*; }
