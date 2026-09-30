# checker spec for 0630 (see lib/engine.sh)
SCRIPT_NAME=checkips.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i
  for i in $(seq 22); do
    case $(rand 3) in
      0) ip_rand ;;
      1) pick 0.0.0.0 255.255.255.255 10.0.0.255 192.168.1.1 "$(ip_rand)" "$(randr 200 255).$(randr 240 255).1.$(randr 0 9)" ;;
      *) pick 256.1.1.1 01.2.3.4 1.2.3 1.2.3.4.5 "1.2.3.4 " " 8.8.8.8" a.b.c.d 1.2.3.04 300.300.1.1 "" "1..2.3" "$(ip_rand)x" "ip $(ip_rand)" 1.2.3.000 ;;
    esac
  done > ips.txt
  for i in $(seq 8); do pick "$(ip_rand)" 999.1.1.1 "1.2.3" "" "$(ip_rand).1"; done > "my ips.txt"
  printf '%s\n' 1.2.3 "" 01.1.1.1 "x 1.1.1.1" 256.0.0.0 > bad.txt
  mkdir dir
}
ARGS=('ips.txt' '"my ips.txt"' 'bad.txt' '' 'a b' 'nofile' 'dir')
extra_check() { [[ $REF_CODE == 2 ]] && mentions "$CASE"; true; }
