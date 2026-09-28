# checker spec for 0903 (see lib/engine.sh)
COMPARE="stdout stderr exit"
setup() { printf '#!/bin/bash\necho "out %s"\necho "err %s" >&2\necho "out2 %s"\nexit %s\n' "$(word)" "$(word)" "$(word)" "$(randr 1 5)" > ruidoso.sh; chmod +x ruidoso.sh; }
