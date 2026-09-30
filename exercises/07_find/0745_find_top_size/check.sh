# checker spec for 0745 (see lib/engine.sh)
setup() {
  mkdir -p media/sub
  local i f sz
  for i in $(seq 8); do
    f="media/$(pick . sub)/$(word)$i.dat"
    sz=$(( i * 10000 + $(randr 1 9000) ))
    bigfile "$f" "$sz"
  done
  ln -s no_existe media/enlace
}
