# checker spec for s87 step 1 (see lib/engine.sh)
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
ARGS=('photos img' '"my photos" pic' 'empty x' 'photos "my pic"')
COMPARE="stdout exit files"
