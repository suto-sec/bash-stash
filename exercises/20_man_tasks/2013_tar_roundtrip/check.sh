# checker spec for 2013 (see lib/engine.sh)
SEEDS=2
COMPARE="files exit"
setup() {
  mkdir -p datos/sub datos/otro
  local f
  for f in $(words 3); do randtext 2 > "datos/$f.txt"; done
  for f in $(words 2); do randtext 3 > "datos/sub/$f.log"; done
  randtext 1 > "datos/otro/$(word).md"
}
extra_check() { must_use tar; must_not_use cp cd; }
