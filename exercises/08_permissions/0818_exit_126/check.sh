# checker spec for 0818 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  printf '#!/bin/bash\necho "hello from %s"\n' "$(word)" > hola.sh; chmod 644 hola.sh
  mkdir cerrado; randtext 1 > cerrado/dato; chmod 600 cerrado
}
