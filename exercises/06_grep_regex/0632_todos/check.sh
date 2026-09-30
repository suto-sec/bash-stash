# checker spec for 0632 (see lib/engine.sh)
SCRIPT_NAME=todos.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p src/lib "src/my tools"
  local f i
  for f in src/main.c src/lib/util.c "src/my tools/run me.sh" src/build.sh src/notes.txt src/lib/x.h; do
    for i in $(seq "$(randr 3 9)"); do
      pick "// TODO: $(words 2)" "# FIXME: $(words 2)" "/* XXX: $(word) */" "#TODO:$(word)" "MYTODO: $(word)" "TODO $(word)" \
           "todo: $(word)" "TODO_list: $(word)" "x = 1; // TODO:   $(words 3)" "$(words 3)" "echo $(word) # FIXME:fix it" "  $(words 2)"
    done > "$f"
  done
  touch file.c
}
ARGS=('src' 'src FIXME' '"src/my tools" TODO' '"$W/src" XXX' 'src/lib' '' 'a b c' 'nodir' 'file.c' 'src todo' 'src BUG')
extra_check() {
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; [[ $REF_CODE == 2 ]] && echo "$1" || echo "$2")"
  true
}
