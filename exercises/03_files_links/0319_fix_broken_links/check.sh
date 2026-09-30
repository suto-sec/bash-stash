# checker spec for 0319 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p links repuesto data
  local i w
  for i in 1 2 3; do w="$(word)$i.txt"; randtext 1 > "data/$w"; ln -s "../data/$w" "links/ok $i"; done
  for i in 4 5 6 7 8; do
    w="$(word)$i.$(pick txt csv)"
    (( i == 4 || $(rand 2) )) && randtext 1 > "repuesto/$w"
    ln -s "$(pick ../old /tmp/nothere/sub ../data/gone)/$w" "links/$(pick "l$i" "link $i" "$(word)$i")"
  done
  ln -s "../missing/zz9" "links/zz 9"
  randtext 2 > "links/$(word).txt"; randtext 1 > "repuesto/$(word)99.txt"
}
