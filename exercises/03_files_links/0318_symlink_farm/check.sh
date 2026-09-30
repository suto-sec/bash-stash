# checker spec for 0318 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir scripts "scripts/$(word).sh"
  local i n w
  n=$(randr 3 6)
  for ((i = 1; i <= n; i++)); do
    w="$(word)$i"; (( i == 2 )) && w="$(word) $w"
    printf '#!/bin/bash\necho %s\n' "$w" > "scripts/$w.sh"
  done
  randtext 2 > "scripts/$(word).txt"; randtext 1 > "scripts/$(word).sh.bak"
}
