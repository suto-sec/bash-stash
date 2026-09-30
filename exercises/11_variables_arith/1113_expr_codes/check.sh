# checker spec for 1113 (see lib/engine.sh)
setup() { echo "$(pick AB CDE F GHIJ KLM N)$(pick 1 12 123 4567 89012 3)" > codigo.txt; }
extra_check() { must_use expr; }
