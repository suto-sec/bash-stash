# checker spec for s13 step 1 (see lib/engine.sh)
SCRIPT_NAME=lowernames.sh
setup() {
  mkdir -p pics mixed empty
  echo 1 > pics/a.png; echo 2 > pics/b.png
  echo 1 > mixed/Photo.PNG; echo 2 > mixed/NOTES.txt; echo 3 > "mixed/My File.TXT"; echo 4 > mixed/ok.txt
  echo 5 > mixed/Report.doc; echo 6 > mixed/report.doc; mkdir mixed/SubDir
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *lowernames.sh* ]]; }
ARGS=('pics' 'empty' 'mixed/SubDir')
COMPARE="stdout exit files"
