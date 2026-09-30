# checker spec for 1336 (see lib/engine.sh)
SCRIPT_NAME=last_success.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() { mkf "legible archivo.txt" "$(randtext 2)"; touch sinpermiso.txt; chmod 000 sinpermiso.txt; mkdir soydir; }
ARGS=('' '"legible archivo.txt"' 'noexiste.txt' '"legible archivo.txt" noexiste.txt' 'noexiste.txt "legible archivo.txt"' 'sinpermiso.txt "legible archivo.txt" soydir' 'noexiste.txt noexiste2.txt')
