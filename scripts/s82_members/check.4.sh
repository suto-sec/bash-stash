# checker spec for s82 step 4 (see lib/engine.sh)
SCRIPT_NAME=members.sh
setup() {
  mkdir -p adir
  cat > group <<'GR'
root:x:0:
daemon:x:1:
sudo:x:27:ana,luis
adm:x:4:syslog,ana
www-data:x:33:
students:x:2000:ana,marta,diego,eva
staff:x:50:luis
solo:x:2001:eva
sudoers:x:2002:root
GR
  head -n 4 group > short.group; : > empty.group; echo x > file.bin
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *members.sh* ]]; }
ARGS=('sudo group' '-u ana sudo group' '-u luis sudo group' '-u diego sudo group' '-u eva solo group' '-u ana www-data group' '-u ana students group' '-u an students group' '-u root sudoers group' '-u' '-u ana' '-u ana sudo' '-u ana sudo nothing' '-u ana sudo adir' '-u ana sud group' '' '-u ana sudo group extra')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == [234] ]]; then
    local a; a=$(eval "set -- $CASE"; [[ $1 == -u ]] && shift 2; echo "$1|$2")
    [[ $REF_CODE == 4 ]] && mentions "${a%|*}" || mentions "${a#*|}"
  fi
}
