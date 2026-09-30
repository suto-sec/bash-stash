# checker spec for 1625 (see lib/engine.sh)
SCRIPT_NAME=agenda.sh
COMPARE="stdout exit errmsg files"
SEEDS=3
setup() {
  local extra1 extra2
  extra1=$(word); extra2=$(word)
  mkfl agenda.txt "ana:$(randr 600000000 699999999)" "$extra1:$(randr 600000000 699999999)" \
       "$extra2:$(randr 600000000 699999999)" "ana:$(randr 600000000 699999999)"
}
ARGS=('' 'buscar' 'listar' 'listar extra' 'buscar ana' 'buscar noexiste' 'borrar ana'
      'add carlos 612345678' 'add carlos abc123' 'add carlos' 'foo' 'add uno dos tres' 'borrar')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 4 ]] && mentions "${a[2]}"
  must_use die
}
