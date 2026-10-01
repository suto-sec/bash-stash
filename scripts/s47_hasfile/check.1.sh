# checker spec for s47 step 1 (see lib/engine.sh)
SCRIPT_NAME=hasfile.sh
setup() {
  mkdir -p site/css site/img; echo a > site/index.html; echo b > site/about.html; echo c > "site/two words.txt"; echo d > site/css/main.css
  mkdir empty; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *hasfile.sh* ]]; }
ARGS=('site index.html' 'site index.html missing.txt css "two words.txt"' 'site nothing' 'empty a b')
COMPARE="stdout exit"
