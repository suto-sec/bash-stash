# checker spec for 0521 (see lib/engine.sh)
setup() { printf '%s\t%s\r\n%s  \n' "$(word)" "$(word)" "$(word)" > raro.txt; }
extra_check() { must_use od; }
