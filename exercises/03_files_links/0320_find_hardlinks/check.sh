# checker spec for 0320 (see lib/engine.sh)
setup() {
  mkdir -p datos otros
  randtext 3 > datos/master
  local i n
  n=$(randr 1 4)
  for ((i = 1; i <= n; i++)); do ln datos/master "datos/$(pick "$(word)$i" "copy $i" "$(word) $(word)$i")"; done
  for ((i = 1; i <= $(randr 1 3); i++)); do cp datos/master "datos/$(word)_cp$i"; done
  ln -s master "datos/$(word)_sym"; ln -s "$PWD/datos/master" "datos/abs link"
  (( $(rand 2) )) && ln datos/master "otros/$(word)"
  randtext 1 > "datos/$(word).txt"; mkdir "datos/$(word)_dir"
}
extra_check() { must_use stat; }
