# checker spec for 0809 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p compartido/{a,b}; local i f; for i in $(seq 9); do f="compartido/$(pick . a b)/$(word)$i$(pick .txt .key .conf)"; touch "$f"; chmod "$(pick 666 644 600 602 777 640 664)" "$f"; done; }
