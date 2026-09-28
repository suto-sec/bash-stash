# checker spec for 0801 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local f; for f in script.sh publico.txt equipo.txt bloqueado.txt exacto.txt; do touch "$f"; chmod "$(pick 644 666 600 777 640 664 604)" "$f"; done; }
extra_check() { ans_code | grep -qE 'chmod +[0-7]{3}' && fail "use symbolic modes (u+x...), not octal, in this exercise"; }
