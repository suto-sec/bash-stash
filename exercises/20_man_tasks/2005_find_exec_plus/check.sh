# checker spec for 2005 (see lib/engine.sh)
SEEDS=3
setup() {
  mkdir -p docs/a/b docs/c
  local f
  for f in $(words 3); do randtext "$(randr 2 5)" > "docs/$f.txt"; done
  for f in $(words 2); do randtext "$(randr 2 5)" > "docs/a/$f.txt"; done
  randtext 3 > "docs/a/b/$(word).txt"
  randtext 4 > "docs/c/$(word).md"
  randtext 2 > "docs/c/$(word).txt"
}
extra_check() { must_use find wc; }
