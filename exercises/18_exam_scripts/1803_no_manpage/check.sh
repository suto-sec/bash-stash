# checker spec for 1803 (see lib/engine.sh)
SCRIPT_NAME=sinman.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p bin man1; local i n; for i in $(seq 10); do n="$(word)$i"; touch "bin/$n"; [[ $(rand 2) == 1 ]] && touch "man1/$n.1.gz"; done; touch man1/extra.1.gz "man1/$(word).8.gz"; }
ARGS=('bin man1' '' 'bin' 'noexiste man1' 'bin noexiste' 'a b c')
