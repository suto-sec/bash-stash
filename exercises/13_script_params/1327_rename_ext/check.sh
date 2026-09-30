# checker spec for 1327 (see lib/engine.sh)
SCRIPT_NAME=chext.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local d i n
  mkdir "my files"
  for d in "my files" .; do
    for ((i = 1; i <= $(randr 2 4); i++)); do
      n=$(pick "$(word)$i" "my $(word)$i" "$(word) $(word)$i")
      echo "$i" > "$d/$n.$(pick txt txt log)"
    done
    n=$(word)
    echo a > "$d/$n.txt"; echo b > "$d/$n.$(pick md log)"
    echo c > "$d/x$(rand 9).txt.bak"; echo d > "$d/$(word).TXT"; echo e > "$d/.hidden.txt"
    echo f > "$d/txtfile"; mkdir "$d/dir$(rand 9).txt"
  done
  echo z > notadir
}
ARGS=('txt md "my files"' 'log txt "my files"' 'txt md' 'txt md noexiste' 'txt md notadir' 'txt txt' 't.x md' 'txt ""' 'txt' 'a b c d' 'log bak "$W/my files"' 'TXT txt')
extra_check() {
  local tok
  if [[ $REF_CODE == [245] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
