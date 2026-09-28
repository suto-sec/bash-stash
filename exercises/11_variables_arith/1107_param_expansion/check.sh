# checker spec for 1107 (see lib/engine.sh)
setup() { echo "/home/$(word)/$(word)/$(word).$(pick final v2 old).$(pick pdf txt tar)" > fichero.txt; }
extra_check() { must_not_use basename dirname sed cut awk; }
