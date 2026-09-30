# checker spec for 1119 (see lib/engine.sh)
setup() {
  local n1 n2 b
  n1=$(randr 10 9999)
  b=$(pick 2 3 4 5 6 7 8 9 11 12 13 14 15 16)
  n2=$(randr 10 9999)
  echo "$n1" > n.txt
  echo "$b" > base.txt
  echo "obase=$b; $n2" | bc > digits.txt
}
extra_check() { must_use bc; }
