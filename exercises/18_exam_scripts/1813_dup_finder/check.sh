# checker spec for 1813 (see lib/engine.sh)
SCRIPT_NAME=duplicados.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p d/{a,b}; local i c=(uno dos tres cuatro); for i in $(seq 10); do echo "$(pick "${c[@]}" "$(word)$i")" > "d/$(pick . a b)/$(word) $i"; done; touch d/e1 d/e2; }
ARGS=('d' 'd/a' 'noexiste')
