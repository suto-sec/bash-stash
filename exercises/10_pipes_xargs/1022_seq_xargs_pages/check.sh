# checker spec for 1022 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randr 4 15 > n.txt; randtext 3 > template.txt; }
extra_check() { must_use seq xargs; must_not_use for while until; }
