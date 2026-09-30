# checker spec for 0924 (see lib/engine.sh)
SCRIPT_NAME=newuser.sh
SEEDS=8
COMPARE="stdout exit files"
setup() { echo "login=old" > exists.txt; }
input() {
  local s login
  s=$(rand 7)   # scenario first: seeds 1-8 cover all of them
  login=$(pick ana luis marta pepe)$(rand 100)
  case $s in
    0|1) printf '%s\n' "$login" "$(pick 'Ana Garcia' 'Luis Perez Gil' "$(word)")" "$(pick /bin/bash /bin/sh /usr/bin/dash)" ;;
    2) printf '%s\n' "$(pick Ana 9lives toolonglogin a ana_1)" "Some Name" /bin/bash ;;
    3) printf '%s\n' "$login" "Some Name" "$(pick /bin/zsh bash /bin/bash/ '/bin/bash ')" ;;
    4) printf '%s\n' "$login" "Some Name" ;;
    5) printf '%s\n' "$login" "" /bin/bash ;;
    *) printf '%s\n' "$login" ;;
  esac
}
ARGS=('user.txt' '"new user.txt"' 'exists.txt' '' 'a b')
extra_check() {
  if [[ $REF_CODE == 0 ]]; then
    [[ $ERR == "$REF_ERR" ]] || fail "stderr must be exactly the three prompts: '$REF_ERR'"
  else
    [[ -n $ERR ]] || fail "expected an error message on stderr"
  fi
  true
}
