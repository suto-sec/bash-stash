# checker spec for 0316 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p nuevos archivo "nuevos/$(word)_dir"
  local i n w
  n=$(randr 4 7)
  for ((i = 1; i <= n; i++)); do
    w="$(word)$i"; (( i % 3 == 0 )) && w="$(word) $w"
    randtext 2 > "nuevos/$w.txt"
    if (( i == 1 || $(rand 3) == 0 )); then randtext 1 > "archivo/$w.txt"; fi
  done
  randtext 2 > "archivo/$(word)_old.txt"
}
