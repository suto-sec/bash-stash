# checker spec for 1812 (see lib/engine.sh)
SCRIPT_NAME=ordena.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p m/existing; local i; for i in $(seq 10); do touch "m/$(word)$i$(pick .txt .TXT .jpg .JPG .tar.gz '' .c)"; done; touch m/.hidden m/existing/keep.txt; }
ARGS=('m' 'noexiste')
