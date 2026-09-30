# checker spec for 0740 (see lib/engine.sh)
setup() {
  mkdir -p "var/log"
  local i f sz days
  for i in $(seq 12); do
    f="var/log/$(word)$i$(pick .log .LOG .Log .txt .logx .logbak)"
    sz=$(pick 3000 5000 5200 9000 20000)
    bigfile "$f" "$sz"
    days=$(pick 1 5 13 15 45)
    touch -d "$days days ago" "$f"
  done
}
