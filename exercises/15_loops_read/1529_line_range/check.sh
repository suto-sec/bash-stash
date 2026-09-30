# checker spec for 1529 (see lib/engine.sh)
SCRIPT_NAME=lineas.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local f i
  for f in "mis notas.txt" texto.txt; do
    { for i in $(seq "$(randr 4 9)"); do echo "$(pick '' '  ' '	')$(words "$(randr 1 5)")$(pick '' ' \n' ' C:\dir')"; done
      [[ $(rand 2) == 1 ]] && printf '%s' "$(words 2)"; } > "$f"
  done
  mkdir dir; echo x > secreto.txt; chmod 000 secreto.txt
}
ARGS=('"mis notas.txt" 2 5' 'texto.txt 1 3' 'texto.txt 4 100' '"mis notas.txt" 3 3' '' 'texto.txt 1'
      'nada.txt 1 2' 'dir 1 2' 'secreto.txt 1 2' 'texto.txt 0 2' 'texto.txt 1 x7' 'texto.txt 5 2')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  if [[ $REF_CODE == 3 ]]; then [[ ${a[1]} =~ ^[0-9]+$ ]] && (( ${a[1]} > 0 )) && mentions "${a[2]}" || mentions "${a[1]}"; fi
  must_use while read break
}
