# checker spec for 1629 (see lib/engine.sh)
SCRIPT_NAME=tamano_rec.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "raiz/sub uno/deep" "raiz/sub dos" "raiz/.oculto"
  local i
  for i in $(seq 3); do bigfile "raiz/$(word)$(pick '' ' ')$i.dat" "$(randr 0 300)"; done
  for i in $(seq 2); do bigfile "raiz/sub uno/$(word)$(pick '' ' ')$i.dat" "$(randr 0 300)"; done
  bigfile "raiz/sub uno/deep/$(word).dat" "$(randr 0 300)"
  bigfile "raiz/sub dos/$(word).dat" "$(randr 0 300)"
  bigfile "raiz/.oculto/$(word).dat" "$(randr 0 300)"
  ln -s "sub uno" "raiz/enlace"
  touch nota.txt
}
ARGS=('raiz' '' 'raiz extra' 'nota.txt' 'noexiste')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  must_use tamano read
}
