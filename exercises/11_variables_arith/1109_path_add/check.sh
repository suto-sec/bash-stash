# checker spec for 1109 (see lib/engine.sh)
setup() { mkdir -p "$H/bin"; printf '#!/bin/bash\necho "Hola desde saluda %s"\n' "$(word)" > "$H/bin/saluda"; chmod +x "$H/bin/saluda"; }
