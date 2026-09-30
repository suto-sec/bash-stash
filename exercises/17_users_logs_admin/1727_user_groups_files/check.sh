# checker spec for 1727 (see lib/engine.sh)
SCRIPT_NAME=usergroups.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i u us=() m
  for i in 1 2 3 4; do us+=("$(word)$i"); done
  for i in 0 1 2 3; do echo "${us[i]}:x:$((2000 + i)):$(pick 3000 3001 3002 3009):${us[i]^}:/home/${us[i]}:/bin/bash"; done > pw
  echo "${us[0]}x:x:2009:3000::/home/x:/bin/sh" >> pw
  for i in 0 1 2 3 4 5; do
    m=$(pick "${us[0]}" "${us[1]},${us[0]}x" "${us[0]}x,${us[2]}" "${us[2]},${us[0]},${us[3]}" "" "${us[1]}")
    echo "$(word)g$i:x:$((3000 + i)):$m"
  done > "my group"
  printf '%s\n' "${us[0]}" > user.txt
}
ARGS=('"$(cat user.txt)" pw "my group"' '"$(cat user.txt)x" pw "my group"' 'jgarcia' 'alumno' 'rosa /etc/passwd /etc/group' 'nadie' 'nadie pw "my group"' 'luke noexiste' '' 'a b c d')
extra_check() { [[ $REF_CODE == 1 ]] && mentions nadie; true; }
