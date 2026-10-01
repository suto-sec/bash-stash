# checker spec for s05 step 4 (see lib/engine.sh)
SCRIPT_NAME=ext.sh
setup() { :; }
ARGS=('' 'a.txt' 'a.txt run.sh photo.png' 'UPPER.TXT Photo.PNG x.Sh' '"my notes.txt" data photo.JPG' 'x.shx archive.tar.gz')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { [[ $ERR == *ext.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the message should show the correct usage"; }; }
