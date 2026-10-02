# checker spec for s69 step 2 (see lib/engine.sh)
SCRIPT_NAME=startab.sh
setup() {
  mkdir -p tree/arch tree/Bdir tree/docs tree/bin~ "my dir" empty
  touch tree/alpha.txt tree/beta tree/"b~backup" tree/"a~" tree/notes tree/arch/b1.sh tree/arch/c.txt tree/arch/"a copy" tree/Bdir/x tree/docs/"a b.txt" tree/docs/Alpha tree/.a-hidden tree/bravo~2 tree/bin~/ok
  touch "my dir/apple" "my dir/pear" "my dir/b-side~"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *startab.sh* ]]; }
SORT_OUTPUT=1
ARGS=('tree' '"my dir"' 'empty')
COMPARE="stdout exit"
