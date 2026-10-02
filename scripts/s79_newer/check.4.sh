# checker spec for s79 step 4 (see lib/engine.sh)
SCRIPT_NAME=newer.sh
setup() {
  mkdir -p proj/src/deep "my proj" empty other
  echo r > ref.stamp; touch -d "@1700000000" ref.stamp
  echo 1 > proj/old.txt;        touch -d "@1699999000" proj/old.txt
  echo 2 > proj/new.txt;        touch -d "@1700001000" proj/new.txt
  echo 3 > proj/src/main.c;     touch -d "@1700002000" proj/src/main.c
  echo 4 > proj/src/old.c;      touch -d "@1600000000" proj/src/old.c
  echo 5 > proj/src/deep/x.h;   touch -d "@1700003000" proj/src/deep/x.h
  echo 6 > "proj/two words.txt"; touch -d "@1700004000" "proj/two words.txt"
  echo 7 > proj/same.txt;       touch -d "@1700000000" proj/same.txt
  echo 8 > "my proj/a.md";      touch -d "@1700005000" "my proj/a.md"
  echo 9 > "my proj/b.md";      touch -d "@1500000000" "my proj/b.md"
  echo 10 > other/new.txt;      touch -d "@1700006000" other/new.txt
  touch -d "@1700001000" proj/src/deep
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *newer.sh* ]]; }
SORT_OUTPUT=1
ARGS=('ref.stamp proj' '-c ref.stamp proj' '-c ref.stamp "my proj"' '-c ref.stamp empty' '-c proj/new.txt other' '-c ref.stamp proj/src' '-c' '-c nothing proj' '-c proj ref.stamp' '-c ref.stamp proj other')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [23] ]]; then
    local bad; bad=$(cd "$W"; eval "set -- $CASE"; [[ $1 == -c ]] && shift; d=${2:-.}
      if [[ $REF_CODE == 2 ]]; then [[ -e $1 ]] && echo "$d" || echo "$1"; else [[ -f $1 ]] && echo "$d" || echo "$1"; fi)
    mentions "$bad"
  fi
}
