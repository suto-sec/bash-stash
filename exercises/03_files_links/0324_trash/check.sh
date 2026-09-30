# checker spec for 0324 (see lib/engine.sh)
SCRIPT_NAME=trash.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p sub "my dir"
  local f
  for f in a b "x y.txt" sub/a "sub/x y.txt" c.log; do randtext 2 > "$f"; done
  ln -s c.log enlace
  if (( $(rand 2) )); then
    mkdir "$H/.papelera"; randtext 1 > "$H/.papelera/a"
    (( $(rand 2) )) && randtext 1 > "$H/.papelera/a.1"
    (( $(rand 2) )) && randtext 1 > "$H/.papelera/x y.txt"
  fi
}
ARGS=('a' '"x y.txt" b' 'a sub/a "$W/sub/a"' 'noexiste a' '"my dir" "x y.txt" enlace' '"$W/sub/x y.txt" "x y.txt" c.log' '')
extra_check() {
  if [[ $CASE == 'noexiste a' ]]; then mentions noexiste; fi
  if [[ $CASE == '"my dir"'* ]]; then mentions "my dir"; fi
}
