# checker spec for 0329 (see lib/engine.sh)
SCRIPT_NAME=materialize.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p pack "store/lib dir/inner" store/conf limpio
  local i f l first=
  for i in 1 2 3 4; do
    f="store/$(pick "$(word)$i.txt" "$(word) $i.cfg")"; randtext 2 > "$f"; chmod "$(pick 644 600 755)" "$f"
    l=$(pick "l$i" "link $i"); ln -s "../$f" "pack/$l"; first=${first:-$l}
  done
  randtext 1 > "store/lib dir/a.so"; randtext 1 > "store/lib dir/inner/b"
  ln -s "../store/lib dir" "pack/libs"
  ln -s "$PWD/store/conf" "pack/conf dir"; randtext 1 > store/conf/main.conf
  ln -s "$first" "pack/$(pick chain zchain)"
  (( $(rand 2) )) && ln -s "../store/nothere" "pack/rota $(word)"
  (( $(rand 2) )) && ln -s /nonexistent/x pack/zz_broken
  randtext 2 > "pack/$(word).md"
  ln -s ../store/conf/main.conf limpio/main.conf
  touch fich
}
ARGS=('pack' '"$W/pack"' 'limpio' 'fich' 'noexiste' '' 'pack limpio')
