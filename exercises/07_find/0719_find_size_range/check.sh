# checker spec for 0719 (see lib/engine.sh)
setup() {
  mkdir -p data/a "data/b c"
  local i
  for i in $(seq 12); do
    bigfile "data/$(pick . a 'b c')/$(word)$(pick '' ' ')$i.bin" "$(pick 0 1 500 999 1000 1024 1025 2500 4096 5000 5001 8000 $(randr 1 6000))"
  done
}
