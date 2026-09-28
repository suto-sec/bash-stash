# checker spec for 1412 (see lib/engine.sh)
setup() { local i f; for i in 1 2 3 4 5 6; do f="f$i$(pick .sh .txt '')"; randtext "$(rand 2)" > "$f"; chmod "$(pick 755 644 600 700 200 311)" "$f"; echo "$f" >> list; done; mkdir d.sh; }
ARGS=('$(cat list) d.sh nope.sh')
