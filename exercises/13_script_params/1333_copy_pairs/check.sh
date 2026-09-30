# checker spec for 1333 (see lib/engine.sh)
SCRIPT_NAME=copy_pairs.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() { mkf "origen uno.txt" "$(randtext 1)"; mkf origen_dos.txt "$(randtext 1)"; mkdir sub; }
ARGS=('' '"origen uno.txt"' '"origen uno.txt" destino1.txt' '"origen uno.txt" destino1.txt origen_dos.txt "sub/destino dos.txt"' '"origen uno.txt" destino1.txt noexiste.txt destino2.txt' 'noexiste.txt destino.txt')
extra_check() { [[ $REF_CODE == 2 ]] && mentions "noexiste.txt"; }
