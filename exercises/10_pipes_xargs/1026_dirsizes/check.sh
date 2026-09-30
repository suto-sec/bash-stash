# checker spec for 1026 (see lib/engine.sh)
SCRIPT_NAME=dirsizes.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local d i
  mkdir -p "data/old logs/2023" data/src/lib data/img "data/empty one" data/empty2 nosub
  for i in $(seq "$(randr 6 12)"); do
    d=$(pick "old logs" "old logs/2023" src src/lib img)
    bigfile "data/$d/$(word)$(pick '' ' ')$i" "$(randr 1 40)00"
  done
  bigfile "data/top file.txt" 5000
  bigfile nosub/a.txt 10
  [[ $(rand 2) == 1 ]] && mkdir -p "data/$(word) x"
  touch plain.txt
}
ARGS=('data' '"$W/data"' 'data/src' 'nosub' 'noexiste' 'plain.txt' '' 'data nosub')
extra_check() {
  case $REF_CODE in
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    1) [[ $ERR == *dirsizes.sh* || $ERR == *sage* ]] || fail "the usage message should show how to call the script" ;;
  esac
}
