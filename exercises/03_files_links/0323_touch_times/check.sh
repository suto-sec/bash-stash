# checker spec for 0323 (see lib/engine.sh)
COMPARE="stdout exit files mtime"
setup() {
  local f
  for f in a b c d; do randtext 2 > "$f.txt"; touch -d "20$(randr 10 24)-0$(randr 1 9)-1$(randr 0 9) 1$(randr 0 9):$(randr 10 59)" "$f.txt"; done
  echo "20$(randr 10 24)-0$(randr 1 9)-2$(randr 0 8) 1$(randr 0 9):$(randr 10 59)" > fecha
  touch -d "2009-09-09 09:09" fecha
}
