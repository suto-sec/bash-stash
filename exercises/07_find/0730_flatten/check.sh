# checker spec for 0730 (see lib/engine.sh)
SCRIPT_NAME=flatten.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p src/a "src/b c/d" src/e prev
  local i
  for i in $(seq "$(randr 7 12)"); do
    mkfl "src/$(pick . a 'b c' 'b c/d' e)/$(pick report notes 'my notes' data "$(word)").$(pick txt txt md TXT txt.bak)" "$i $(word)"
  done
  mkfl src/a/notes.txt "notes a"
  mkfl "src/b c/notes.txt" "notes bc"
  mkdir -p src/e/dir.txt
  mkfl prev/notes.txt "previous"
  [[ $(rand 2) == 1 ]] && mkfl prev/notes_2.txt "previous 2"
  touch afile
}
ARGS=('src out txt' 'src "my out" md' '"$W/src" "$W/out" txt' 'src prev txt' 'src/a prev txt' 'src out' 'src out txt x' 'nosrc out txt' 'afile out txt' 'src afile txt' 'src out t.x' 'src out ""')
