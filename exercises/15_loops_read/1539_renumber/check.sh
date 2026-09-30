# checker spec for 1539 (see lib/engine.sh)
SCRIPT_NAME=renumera.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local d i
  for d in "fotos viaje" img; do
    mkdir -p "$d/album.jpg"
    for i in $(seq "$(randr 2 5)"); do randtext 1 > "$d/$(word)$(pick '' ' ' ' de ')$i.$(pick jpg jpg png)"; done
    touch "$d/x.JPG" "$d/y.jpgx" "$d/.oculta.jpg" "$d/IMG-7.jpg" "$d/IMG-0003.jpg"
    [[ $(rand 2) == 1 ]] && echo old > "$d/IMG-002.jpg"
    [[ $(rand 2) == 1 ]] && echo old > "$d/IMG-001.jpg"
    [[ $(rand 2) == 1 ]] && echo old > "$d/foto_-003.png"
  done
}
ARGS=('"fotos viaje" jpg IMG' 'img png foto_' 'img jpg IMG' '' 'img jpg' 'nada jpg IMG'
      'img JPG IMG' 'img jpg "a/b"')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  [[ $REF_CODE == 4 ]] && mentions "${a[2]}"
  true
}
