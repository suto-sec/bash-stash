# checker spec for 1004 (see lib/engine.sh)
setup() { local i f; for i in $(seq 9); do f="$(word)$i"; if [[ $(rand 3) == 0 ]]; then mkdir "$f"; else touch "$f"; fi; chmod "$(pick 755 555 644 444 700)" "$f"; done; }
