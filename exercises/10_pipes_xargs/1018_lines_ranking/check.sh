# checker spec for 1018 (see lib/engine.sh)
setup() {
  mkdir -p "docs/sub dir" docs/a
  local i n
  n=$(randr 4 7)
  for i in $(seq "$n"); do randtext "$(randr 1 9)" > "docs/$(pick . 'sub dir' a)/$(word)$(pick '' ' ' '-')$i.txt"; done
  randtext 30 > "docs/a/huge.md"
  randtext 25 > "docs/sub dir/old.txt.bak"
}
