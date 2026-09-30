# checker spec for 0343 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randtext 2 > original; }
extra_check() { must_use 'ln -s' readlink; }
