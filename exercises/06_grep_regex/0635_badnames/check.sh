# checker spec for 0635 (see lib/engine.sh)
SCRIPT_NAME=badnames.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n
  mkdir -p tree "tree/dir with space" tree/normal-dir clean/sub
  for i in $(seq 7); do
    n=$(pick "good_$(word).txt" "$(word) $(word).txt" "-$(word)" "what?$i" "a&b$i" "x#y$i" "file($i).txt" ".hidden$i" "don't$i" "-dash dir$i" "$(word)-$i.tar.gz" "$(word):$i")
    touch "tree/$(pick . 'dir with space' normal-dir)/$n"
  done
  touch "tree/-rf" "tree/normal-dir/ok.txt" clean/a.txt clean/sub/B-2.md clean/.x file.txt
}
ARGS=('' 'tree' '"$W/tree"' '"tree/dir with space"' 'clean' 'a b' 'nodir' 'file.txt')
extra_check() { [[ $REF_CODE == 2 ]] && mentions "$CASE"; true; }
