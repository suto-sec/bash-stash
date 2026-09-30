# checker spec for 1622 (see lib/engine.sh)
SCRIPT_NAME=primos.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('' '2 3 4 5 6 7 8 9 10' '17 18 19 20' '1 0 -3 abc' '13' '4 6 8 9 10 12' '2 x 4 -1 0 1' '97 100')
extra_check() {
  local a t; eval "a=( $CASE )"
  for t in "${a[@]}"; do
    if [[ $t =~ ^[0-9]+$ ]] && (( 10#$t >= 2 )); then continue; fi
    [[ $REF_CODE != 1 ]] && mentions "$t"
  done
  true
}
