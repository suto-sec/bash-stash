# checker spec for 1439 (see lib/engine.sh)
SCRIPT_NAME=safe_delete.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  touch -d "2026-05-10 10:00" ref.txt
  mkf "viejo espacio.txt" "$(randtext 1)"; touch -d "2026-01-01 00:00" "viejo espacio.txt"
  mkf nuevo.txt "$(randtext 1)"; touch -d "2026-09-01 00:00" nuevo.txt
  mkf solo_lectura.txt "$(randtext 1)"; touch -d "2026-01-01 00:00" solo_lectura.txt; chmod 444 solo_lectura.txt
  mkf ejecutable.sh "$(randtext 1)"; touch -d "2026-01-01 00:00" ejecutable.sh; chmod 755 ejecutable.sh
  mkdir -p carpeta_vieja; touch -d "2026-01-01 00:00" carpeta_vieja
}
ARGS=('' 'ref.txt' '"ref.txt" "viejo espacio.txt"' '"ref.txt" nuevo.txt' '"ref.txt" solo_lectura.txt' '"ref.txt" ejecutable.sh' '"ref.txt" carpeta_vieja' '"ref.txt" noexiste.txt' '"ref.txt" "viejo espacio.txt" nuevo.txt solo_lectura.txt ejecutable.sh carpeta_vieja noexiste.txt' 'noexiste_ref.txt "viejo espacio.txt"')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
}
