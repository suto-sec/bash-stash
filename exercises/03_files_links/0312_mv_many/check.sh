# checker spec for 0312 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i; for i in $(seq 1 "$(randr 2 5)"); do touch "$(word)$i.log" "$(word)$i.png" "foto$i.jpg" "informe_$i.$(pick pdf odt txt)" "$(word)$i.c"; done; }
