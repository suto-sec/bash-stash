# checker spec for 0751 (see lib/engine.sh)
SCRIPT_NAME=possible_dupes.sh
SEEDS=2
setup() {
  mkdir -p store/a store/b
  local i s1 s2 s3 s4 s5
  s1=$(randr 1000 9000); s2=$(randr 10000 19000); s3=$(randr 20000 29000)
  s4=$(randr 30000 39000); s5=$(randr 40000 49000)
  local sizes=($s1 $s1 $s2 $s3 $s3 $s3 $s4 $s5 $s5)
  i=0
  for s in "${sizes[@]}"; do
    i=$((i+1))
    bigfile "store/$(pick . a b)/$(word)$i.dat" "$s"
  done
}
ARGS=('store' '"$W/store"')
