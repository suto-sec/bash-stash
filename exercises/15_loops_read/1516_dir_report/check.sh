# checker spec for 1516 (see lib/engine.sh)
setup() { mkdir -p base/{a,b,.oculto}; local i; for i in $(seq 4); do bigfile "base/$(word)$i" "$(randr 0 500)"; touch "base/$(pick a b .oculto)/x$i"; done; touch base/.hidden; ln -s a base/enlace; ln -s /etc/passwd base/pw; }
ARGS=('base')
