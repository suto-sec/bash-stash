# checker spec for 0713 (see lib/engine.sh)
setup() { mkdir -p enlaces/sub; touch enlaces/real1 enlaces/sub/real2; local i; for i in $(seq 6); do ln -s "$(pick real1 sub/real2 noexiste ../noexiste real1)" "enlaces/$(word)$i"; done; }
