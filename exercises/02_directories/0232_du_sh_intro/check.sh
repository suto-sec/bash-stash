# checker spec for 0232 (see lib/engine.sh)
setup() { mkdir -p datos/sub; bigfile "datos/$(word)" $(( $(randr 1 20) * 1024 )); bigfile "datos/sub/$(word)" $(( $(randr 1 20) * 1024 )); }
extra_check() { must_use du; }
