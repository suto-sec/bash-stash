# checker spec for s05 step 1 (see lib/engine.sh)
SCRIPT_NAME=ext.sh
setup() { :; }
ARGS=('a.txt' 'run.sh' 'photo.png' 'photo.jpg' 'data' 'archive.tar.gz' '"my notes.txt"' 'txt' 'x.shx' 'UPPER.TXT')
COMPARE="stdout exit"
