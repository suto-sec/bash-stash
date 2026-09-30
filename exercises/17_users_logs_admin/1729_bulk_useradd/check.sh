# checker spec for 1729 (see lib/engine.sh)
SCRIPT_NAME=altas.sh
SEEDS=2
RUN_AS_ROOT=1
COMPARE="stdout exit errmsg"
labclean() {
  local x
  for x in $(cut -d: -f1 /etc/passwd | grep '^lab_'); do sudo userdel -r "$x" >/dev/null 2>&1; done
  for x in $(cut -d: -f1 /etc/group | grep -E '^lab(g)?_'); do sudo groupdel "$x" >/dev/null 2>&1; done
  true
}
setup() {
  labclean
  local i u g1=labg_$(word) g2=labg_$(word)x first=
  {
    echo "# login:Full Name:groups"
    for i in 1 2 3 4 5; do
      u=lab_$(word)$i; first=${first:-$u}
      echo "$u:$(word) $(word)$i:$(pick "devs,$g1" "" "$g1" "$g2,audio" "$g1,$g2" video)"
      [[ $(rand 3) == 0 ]] && echo ""
    done
    [[ $(rand 2) == 1 ]] && echo "luke:Luke Again:devs"
    [[ $(rand 2) == 1 ]] && echo "$first:Duplicated:$g2"
  } > "new users.txt"
  printf 'lab_%s1:Only One:\n' "$(word)" > one.txt
}
capture() {
  local u
  for u in $(cut -d: -f1 /etc/passwd | grep '^lab_' | sort); do
    getent passwd "$u" | cut -d: -f1,5,6,7
    echo "groups: $(id -Gn "$u" | tr ' ' '\n' | sort | tr '\n' ' ')"
    [ -d "/home/$u" ] && echo "home exists"
  done
  cut -d: -f1 /etc/group | grep '^labg_' | sort
}
ARGS=('"new users.txt"' '"$W/one.txt"' 'noexiste.txt' '' 'a b')
extra_check() { labclean; }
