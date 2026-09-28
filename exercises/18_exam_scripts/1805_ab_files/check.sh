# checker spec for 1805 (see lib/engine.sh)
SCRIPT_NAME=ab.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p d/{alfa,beta~,c/b2}; local i; for i in $(seq 12); do touch "d/$(pick . alfa c c/b2)/$(pick a b c B)$(word)$i$(pick '' '~' '.txt' '.a~b')"; done; mkdir -p abc; touch abc/about bar; }
ARGS=('d' '' 'd/c' 'noexiste' 'bar')
