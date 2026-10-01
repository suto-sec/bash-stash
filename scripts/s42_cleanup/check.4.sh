# checker spec for s42 step 4 (see lib/engine.sh)
SCRIPT_NAME=cleanup.sh
setup() {
  mkdir -p tmp/sub tmp/ro "my tmp" empty
  local n=0 f
  for f in tmp/a.tmp tmp/b.tmp "tmp/c~" tmp/sub/d.tmp tmp/sub/e~ "my tmp/two words.tmp" tmp/ro/stuck.tmp; do echo "$f" > "$f"; touch -d "30 days ago" "$f"; done
  for f in tmp/new.tmp tmp/sub/recent~; do echo "$f" > "$f"; touch -d "1 day ago" "$f"; done
  for f in tmp/keep.txt tmp/sub/notes.md "my tmp/data.csv"; do echo "$f" > "$f"; touch -d "60 days ago" "$f"; done
  touch -d "10 days ago" tmp/mid.tmp; echo m > tmp/mid.tmp; touch -d "10 days ago" tmp/mid.tmp
  chmod 555 tmp/ro; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *cleanup.sh* ]]; }
SORT_OUTPUT=1
ARGS=('tmp' '-d 20 tmp' '-n -d 5 tmp' '-d 5 -n tmp' '-d 100 tmp' '-d x tmp' '-d 0 tmp' '-x tmp' '-n -x tmp' '-d x -x tmp' '-d 5 "my tmp"')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; while [[ $1 == -* ]]; do [[ $1 == -d ]] && { echo "$2"; break; }; shift; done)"
  [[ $REF_CODE == 5 ]] && mentions "-x"
}
