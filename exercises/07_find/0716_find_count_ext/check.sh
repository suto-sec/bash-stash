# checker spec for 0716 (see lib/engine.sh)
setup() { mkdir -p repo/{a,b/c}; local i; for i in $(seq 20); do touch "repo/$(pick . a b/c)/$(word)$i$(pick .c .h .c .md .txt .tar.gz '' .c)"; done; }
