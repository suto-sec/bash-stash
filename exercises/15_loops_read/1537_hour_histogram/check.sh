# checker spec for 1537 (see lib/engine.sh)
SCRIPT_NAME=histograma.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local f i hs
  for f in app.log "log viejo.log"; do
    hs=("$(printf %02d "$(randr 0 23)")" 08 09 "$(printf %02d "$(randr 10 23)")")
    for i in $(seq "$(randr 8 25)"); do
      case $(rand 10) in
        0) echo "$(words 3)" ;;
        1) echo "2024-05-0$(randr 1 9) $(pick 24 7 "${hs[0]}"):$(pick 00 61 15):$(pick 00 5 30) INFO $(words 2)" ;;
        2) echo "2024-05-01 $(pick "${hs[@]}"):$(randr 10 59):$(randr 10 59) $(pick DEBUG info) $(words 2)" ;;
        *) echo "2024-0$(randr 1 9)-1$(randr 0 9) $(pick "${hs[@]}"):$(randr 10 59):$(randr 10 59) $(pick INFO WARN ERROR ERROR) $(words "$(randr 1 4)")" ;;
      esac
    done > "$f"
  done
}
ARGS=('app.log' 'app.log error' '"log viejo.log" WARN' '"log viejo.log"' '' 'a b c' 'nada.log' 'app.log debug')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
