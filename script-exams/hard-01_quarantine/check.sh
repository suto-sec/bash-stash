# checker spec for the practice exam hard-01 (see lib/engine.sh; graded by objectives with bin/sgrade)
SCRIPT_NAME=quarantine.sh
OBJECTIVES=(
  "args|Argument checking and error messages|2"
  "create|Creating the quarantine directory and its message|1"
  "select|Choosing the right files|2"
  "collision|Names that already exist in the quarantine|2"
  "failure|Files that cannot be moved: count and exit code|2"
  "default|Whole script on the current directory|1"
)
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  local d i f n=0
  mkdir -p plain/sub/deep "my dir/inner dir" dups/a dups/b dups/c locked/ro locked/rw empty/sub
  for d in plain plain/sub plain/sub/deep "my dir" "my dir/inner dir"; do
    for i in 1 2 3; do
      n=$((n + 1)); f="$d/$(word)$n$(pick .txt .log .conf .tmp .txt)"
      [[ $d == my* && $(rand 2) == 1 ]] && f="$d/my $(word)$n$(pick .txt .conf)"
      echo "data $n" > "$f"; chmod "$(pick 666 777 646 644 640 600 664 755 662)" "$f"
    done
  done
  echo t > plain/target.txt; chmod 666 plain/target.txt; ln -s target.txt plain/link.txt   # a symlink is not a regular file
  mkdir plain/wdir; chmod 777 plain/wdir                                                  # nor is a directory
  for d in a b c; do
    echo "from $d" > dups/$d/report.txt; chmod 666 dups/$d/report.txt
    echo "notes $d" > dups/$d/notes.txt; chmod "$(pick 666 644 666)" dups/$d/notes.txt
    echo "tmp $d" > dups/$d/scratch.tmp; chmod 666 dups/$d/scratch.tmp
  done
  echo "stuck" > locked/ro/stuck.txt; chmod 666 locked/ro/stuck.txt; chmod 555 locked/ro   # cannot be moved out
  echo "fine" > locked/rw/fine.txt; chmod 666 locked/rw/fine.txt
  echo "loose" > locked/loose.txt; chmod 666 locked/loose.txt
  echo "ok" > empty/sub/ok.txt; chmod 644 empty/sub/ok.txt
  echo x > notadir.txt
}
pre_q()  { mkdir -p "$H/quarantine"; }
pre_qr() { mkdir -p "$H/quarantine"; echo old > "$H/quarantine/report.txt"; echo older > "$H/quarantine/report.txt.1"; chmod 644 "$H/quarantine/report.txt" "$H/quarantine/report.txt.1"; }
ARGS=('plain "my dir"' 'nodir' 'notadir.txt'
      'empty' 'empty $(pre_q)'
      'plain $(pre_q)' '"my dir" $(pre_q)' '"$W/plain" $(pre_q)'
      'dups $(pre_q)' 'dups $(pre_qr)'
      'locked $(pre_q)'
      '$(pre_q)')
CASE_OBJ=(args args args  create create  select select select  collision collision  failure  default)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *quarantine.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
