# checker spec for 1820 (see lib/engine.sh)
SCRIPT_NAME=deploy2.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p src/sub; local i f; for i in $(seq 8); do f="src/$(pick . sub)/$(word)$i$(pick .sh .bin .txt)"; echo "echo $i" > "$f"; chmod "$(pick 755 644 700)" "$f"; done; touch notadir; }
ARGS=('src' '-n src' '-m src' '-n -m src' '-m -n' '-x src' 'src src' 'noexiste' '-n notadir' '-m')
