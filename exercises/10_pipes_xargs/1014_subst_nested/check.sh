# checker spec for 1014 (see lib/engine.sh)
setup() { local d; d="$(word)/$(word)"; mkdir -p "$d"; local i; for i in $(seq "$(randr 1 6)"); do touch "$d/$(word)$i"; done; echo "$d/$(ls "$d" | head -n 1)" > ruta.txt; }
