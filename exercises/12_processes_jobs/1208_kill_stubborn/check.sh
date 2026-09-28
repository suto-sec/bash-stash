# checker spec for 1208 (see lib/engine.sh)
SEEDS=1
setup() { printf '#!/bin/bash\ntrap "" TERM\nwhile true; do sleep 0.1; done\n' > terco.sh; chmod +x terco.sh; }
