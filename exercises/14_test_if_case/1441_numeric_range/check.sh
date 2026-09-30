# checker spec for 1441 (see lib/engine.sh)
SCRIPT_NAME=numeric_range.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('' '1 10' '1 10 5' '1 10 1 10 0 11 -5 5' '-5 5 -5 5 -6 6 0' '10 1 5' 'abc 10 5' '1 abc 5' '1 10 5 abc 3.5 5')
extra_check() {
  local a; eval "a=( $CASE )"
  if [[ $REF_CODE == 2 ]]; then
    [[ ! ${a[0]} =~ ^-?[0-9]+$ ]] && mentions "${a[0]}"
    [[ ${a[0]} =~ ^-?[0-9]+$ && ! ${a[1]} =~ ^-?[0-9]+$ ]] && mentions "${a[1]}"
  fi
}
