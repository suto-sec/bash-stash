# checker spec for 1804 (see lib/engine.sh)
SCRIPT_NAME=addexec.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p p/{a,b/c} "p/con esp"; local i f; for i in $(seq 10); do f="p/$(pick . a b/c 'con esp')/$(word)$i$(pick .sh .sh .txt .sh.old)"; touch "$f"; chmod "$(pick 644 755 700 600 744 711)" "$f"; done; mkdir p/dir.sh; }
ARGS=('p' '"p/con esp"' 'noexiste' 'p/a/../b')
