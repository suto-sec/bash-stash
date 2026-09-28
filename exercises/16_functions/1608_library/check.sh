# checker spec for 1608 (see lib/engine.sh)
SEEDS=1
setup() { printf 'mayus() { echo "$*" | tr a-z A-Z; }\nrepite() { local i out=(); for ((i=0;i<$1;i++)); do out+=("$2"); done; echo "${out[*]}"; }\n' > lib.sh; }
ARGS=('hola' 'uno dos')
extra_check() { must_use source; ans_code | grep -qE '(mayus|repite) *\(\)' && fail "use the functions from lib.sh, don't redefine them"; }
