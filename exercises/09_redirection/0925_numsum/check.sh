# checker spec for 0925 (see lib/engine.sh)
SCRIPT_NAME=numsum.sh
SEEDS=3
COMPARE="stdout exit errmsg"
mknums() { local i; for i in $(seq "$1"); do pick "$(randr 0 500)" "-$(randr 1 300)" "$(randr 1 9)" 0 "" 007 +3 1.5 " 4" abc "12 13" "-"; done; }
setup() { mknums 14 > nums.txt; mknums 6 > "my nums.txt"; printf '5\n\n-2\n' > good.txt; printf '\n\n' > empty.txt; mkdir dir; }
input() { mknums 10; }
ARGS=('' '-' 'nums.txt' '"my nums.txt"' 'good.txt' 'empty.txt' 'nofile' 'dir' 'a b')
extra_check() {
  if [[ $REF_CODE == [03] && $ERR != "$REF_ERR" ]]; then fail "stderr must be exactly the 'line N: invalid ...' messages"; fi
  [[ $REF_CODE == [12] && -z $ERR ]] && fail "expected an error message on stderr"
  true
}
