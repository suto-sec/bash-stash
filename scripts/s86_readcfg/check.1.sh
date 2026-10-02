# checker spec for s86 step 1 (see lib/engine.sh)
SCRIPT_NAME=readcfg.sh
setup() {
  mkdir -p adir
  cat > app.conf <<'CF'
# application settings
name=demo
port=8080

# the next one is repeated
mode=test
greeting=hello world
url=http://example.com/?a=1&b=2
empty=
 # indented comment
mode=production
CF
  printf 'only=one\n' > one.conf; : > empty.conf; echo x > file.bin
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *readcfg.sh* ]]; }
ARGS=('app.conf name' 'app.conf port' 'app.conf mode' 'app.conf greeting' 'app.conf url' 'app.conf empty' 'one.conf only')
COMPARE="stdout exit"
