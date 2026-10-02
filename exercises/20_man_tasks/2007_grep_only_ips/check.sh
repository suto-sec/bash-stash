# checker spec for 2007 (see lib/engine.sh)
SEEDS=3
setup() {
  local i
  for i in $(seq "$(randr 6 10)"); do
    printf '%s - - [%s/Mar/2024:10:%s:%s] "GET /%s HTTP/1.1" 200 %s' "$(ip_rand)" "$(randr 10 28)" "$(randr 10 59)" "$(randr 10 59)" "$(word)" "$(randr 100 9000)"
    if (( $(rand 3) == 0 )); then printf ' via %s' "$(ip_rand)"; fi
    echo
  done > access.log
}
extra_check() { must_use grep; }
