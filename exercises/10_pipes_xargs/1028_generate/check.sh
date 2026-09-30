# checker spec for 1028 (see lib/engine.sh)
SCRIPT_NAME=generate.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i n
  printf 'Dear {{NAME}},\nyou are number {{N}}.\n%s\n{{NAME}} / {{N}} / {{NAME}}\n' "$(randtext 2)" > tpl.txt
  printf 'Report {{N}} for {{NAME}}\n' > "my template.txt"
  for i in $(seq "$(randr 4 8)"); do
    n=$(pick "$(word)" "$(word) $(word)" "$(word)-$i" "$(word)_$i")
    echo "$n"; [[ $(rand 4) == 0 ]] && echo "$n"
    [[ $(rand 4) == 0 ]] && pick "a/b$i" "bad.$i" "why?" ""
  done > names.txt
  echo "last one" >> names.txt
  [[ $(rand 2) == 1 ]] && { mkdir out; echo old > out/old.txt; echo old > "out/last one.txt"; }
  mkdir tpldir
  touch afile
}
ARGS=('tpl.txt names.txt out' '"my template.txt" names.txt "out dir"' 'tpl.txt names.txt "$W/out"' 'tpl.txt names.txt' 'nope.txt names.txt out' 'tpldir names.txt out' 'tpl.txt nope.txt out' 'tpl.txt names.txt afile' 'a b c d')
