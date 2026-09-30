# checker spec for 0411 (see lib/engine.sh)
COMPARE="stdout exit"
setup() {
  mkdir -p "trabajo/sub 1" trabajo/otros
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do randtext 2 > "trabajo/$(pick "sub 1" otros)/$(word)$i.txt"; done
}
capture() {
  [[ -f entrega.tar.bz2 ]] || { echo "NO ARCHIVE"; return; }
  bzip2 -t entrega.tar.bz2 2>/dev/null && echo "valid bzip2" || echo "invalid bzip2"
  tar -tjf entrega.tar.bz2 2>/dev/null | sort
}
