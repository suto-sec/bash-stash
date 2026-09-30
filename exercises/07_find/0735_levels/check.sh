# checker spec for 0735 (see lib/engine.sh)
SCRIPT_NAME=niveles.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i j p n
  mkdir -p "t/sub dir" vacio
  for i in $(seq "$(randr 5 9)"); do
    p=t; n=$(randr 0 4)
    for ((j = 0; j < n; j++)); do p="$p/$(pick a b 'c d' 'sub dir')"; done
    mkdir -p "$p"
    [[ $(rand 3) != 0 ]] && touch "$p/$(word)$(pick '' ' ')$i"
  done
  touch "t/sub dir/.hidden"
  ln -s ../.. "t/sub dir/uplink"
  touch file.txt
}
ARGS=('t' 't 2' '"$W/t" 1' '"t/sub dir"' 'vacio' 't 99' '' 't 2 3' 'noexiste' 'file.txt' 't 0' 't x')
