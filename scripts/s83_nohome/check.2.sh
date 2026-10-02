# checker spec for s83 step 2 (see lib/engine.sh)
SCRIPT_NAME=nohome.sh
setup() {
  mkdir -p homes/ana homes/luis homes/marta empty
  : > homes/eva
  cat > passwd <<PW
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:$PWD/homes/daemon:/usr/sbin/nologin
ana:x:1000:1000:Ana:$PWD/homes/ana:/bin/bash
luis:x:1001:1001:Luis:$PWD/homes/luis:/bin/bash
diego:x:1002:1002:Diego:$PWD/homes/diego:/bin/bash
eva:x:1003:1003:Eva:$PWD/homes/eva:/bin/bash
marta:x:1004:1004:Marta:$PWD/homes/marta:/bin/zsh
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
carlos:x:1005:1005:Carlos:$PWD/homes/carlos:/bin/bash
PW
  head -n 4 passwd > short.passwd; : > empty.passwd; echo x > notregular.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *nohome.sh* ]]; }
ARGS=('passwd' 'short.passwd' 'empty.passwd' '' 'passwd short.passwd' 'nothing' 'adir' 'notregular.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
