# checker spec for 1518 (see lib/engine.sh)
setup() { local k; k=$(randr 1 7); printf '#!/bin/bash\nn=$(cat .flaky_state 2>/dev/null || echo 0)\nn=$((n+1)); echo $n > .flaky_state\n[ $n -ge %s ] && exit 0 || exit 1\n' "$k" > flaky.sh; chmod +x flaky.sh; }
