# checker spec for 1219 (see lib/engine.sh)
SCRIPT_NAME=wait_for_flag.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() { printf '#!/bin/bash\nsleep 0.%s\necho "result %s" > done.flag\n' "$(randr 3 9)" "$(word)" > worker.sh; chmod +x worker.sh; }
ARGS=('' '1' 'abc 5' '1 abc' '0 5' '1 0' '1 20' '1 2' '2 3')
