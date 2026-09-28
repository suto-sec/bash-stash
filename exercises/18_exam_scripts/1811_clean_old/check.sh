# checker spec for 1811 (see lib/engine.sh)
SCRIPT_NAME=limpia.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p t/{a,b}; local i f; for i in $(seq 10); do f="t/$(pick . a b)/$(word)$i$(pick .tmp '~' .txt .tmp.keep)"; touch -d "$(pick 1 3 6 10 20 40) days ago" "$f"; done; touch nodir; }
ARGS=('t' 't 2' 't 15' 't/a 0' 'noexiste' 'nodir' 't -3' 't abc' 'a b c')
