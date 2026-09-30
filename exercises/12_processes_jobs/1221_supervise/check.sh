# checker spec for 1221 (see lib/engine.sh)
SCRIPT_NAME=supervise.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
randr 0 3 > remaining_fails
printf '#!/bin/bash\nf=$(cat remaining_fails)\nif [ "$f" -gt 0 ]; then echo $((f - 1)) > remaining_fails; exit 1; fi\nexit 0\n' > worker.sh
chmod +x worker.sh
}
ARGS=('' '1' '3' '5' 'abc' '0' '6')
extra_check() { must_use wait; }
