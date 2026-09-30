# checker spec for 0220 (see lib/engine.sh)
setup() { local x y; x=$(word)1 y=$(word)2; mkdir -p "real/$x/$y" "real/$(word)3"; ln -s "real/$x/$y" atajo; }
extra_check() { must_use '-P'; }
