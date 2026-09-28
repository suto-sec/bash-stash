# checker spec for 0209 (see lib/engine.sh)
setup() {
  mkdir data; local i n
  for i in $(seq 6); do
    n="$(word)_$i.bin"; bigfile "data/$n" $(( $(randr 1 90) * 100 + i ))
    touch -d "2026-0$(randr 1 5)-$(randr 10 28) $(randr 10 23):00" "data/$n"
  done
}
