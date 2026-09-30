# checker spec for 0728 (see lib/engine.sh)
SCRIPT_NAME=bigfiles.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "d/a b" d/c/e
  local i
  for i in $(seq "$(randr 8 12)"); do
    bigfile "d/$(pick . 'a b' c c/e)/$(word)$(pick '' ' ')$i$(pick .dat .bin '')" "$(pick 0 100 1024 1025 2048 4096 4097 9000 10240 10241 30000 $(randr 1 20000))"
  done
  bigfile "d/a b/big one.iso" "$(randr 12000 40000)"
  touch notadir
}
ARGS=('d 0' 'd 1' 'd 4' '"d/a b" 2' '"$W/d" 10' 'd 1000' 'd' 'd 1 x' 'noexiste 1' 'notadir 1' 'noexiste abc' 'd -1' 'd 1k')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
