# checker spec for s05 step 2 (see lib/engine.sh)
SCRIPT_NAME=ext.sh
setup() { :; }
ARGS=('a.txt' 'a.txt run.sh photo.png' '"my notes.txt" data photo.jpg' 'x.shx UPPER.TXT archive.tar.gz')
COMPARE="stdout exit"
