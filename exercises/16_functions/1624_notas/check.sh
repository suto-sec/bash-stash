# checker spec for 1624 (see lib/engine.sh)
SCRIPT_NAME=notas.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('' '85' '95 82 77 60 55 101 -5 abc' '100 100 100' '0 100 50' '150 -1 abc xyz' '72 68 91')
extra_check() {
  local a t; eval "a=( $CASE )"
  for t in "${a[@]}"; do
    if [[ $t =~ ^[0-9]+$ ]] && [ "$t" -le 100 ]; then continue; fi
    [[ $REF_CODE != 1 ]] && mentions "$t"
  done
  must_use return
}
