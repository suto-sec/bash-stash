# checker spec for 0530 (see lib/engine.sh)
setup() {
  local t=$(( $(randr 0 20) * 3600 )) i j r m n; n=$(randr 8 14)
  for ((i = 0; i < n; i++)); do
    m=$(pick "link up" "link down" "disk full on /dev/sda1" "CRON job started" "Connection from 10.0.0.$(rand 4)" "cron job started")
    r=$(pick 1 1 2 3 5)
    for ((j = 0; j < r; j++)); do
      t=$(( t + $(randr 1 90) ))
      printf '%02d:%02d:%02d %s\n' $(( t / 3600 )) $(( t / 60 % 60 )) $(( t % 60 )) "$m"
    done
  done > syslog.txt
}
extra_check() { must_use uniq; }
