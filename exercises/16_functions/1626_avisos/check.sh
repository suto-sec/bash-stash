# checker spec for 1626 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout errmsg exit"
ARGS=('ana=30' 'ana=30 luis=20' 'malformato' 'x=abc' '=5' 'a=1=2' '' 'ana=30 x=abc y=200 lu=15' 'pedro=121 luis=0')
extra_check() {
  local a t nm ed; eval "a=( $CASE )"
  for t in "${a[@]}"; do
    case $t in
      *=*)
        nm=${t%%=*}; ed=${t#*=}
        if [[ -z $nm || $ed == *=* ]]; then mentions "$t"; continue; fi
        if [[ ! $ed =~ ^[0-9]+$ ]]; then mentions "$t"; continue; fi
        if (( 10#$ed > 120 )); then mentions "$t"; fi
        ;;
      *) mentions "$t" ;;
    esac
  done
  must_use queja
}
