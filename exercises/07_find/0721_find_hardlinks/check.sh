# checker spec for 0721 (see lib/engine.sh)
setup() {
  mkdir -p store/a "store/b c/d"
  local i n
  mkfl store/original.dat "$(words 5)"
  n=$(randr 1 3)
  for i in $(seq "$n"); do ln store/original.dat "store/$(pick a 'b c' 'b c/d')/$(word) copy$i.dat"; done
  mkfl "store/a/$(word).log" "$(words 3)"
  for i in $(seq "$(randr 0 2)"); do ln store/a/*.log "store/$(pick . 'b c/d')/log$i.log"; done
  for i in $(seq 4); do mkfl "store/$(pick . a 'b c' 'b c/d')/$(word)$i.txt" "$(words 2)"; done
  ln -s ../original.dat "store/a/link to original"
}
