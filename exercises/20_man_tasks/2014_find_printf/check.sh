# checker spec for 2014 (see lib/engine.sh)
SEEDS=3
setup() {
  mkdir -p arbol/sub/hondo arbol/otros
  local f
  for f in $(words 3); do bigfile "arbol/$f.txt" "$(randr 5 300)"; done
  for f in $(words 3); do bigfile "arbol/sub/$f.log" "$(randr 5 300)"; done
  bigfile "arbol/sub/hondo/$(word).dat" "$(randr 5 300)"
}
extra_check() { must_use find; must_not_use stat; }
