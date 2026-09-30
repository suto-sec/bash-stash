# checker spec for 0820 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { printf '#!/bin/bash\necho %s\n' "$(word)" > script.sh; chmod "$(pick 755 750 775 644 664 711)" script.sh; }
