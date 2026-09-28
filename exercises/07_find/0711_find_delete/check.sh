# checker spec for 0711 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p a/b c "d~"; local i; for i in $(seq 8); do touch "$(pick . a a/b c d~)/$(word)$i$(pick '~' '' '.txt~' '~.txt')"; done; }
