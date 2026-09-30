# checker spec for 1526 (see lib/engine.sh)
SEEDS=3
setup() {
  mkdir -p "datos/sub dir/x"
  local i
  for i in $(seq 5); do bigfile "datos/$(pick . 'sub dir' 'sub dir/x')/$(word)$(pick '' ' ' ' - ')$i" "$(randr 0 400)"; done
  bigfile "datos/sub dir/raro"$'\n'"nombre" "$(randr 0 400)"
  bigfile "datos/$(word)"$'\n'"x.txt" "$(randr 0 400)"
}
ARGS=('0' '150' '300')
extra_check() { must_use read; }
