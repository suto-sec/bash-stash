# checker spec for 0746 (see lib/engine.sh)
SCRIPT_NAME=big_recent.sh
SEEDS=2
setup() {
  mkdir -p dir1/sub dir2/sub
  local d i f sz days
  for d in dir1 dir2; do
    touch -d "10 days ago" "$d/.marca"
    for i in $(seq 5); do
      f="$d/$(pick . sub)/$(word)$i.dat"
      sz=$(pick 500000 800000 2000000 3000000 5000000)
      bigfile "$f" "$sz"
      days=$(pick 1 3 15 20)
      touch -d "$days days ago" "$f"
    done
  done
}
ARGS=('dir1' 'dir2' '"$W/dir1"')
