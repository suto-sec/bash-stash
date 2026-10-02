# checker spec for s87 step 4 (see lib/engine.sh)
SCRIPT_NAME=seqname.sh
setup() {
  mkdir -p photos "my photos" empty busy
  echo 1 > photos/holiday.jpg; echo 2 > photos/beach.jpg; echo 3 > photos/notes.txt; echo 4 > photos/Zebra.png; echo 5 > photos/README
  echo 6 > "photos/two words.jpg"; mkdir photos/albums; echo 7 > photos/.hidden.jpg
  echo a > "my photos/x.png"; echo b > "my photos/y.png"
  echo 1 > busy/a.txt; echo 2 > busy/b.txt; echo 3 > busy/img-002.txt
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *seqname.sh* ]]; }
ARGS=('photos img' 'photos img 10' '"my photos" pic' 'busy img' 'busy img 1' 'busy img 3' 'busy x 2' 'busy x 5' 'empty x' '' 'photos img abc' 'photos "" 1' 'nothing img')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 4 ]] && mentions "prefix"
  [[ $REF_CODE == 5 ]] && mentions "$(eval "set -- $CASE"; echo "$3")"
  [[ $REF_CODE == 6 ]] && mentions "exists: "
}
