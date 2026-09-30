# checker spec for 1623 (see lib/engine.sh)
SCRIPT_NAME=clasificar.sh
SEEDS=1
COMPARE="stdout exit errmsg"
setup() {
  {
    echo 'es_numero() { [[ $1 =~ ^-?[0-9]+$ ]]; }'
    echo 'es_par() { (( $1 % 2 == 0 )); }'
  } > lib_num.sh
}
ARGS=('' '5' '-4' '0' '3 -2 0 7 -8 abc' '10 11 12 13 -0' '42 -17 x -3.5 99')
extra_check() {
  must_use source
  ans_code | grep -qE '(es_numero|es_par) *\(\)' && fail "use the functions from lib_num.sh, don't redefine them"
  true
}
