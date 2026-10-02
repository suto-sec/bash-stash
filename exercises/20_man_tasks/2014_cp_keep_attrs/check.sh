# checker spec for 2014 (see lib/engine.sh)
SEEDS=2
COMPARE="files mtime exit"
setup() {
  mkdir -p origen/sub origen/vacio
  local f i=0
  for f in $(words 4); do mkf "origen/$f.txt" "$f"; chmod "$(pick 644 600 640 755)" "origen/$f.txt"; touch -d "2024-0$(( i % 5 + 1 ))-1$i 10:00" "origen/$f.txt"; i=$(( i + 1 )); done
  mkf "origen/sub/$(word).sh" x; chmod 750 origen/sub/*.sh; touch -d "2023-12-24 08:30" origen/sub/*.sh
  touch -d "2022-05-05 05:05" origen/sub origen/vacio
}
extra_check() { must_use cp; }
