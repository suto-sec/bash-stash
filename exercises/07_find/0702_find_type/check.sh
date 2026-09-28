# checker spec for 0702 (see lib/engine.sh)
setup() { mkdir -p proyecto/{src/{core,net},include,docs}; local i; for i in $(seq 8); do touch "proyecto/$(pick src src/core src/net include docs)/$(word)$i.$(pick c h md c)"; done; }
