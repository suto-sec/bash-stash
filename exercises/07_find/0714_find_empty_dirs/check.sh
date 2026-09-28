# checker spec for 0714 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p proyecto/{a/b,c,d/e,f}; touch proyecto/a/x proyecto/d/y; [[ $(rand 2) == 1 ]] && touch proyecto/c/z; mkdir -p "proyecto/$(word)"; }
