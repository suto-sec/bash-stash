# checker spec for 1818 (see lib/engine.sh)
SCRIPT_NAME=minusculas.sh
COMPARE="stdout stderr exit files"
setup() { mkdir -p n/SubDir; local i w; for i in $(seq 7); do w=$(word)$i; touch "n/$(pick "${w^^}" "${w^}" "$w" "${w^^}.TXT")"; done; touch n/Dup n/dup n/.Hidden; }
ARGS=('n' 'noexiste')
