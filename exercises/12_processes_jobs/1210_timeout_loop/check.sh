# checker spec for 1210 (see lib/engine.sh)
setup() { printf '#!/bin/bash\nsleep 0.%s\necho "result %s" > done.flag\n' "$(randr 3 9)" "$(word)" > worker.sh; chmod +x worker.sh; }
COMPARE="stdout exit"
