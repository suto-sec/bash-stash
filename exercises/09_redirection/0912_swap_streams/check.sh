# checker spec for 0912 (see lib/engine.sh)
COMPARE="stdout stderr exit"
setup() { printf '#!/bin/bash\necho "normal %s"\necho "error %s" >&2\n' "$(word)" "$(word)" > ruidoso.sh; chmod +x ruidoso.sh; }
