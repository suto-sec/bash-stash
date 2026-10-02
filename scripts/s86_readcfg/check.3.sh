# checker spec for s86 step 3 (see lib/engine.sh)
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
ARGS=('app.conf name' 'app.conf nokey fallback' 'app.conf nokey ""' 'app.conf name fallback' 'app.conf nokey "two words"' 'app.conf empty fallback' 'app.conf nokey' '' 'app.conf a b c' 'nothing name x' 'adir name x' 'empty.conf name dflt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
