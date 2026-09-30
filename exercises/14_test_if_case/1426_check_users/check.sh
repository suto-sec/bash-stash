# checker spec for 1426 (see lib/engine.sh)
SCRIPT_NAME=check_users.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i n u s h
  {
    echo "# user list"
    for ((i = 0; i < $(randr 6 10); i++)); do
      n=$(word)$(rand 99) u=$(randr 1000 60000) s=$(pick /bin/bash /bin/sh /usr/bin/zsh /usr/sbin/nologin) h=/home/$n
      case $(rand 8) in
        1) echo "$n:$u:$s:$h:extra" ; continue ;;
        2) n=$(pick Pepe 9abc "a b" averyveryverylongname1 "" "x.y") ;;
        3) u=$(pick 999 60001 abc 0100 "" 1e3) ;;
        4) s=$(pick /bin/csh bash /bin/bash2 "") ;;
        5) h=$(pick "/home/other" "/home/$n/" "/root") ;;
        6) echo; continue ;;
        7) echo "#$n:$u:$s:$h"; continue ;;
      esac
      echo "$n:$u:$s:$h"
    done
    echo "_svc-1:60000:/usr/sbin/nologin:/home/_svc-1"
  } > "users list.txt"
  printf '%s\n' "# nothing" "" "#x:1000:/bin/sh:/home/x" > comments.txt
  printf '%s\n' "ana:1000:/bin/bash:/home/ana" "luis:2000:/bin/sh:/home/luis" > good.txt
  echo "a:1:b:c" > locked.txt; chmod 000 locked.txt
  mkdir sub
}
ARGS=('"users list.txt"' 'good.txt' 'comments.txt' '' '"users list.txt" good.txt' 'nofile' 'locked.txt' 'sub' '"$W/users list.txt"')
extra_check() {
  local tok
  if [[ $REF_CODE == 3 ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
