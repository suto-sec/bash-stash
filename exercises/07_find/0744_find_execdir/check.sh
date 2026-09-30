# checker spec for 0744 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p data/a/b data/c
  touch data/tmp.dat data/a/tmp.dat data/a/b/tmp.dat data/c/tmp.dat
  touch data/a/tmp.dat.bak data/keep.dat data/a/b/tmp.data
}
extra_check() { must_use -execdir; }
