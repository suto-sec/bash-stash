# checker spec for s73 step 2 (see lib/engine.sh)
SCRIPT_NAME=shells.sh
setup() {
  mkdir -p empty
  cat > passwd <<'PW'
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
ana:x:1000:1000:Ana,,,:/home/ana:/bin/bash
luis:x:1001:1001:Luis:/home/luis:/bin/zsh
marta:x:1002:1002:Marta:/home/marta:/bin/bash
diego:x:1003:1003:Diego:/home/diego:/bin/dash
eva:x:1004:1004:Eva:/home/eva:/usr/sbin/nologin
PW
  head -n 7 passwd > short.passwd; : > empty.passwd; echo x > notregular.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *shells.sh* ]]; }
ARGS=('passwd' 'short.passwd' 'empty.passwd' '' 'passwd short.passwd' 'nothing' 'adir' 'notregular.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
