# checker spec for 1321 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=collect.sh
COMPARE="stdout stderr exit files"
setup() { echo one > "a b.txt"; echo two > c.txt; mkdir sub "out dir"; echo x > dest.txt; }
ARGS=('"a b.txt" c.txt "out dir"' 'c.txt nope sub "out dir"' 'c.txt' '' 'c.txt dest.txt' 'c.txt nodir' '"a b.txt" "$W/out dir"' 'sub')
