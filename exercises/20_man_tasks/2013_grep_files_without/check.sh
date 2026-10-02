# checker spec for 2013 (see lib/engine.sh)
SEEDS=3
setup() {
  mkdir notas
  local f i=0
  for f in $(words 6); do
    { randtext 3; (( i % 2 == 0 )) && echo "TODO $(word)"; randtext 1; } > "notas/$f.txt"
    i=$(( i + 1 ))
  done
}
extra_check() { must_use grep; }
