# checker spec for s05 step 3 (see lib/engine.sh)
SCRIPT_NAME=ext.sh
setup() { :; }
ARGS=('a.txt' 'a.txt run.sh photo.png' '"my notes.txt" data photo.jpg' 'x.shx UPPER.TXT archive.tar.gz' 'a.txt b.txt c.txt d.sh')
COMPARE="stdout exit"
