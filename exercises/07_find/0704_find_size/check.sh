# checker spec for 0704 (see lib/engine.sh)
setup() { mkdir -p datos/sub; local i; for i in $(seq 7); do bigfile "datos/$(pick . sub)/f$i" "$(pick 0 100 9000 11000 2000000 2200000 3500000)"; done; }
