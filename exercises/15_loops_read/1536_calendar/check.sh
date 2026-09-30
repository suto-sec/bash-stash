# checker spec for 1536 (see lib/engine.sh)
SCRIPT_NAME=calendario.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('31 1' '30 7' '28 1' '29 4' '31 6' '' '31' '31 x' 'dos 1' '32 1' '30 8' '31 0' 'a b c')
extra_check() {
  local a; eval "a=( $CASE )"
  if [[ $REF_CODE == 2 ]]; then [[ ${a[0]} =~ ^[0-9]+$ ]] && mentions "${a[1]}" || mentions "${a[0]}"; fi
  if [[ $REF_CODE == 3 ]]; then (( a[0] >= 28 && a[0] <= 31 )) && mentions "${a[1]}" || mentions "${a[0]}"; fi
  true
}
