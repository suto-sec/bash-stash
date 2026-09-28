# checker spec for 0210 (see lib/engine.sh)
setup() { local i d; for i in $(seq "$(randr 2 5)"); do d="$(word)_d$i"; mkdir -p "$d"; touch "$(word)_f$i" "$d/inner"; done; }
