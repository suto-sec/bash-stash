# checker spec for 0808 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir caja; touch "caja/$(word)"; }
