# checker spec for 0328 (see lib/engine.sh)
SCRIPT_NAME=versions.sh
SEEDS=4
COMPARE="stdout exit errmsg files"
setup() {
  local v i n name
  randtext 3 > notas.txt; randtext 2 > "mis notas.txt"; mkdir dir; touch fich
  mkdir -p vers
  for name in notas.txt "mis notas.txt"; do
    for v in "$H/versions" vers; do
      (( $(rand 3) == 0 )) && continue
      mkdir -p "$v"
      n=0
      for i in $(seq "$(randr 1 11)"); do
        (( $(rand 3) == 0 )) && continue
        randtext 2 > "$v/$name.v$i"; n=$i
      done
      (( n > 0 && $(rand 2) == 0 )) && cp "$name" "$v/$name.v$n"
      randtext 1 > "$v/$name.vold"; randtext 1 > "$v/$name.v3.bak"; randtext 1 > "$v/otro.txt.v99"
    done
  done
}
ARGS=('notas.txt' '"mis notas.txt"' '"mis notas.txt" vers' '"$W/notas.txt" "$W/nuevo/sub"' 'notas.txt vers' 'noexiste' 'dir' 'notas.txt fich' '' 'a b c')
