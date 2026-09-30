# checker spec for 1534 (see lib/engine.sh)
SCRIPT_NAME=stats_col.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local f i c l
  for f in medidas.txt "datos 2.txt"; do
    echo "id temp hum pres nota" > "$f"
    for i in $(seq "$(randr 3 9)"); do
      l="$i"
      for c in 1 2 3; do
        [[ $(rand 9) == 0 ]] && { echo "$l"; continue 2; }
        l+=" $(pick "$(randr 0 999)" "$(randr 0 999)" "$(randr 0 99)" NA -4 x1)"
      done
      echo "$l NA"
    done >> "$f"
  done
}
ARGS=('medidas.txt 2' 'medidas.txt temp' '"datos 2.txt" 3' '"datos 2.txt" pres' 'medidas.txt 1'
      'medidas.txt nota' '' 'medidas.txt' 'nada.txt temp' 'medidas.txt 9' 'medidas.txt 0' 'medidas.txt viento')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
