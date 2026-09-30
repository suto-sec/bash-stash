# checker spec for 1427 (see lib/engine.sh)
SCRIPT_NAME=ip_classify.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i gen
  gen() {
    pick "10.$(rand 256).$(rand 256).$(rand 256)" "172.$(randr 14 33).$(rand 256).$(randr 1 254)" \
         "192.$(pick 168 169).$(rand 256).$(randr 1 254)" "127.0.0.$(randr 1 254)" "169.$(pick 254 253).$(rand 256).1" \
         "$(randr 223 240).$(rand 256).0.$(randr 1 9)" "$(randr 240 255).1.2.3" "0.$(rand 256).0.1" "$(ip_rand)" "$(ip_rand)" \
         "$(randr 256 300).1.1.1" "1.2.$(rand 9)" "01.2.3.4" "a.b.c.d" "1.2.3.4.5" "8.8.8.$(randr 256 999)" "1.2.3.-4"
  }
  for ((i = 0; i < $(randr 8 14); i++)); do gen; done > "ips list.txt"
  printf '%s\n' "" "10.0.0.1 " "255.255.255.255" >> "ips list.txt"
  for ((i = 0; i < 6; i++)); do gen; done | tr '\n' ' ' > args
  printf '%s\n' 8.8.8.8 192.168.1.1 > ok.txt
  echo 1.1.1.1 > locked.txt; chmod 000 locked.txt
}
ARGS=('-f "ips list.txt"' '$(cat args)' '10.0.0.1 172.31.255.255 172.32.0.1 172.15.0.1 192.168.0.0 169.254.1.1 224.0.0.1 239.255.255.255 240.0.0.1 0.0.0.0 127.0.0.1 8.8.8.8' '-f ok.txt' '-f nofile' '-f locked.txt' '-f' '' '-f ok.txt extra' '"1.2.3.4 " 1.2.3.04 256.0.0.1 1.2.3' '-f "$W/ok.txt"')
extra_check() {
  local tok
  if [[ $REF_CODE == 3 ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
