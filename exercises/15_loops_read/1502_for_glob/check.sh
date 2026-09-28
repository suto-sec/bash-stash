# checker spec for 1502 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i; for i in $(seq 0 "$(randr 0 4)"); do [[ $i == 0 ]] && continue; randtext "$(randr 1 9)" > "$(word)$i.txt"; done; touch notes.md; }
