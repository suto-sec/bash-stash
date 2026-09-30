# checker spec for 0748 (see lib/engine.sh)
SCRIPT_NAME=total_csv.sh
SEEDS=2
setup() {
  mkdir -p multi/sub none onlyone
  local i c
  for i in $(seq "$(randr 3 5)"); do
    c=$(randr 1 12)
    randtext "$c" > "multi/$(pick . sub)/f$i.csv"
  done
  randtext 5 > multi/decoy.txt
  c=$(randr 1 12)
  randtext "$c" > "onlyone/solo.csv"
  randtext 3 > onlyone/decoy.dat
  touch none/.keep
}
ARGS=('multi' 'none' 'onlyone' '"$W/multi"')
