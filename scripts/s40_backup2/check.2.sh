# checker spec for s40 step 2 (see lib/engine.sh)
SCRIPT_NAME=backup2.sh
setup() {
  mkdir -p src/sub/deep dst newparent empty
  echo a > src/a.txt; echo b > src/sub/b.txt; echo c > src/sub/deep/c.txt; echo w > "src/two words.txt"
  touch -d "@1700100000" src/a.txt; touch -d "@1700300000" src/sub/b.txt; touch -d "@1700500000" src/sub/deep/c.txt; touch -d "@1700200000" "src/two words.txt"
  echo l > src/locked.txt; chmod 000 src/locked.txt; touch -d "@1700600000" src/locked.txt
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *backup2.sh* ]]; }
pre_marker() { mkdir -p dstm; echo old > dstm/a.txt; echo "marker" > dstm/.last; touch -d "@1700250000" dstm/.last; }
SORT_OUTPUT=1
ARGS=('src dst' 'src dstm $(pre_marker)' 'empty dstm $(pre_marker)' 'src empty')
COMPARE="stdout exit files"
