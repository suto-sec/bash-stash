# checker spec for 0739 (see lib/engine.sh)
SCRIPT_NAME=tallas.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p data/a/sub "data/b c"
  local i
  for i in $(seq "$(randr 8 12)"); do
    bigfile "data/$(pick . a a/sub 'b c')/$(word)$(pick '' ' ')$i" "$(pick 0 0 1 700 1024 1025 5000 70000 1048576 $(randr 1 3000))"
  done
  bigfile "data/b c/big $(word).iso" 1048577
  [[ $(rand 2) == 1 ]] && bigfile "data/a/huge.bin" 2000000
  touch afile
}
ARGS=('data' 'data/a "data/b c"' '"$W/data"' 'data noexiste data/a' '' 'afile')
extra_check() { if [[ $REF_CODE == 2 ]]; then [[ $CASE == *noexiste* ]] && mentions noexiste; [[ $CASE == afile ]] && mentions afile; fi; true; }
