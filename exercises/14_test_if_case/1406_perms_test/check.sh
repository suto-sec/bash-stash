# checker spec for 1406 (see lib/engine.sh)
setup() { local i f; for i in 1 2 3 4; do f="f$i"; touch "$f"; chmod "$(pick 700 600 400 500 300 100 000 644)" "$f"; done; }
ARGS=('f1 f2 f3 f4')
