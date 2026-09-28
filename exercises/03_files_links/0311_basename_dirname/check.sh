# checker spec for 0311 (see lib/engine.sh)
setup() { echo "/home/$(word)/$(word)/$(randr 2020 2026)/$(word).tar.gz" > path.txt; }
extra_check() { must_use basename dirname; }
