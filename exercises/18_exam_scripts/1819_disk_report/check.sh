# checker spec for 1819 (see lib/engine.sh)
SCRIPT_NAME=espacio.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p r; local i d; for i in $(seq 5); do d="r/$(word)$i"; mkdir -p "$d/sub"; bigfile "$d/f" $(( $(randr 1 60) * 4096 )); bigfile "$d/sub/g" $(( $(randr 0 30) * 4096 )); done; bigfile r/top $((20 * 4096)); }
ARGS=('r' 'r 1' 'r 10' 'noexiste' 'r 0' 'r x')
