# checker spec for 1031 (see lib/engine.sh)
SCRIPT_NAME=tags.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i f t tl pool=(linux shell shell-script bash kernel net c2 exam)
  mkdir -p "notes/week 1" notes/old/deep
  for i in $(seq "$(randr 6 12)"); do
    f="notes/$(pick . 'week 1' old old/deep)/$(word)$(pick '' ' ')$i$(pick .md .md .md .txt .md.bak)"
    tl=""
    for t in $(seq "$(randr 1 4)"); do t=$(pick "${pool[@]}"); [[ ",$tl," == *",$t,"* ]] || tl+="${tl:+,}$t"; done
    { randtext 2; [[ $(rand 5) != 0 ]] && echo "tags:$(pick ' ' '' '  ')${tl//,/$(pick ', ' ',' ' , ')}"; echo "about shell and linux"; } > "$f"
  done
  echo "tags: shell, linux" > "notes/old/always.md"
  touch afile
}
ARGS=('notes' '"$W/notes/old"' 'notes shell' 'notes shell-script' '"notes/week 1" linux' 'notes nothere' 'notes Shell' 'notes "a b"' 'noexiste' 'afile shell' '' 'notes a b')
