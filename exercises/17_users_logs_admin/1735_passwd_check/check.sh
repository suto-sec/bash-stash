# checker spec for 1735 (see lib/engine.sh)
SCRIPT_NAME=pwcheck.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i u us=() uids=()
  for i in 1 2 3 4 5 6; do us+=("$(word)$i"); uids+=("$((1000 + i))"); done
  for i in 1 2 3 4; do echo "$(word)$i:x:$((200 + i)):"; done > "my group"
  {
    for i in 0 1 2 3 4 5; do
      echo "${us[i]}:x:${uids[i]}:$(pick 201 202 203 204):${us[i]^}:/home/${us[i]}:/bin/bash"
      case $(rand 6) in
        0) echo "${us[i]}:x:$((1500 + i)):201::/home/x:/bin/sh" ;;
        1) echo "dup$i:x:${uids[$(rand 6)]}:$(pick 201 209):::/bin/sh" ;;
        2) echo "short$i:x:$((1600 + i)):201:/home/s:/bin/sh" ;;
        3) echo "long$i:x:$((1700 + i)):201::/home/l:/bin/sh:extra" ;;
        4) echo "${us[$(rand 6)]}:x:${uids[$(rand 6)]}:999::/home/x:/bin/sh" ;;
      esac
    done
  } > "my passwd"
  echo "solo:x:1000:201::/home/solo:/bin/sh" > good
}
ARGS=('"my passwd" "my group"' '"$W/my passwd" "$W/my group"' 'good "my group"' '' 'good' 'noexiste' 'good noexiste' 'a b c')
extra_check() { [[ $REF_CODE == 3 ]] && mentions noexiste; true; }
