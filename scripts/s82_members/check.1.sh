# checker spec for s82 step 1 (see lib/engine.sh)
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
ARGS=('sudo group' 'students group' 'solo group' 'www-data group' 'adm short.group' 'sudoers group')
COMPARE="stdout exit"
