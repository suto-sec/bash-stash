# checker spec for 1531 (see lib/engine.sh)
SCRIPT_NAME=backup_list.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p docs "otros/sub dir" vacio
  local i f all=()
  for i in $(seq 5); do
    f="$(pick docs otros 'otros/sub dir')/$(word)$(pick '' ' ' ' de ')$i.$(pick txt md)"
    randtext "$(randr 1 3)" > "$f"; all+=("$f")
  done
  dup=$(word).txt; randtext 1 > "docs/$dup"; randtext 2 > "otros/$dup"
  all+=("docs/$dup" "otros/$dup")
  echo x > archivo.txt
  for f in lista.txt "mi lista.txt"; do
    { echo "# backup list"
      for i in $(seq "$(randr 4 8)"); do
        case $(rand 6) in 0) echo ;; 1) echo "docs/$(word) nada.txt" ;; 2) pick vacio otros ;; *) pick "${all[@]}" ;; esac
      done
      echo "docs/$(pick "$dup" "$dup" nada.txt)"; echo "otros/$dup"; } > "$f"
  done
  if [[ $(rand 2) == 1 ]]; then mkdir backup; echo old > backup/old.txt; fi
}
ARGS=('lista.txt backup' '"mi lista.txt" "copia nueva"' 'lista.txt "$W/abs/dest"' '' 'lista.txt'
      'nada.txt backup' 'lista.txt archivo.txt' 'docs backup')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
