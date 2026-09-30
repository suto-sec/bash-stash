# checker spec for 0526 (see lib/engine.sh)
ARGS=('odd.txt' 'even.txt' 'one.txt' 'empty.txt' '"my notes.txt"')
setup() {
  local i n
  n=$(( 2 * $(randr 1 9) + 1 )); for ((i = 1; i <= n; i++)); do echo "$i: $(words 2)"; done > odd.txt
  n=$(( 2 * $(randr 1 9) ));     for ((i = 1; i <= n; i++)); do echo "$i: $(words 2)"; done > even.txt
  n=$(randr 1 12);               for ((i = 1; i <= n; i++)); do echo "$i: $(words 3)"; done > "my notes.txt"
  words 3 > one.txt
  : > empty.txt
}
extra_check() { must_use head; must_use tail; }
