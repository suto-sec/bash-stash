# checker spec for 0731 (see lib/engine.sh)
SCRIPT_NAME=vaciar.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  local i p
  mkdir -p t/keep "t/sub dir/x/y" t/a/b/c t/lonely
  for i in $(seq "$(randr 6 10)"); do
    p="t/$(pick . keep 'sub dir' 'sub dir/x' 'sub dir/x/y' a a/b a/b/c)"
    if [[ $(rand 2) == 1 ]]; then touch "$p/$(word)$(pick '' ' ')$i"; else echo data > "$p/$(word)$(pick '' ' ')$i.txt"; fi
  done
  touch "t/sub dir/x/.keep"
  echo x > t/keep/.config
  mkdir -p "t/empty one/two" t/withlink
  ln -s ../keep t/withlink/link
  ln -s "../keep/.config" t/lonely/cfg
  touch file.txt
}
ARGS=('t' '"t/sub dir"' '"$W/t"' '' 't x' 'noexiste' 'file.txt')
