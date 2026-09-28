# checker spec for 1807 (see lib/engine.sh)
SCRIPT_NAME=grandes.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p d/{a,b} vacio uno; local i; for i in $(seq 8); do bigfile "d/$(pick . a b)/$(word) $i" "$(pick 100 2000 2000 5000 70000 70000 123)"; done; mkdir -p vacio/sub; bigfile uno/f 10; touch nodir; }
ARGS=('d' 'd/a' 'vacio' 'uno' 'nodir' 'noexiste')
