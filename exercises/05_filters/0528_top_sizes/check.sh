# checker spec for 0528 (see lib/engine.sh)
ARGS=('' '3' '12')
setup() {
  local i n; n=$(randr 8 14)
  for ((i = 1; i <= n; i++)); do
    printf '%s\t%s\n' "$(pick 0 512 4.0K 4.0K 12K 96K 1.5M 20M 20M 256M 1.1G 3.0G)" \
      "/home/$(word)/$(pick docs "my photos" src "old stuff")/$(word)$i"
  done > uso.txt
}
extra_check() { must_use sort; }
