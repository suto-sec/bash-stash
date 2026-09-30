# checker spec for 1440 (see lib/engine.sh)
SEEDS=5
input() { local i n; n=$(randr 3 8); for i in $(seq "$n"); do pick si Si SI no No NO tal_vez ''; done; }
extra_check() { must_use read case; }
