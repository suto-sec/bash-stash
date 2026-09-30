# checker spec for 0120 (see lib/engine.sh)
SCRIPT_NAME=genmv.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local d i
  for d in fotos "mis fotos"; do
    mkdir -p "$d/sub.dir"
    touch "$d/it's $(word).png" "$d/$(word) $(word).PNG"
    for i in 1 2 3; do
      touch "$d/$(pick "$(word)$i.jpg" "cost \$$i.txt" "$(word)$i.tar.gz" "README$i" "a*$i.c")"
    done
    touch "$d/.hidden$(word).jpg" "$d/sub.dir/inner.jpg"
  done
  mkdir vacio vacio/sub; touch vacio/.oculto nodir
}
ARGS=('fotos img' '"mis fotos" viaje-2026' '"$W/fotos" x_1' 'vacio img' 'nodir img' 'noexiste img' 'fotos ""' 'fotos "a b"' 'fotos "img*"' 'fotos' '')
extra_check() {
  local a=(); mapfile -t a < <(cd "$W" && eval "set -- $CASE" && printf '%s\n' "$@")
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 0 ]] && ! bash -n <<< "$OUT" 2>/dev/null && fail "the printed script has a syntax error"
  true
}
