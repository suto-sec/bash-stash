# checker spec for 1417 (see lib/engine.sh)
SEEDS=1
ARGS=('"" -- --help -v -vv -5 123 007 .bashrc .. ./run.sh /etc a/b.sh run.sh hello "two words" "*"' '- --x -Z x.sh.txt 0 "1 2" "-" "?"' '')
extra_check() { must_use case; }
