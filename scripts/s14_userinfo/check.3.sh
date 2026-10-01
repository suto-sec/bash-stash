# checker spec for s14 step 3 (see lib/engine.sh)
SCRIPT_NAME=userinfo.sh
setup() {
  mkfl users.txt "root:x:0:0:root:/root:/bin/bash" "ana:x:1001:100:Ana Ruiz:/home/ana:/bin/zsh" "luis:x:1002:100:Luis,,,:/home/luis:/bin/bash" "anaelle:x:1003:100::/home/anaelle:/bin/sh" "daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin"
  : > emptyfile.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *userinfo.sh* ]]; }
ARGS=('users.txt ana' 'users.txt root' '' 'users.txt' 'users.txt ana x' 'nothing.txt ana' 'adir ana')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
