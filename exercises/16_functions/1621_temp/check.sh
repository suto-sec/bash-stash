# checker spec for 1621 (see lib/engine.sh)
SCRIPT_NAME=temp.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('C 0' 'C 100' 'F 212' 'C -40' 'F 32' '' 'C' 'X 10' 'C abc' 'C 10 20')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  must_use die
}
