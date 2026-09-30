# checker spec for 0729 (see lib/engine.sh)
SCRIPT_NAME=ages.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d "d/sub dir/deep" d/x
  local i now f
  now=$(date +%s)
  for i in $(seq "$(randr 8 13)"); do
    f="d/$(pick . 'sub dir' 'sub dir/deep' x)/$(word)$(pick '' ' ')$i.$(pick txt log dat)"
    echo "$i" > "$f"
    touch -d "@$((now - $(pick 0 0 1 2 3 5 6 7 8 10 30 90) * 86400 - $(randr 600 30000)))" "$f"
  done
  ln -s "$(basename "$f")" "$(dirname "$f")/link to last"
  touch nodir
}
ARGS=('d' 'd 3' 'd 1' '"d/sub dir" 10' '"$W/d" 30' '' 'd 3 x' 'noexiste' 'nodir 3' 'd 0' 'd abc')
