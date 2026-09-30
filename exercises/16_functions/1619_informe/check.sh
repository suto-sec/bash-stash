# checker spec for 1619 (see lib/engine.sh)
SCRIPT_NAME=informe.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkfl "notas 1.txt" "$(words 4)" "$(words 3)" "$(words 5)"
  mkfl notas2.txt "$(words 2)"
  echo secreto > privado.txt
  chmod 000 privado.txt
}
ARGS=('' '"notas 1.txt"' 'notas2.txt "notas 1.txt"' 'nada.txt "notas 1.txt"' 'privado.txt notas2.txt'
      '"notas 1.txt" nada.txt notas2.txt' 'nada.txt privado.txt')
extra_check() {
  local a f; eval "a=( $CASE )"
  for f in "${a[@]}"; do
    if [[ ! -f "$W/$f" || ! -r "$W/$f" ]]; then mentions "$f"; fi
  done
  must_use local
}
