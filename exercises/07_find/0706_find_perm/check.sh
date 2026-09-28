# checker spec for 0706 (see lib/engine.sh)
setup() { mkdir -p bin/sub; local i f; for i in $(seq 10); do f="bin/$(pick . sub)/$(word)$i$(pick .sh .bin '')"; touch "$f"; chmod "$(pick 755 644 600 700 664 775 711 666 744 601)" "$f"; done; }
