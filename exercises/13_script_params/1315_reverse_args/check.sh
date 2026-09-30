# checker spec for 1315 (see lib/engine.sh)
SEEDS=1
ARGS=('' 'a' 'a b c' '"x y" "" z' '1 2 3 4 5 6 7 8 9 10 11 12' '"*" "-n" "a  b"')
extra_check() { must_not_use tac sort; }
