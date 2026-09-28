# checker spec for 1817 (see lib/engine.sh)
SCRIPT_NAME=auditoria.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p a/{x,y,z} limpio; local i f; for i in $(seq 9); do f="a/$(pick . x y z)/$(word)$i$(pick .sh .txt .bin)"; touch "$f"; chmod "$(pick 644 666 755 4755 2755 600 602 700)" "$f"; done; chmod 777 a/x; chmod 1777 a/y; touch limpio/ok.txt; }
ARGS=('a' 'limpio' 'noexiste')
