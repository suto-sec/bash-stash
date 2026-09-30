# checker spec for 0733 (see lib/engine.sh)
SCRIPT_NAME=where.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p docs/old "my projects/web" src
  local i
  for i in $(seq "$(randr 10 16)"); do
    touch "$(pick docs docs/old 'my projects' 'my projects/web' src)/$(pick report notes "$(word)" 'my report' README)$(pick '' ' ')$i$(pick .txt .md .sh .txt '')"
  done
  mkdir -p docs/dir.txt
  touch afile.txt
}
ARGS=("'*.txt' docs \"my projects\"" "'report*' src docs" "'*.md' \"\$W/my projects\"" "'*.zip' docs src" "'*.txt' docs noexiste src" "'*.txt' afile.txt" "'*.txt'" '')
extra_check() { if [[ $REF_CODE == 3 ]]; then [[ $CASE == *noexiste* ]] && mentions noexiste; [[ $CASE == *afile.txt* ]] && mentions afile.txt; fi; true; }
