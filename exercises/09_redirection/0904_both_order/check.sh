# checker spec for 0904 (see lib/engine.sh)
COMPARE="stdout stderr exit files"
setup() { printf '#!/bin/bash\necho "out %s"\necho "err %s" >&2\necho "out2 %s"\necho "err2" >&2\n' "$(word)" "$(word)" "$(word)" > ruidoso.sh; chmod +x ruidoso.sh; }
