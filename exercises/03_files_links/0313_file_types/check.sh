# checker spec for 0313 (see lib/engine.sh)
setup() {
  mkdir mystery
  randtext 3 > "mystery/$(word).jpg"
  printf '#!/bin/bash\necho hi\n' > "mystery/$(word)"
  gzip -c /etc/hostname > "mystery/$(word).txt"
  cp /usr/bin/true "mystery/$(word).doc"
  mkdir "mystery/$(word)_dir"
  ln -s /etc/passwd "mystery/$(word)_link"
}
