# checker spec for 0322 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir mezcla
  local i
  for i in $(seq "$(randr 1 3)"); do randtext 3 > "mezcla/$(word)$i.$(pick jpg bin dat)"; done
  printf '#!/bin/bash\necho hi\n' > "mezcla/$(word) script"
  for i in $(seq "$(randr 1 3)"); do gzip -c /etc/hostname > "mezcla/$(word)$i.$(pick txt md '')"; done
  cp /usr/bin/true "mezcla/$(word).txt"
  touch "mezcla/$(word) empty.txt"
  (( $(rand 2) )) && printf 'a,b\n1,2\n' > "mezcla/$(word).csv"
}
