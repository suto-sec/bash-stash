# checker spec for 1617 (see lib/engine.sh)
SEEDS=1
setup() {
  {
    echo 'contar_vocales() { echo "$1" | grep -o "[aeiouAEIOU]" | wc -l; }'
    echo 'es_largo() { [ "${#1}" -ge "$2" ]; }'
  } > lib_texto.sh
}
ARGS=('hola' 'xyz' 'murcielago' '' 'a e i o u' '"buenas tardes" ok')
extra_check() {
  must_use source
  ans_code | grep -qE '(contar_vocales|es_largo) *\(\)' && fail "use the functions from lib_texto.sh, don't redefine them"
  true
}
