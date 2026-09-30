# checker spec for 0553 (see lib/engine.sh)
setup() {
  local content s pos i n len
  content=""
  for i in $(seq "$(randr 10 18)"); do content+="$(word)"; done
  s=$content
  len=${#s}
  n=$(randr 1 3)
  for i in $(seq "$n"); do
    pos=$(rand "$len")
    s="${s:0:pos}#${s:pos+1}"
  done
  printf '%s' "$content" > orig.bin
  printf '%s' "$s" > mod.bin
}
