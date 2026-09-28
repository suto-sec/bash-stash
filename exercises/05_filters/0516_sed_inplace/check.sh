# checker spec for 0516 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { { echo "debug=false"; local i; for i in $(seq 6); do echo "$(pick host db cache)$i=$(pick localhost localhost:5432 10.0.0.$i)"; [[ $(rand 3) == 0 ]] && echo "old$i=deprecated"; done; } > app.conf; }
extra_check() { must_use sed; }
