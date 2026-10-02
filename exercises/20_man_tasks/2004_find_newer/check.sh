# checker spec for 2004 (see lib/engine.sh)
SEEDS=3
setup() {
  mkdir -p informes/sub informes/otros
  touch -d '2024-03-10 12:00' referencia
  local f d
  for f in $(words 6); do
    d=$(pick '2024-02-0' '2024-04-0')$(randr 1 9)
    touch -d "$d 10:00" "informes/$f.txt"
  done
  for f in $(words 3); do touch -d "$(pick '2024-01-1' '2024-05-1')$(randr 0 9) 09:00" "informes/sub/$f.log"; done
}
extra_check() { must_use find; }
