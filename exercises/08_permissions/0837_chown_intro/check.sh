# checker spec for 0837 (see lib/engine.sh)
COMPARE="stdout exit files owner"
RUN_AS_ROOT=1
SEEDS=1
setup() { touch informe.txt; }
extra_check() { must_use chown; }
