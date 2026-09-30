# checker spec for 0826 (see lib/engine.sh)
SCRIPT_NAME=sshcheck.sh
SEEDS=4
COMPARE="stdout exit errmsg files"
setup() {
  chmod "$(pick 755 775 757 750 700)" "$H"
  (( SEED / 7919 == 4 )) && { mkdir "$H/ssh_old"; return 0; }
  mkdir "$H/.ssh"; chmod "$(pick 700 755 750 711 700)" "$H/.ssh"
  local k
  for k in id_rsa id_ed25519 "id_ecdsa $(word)"; do
    (( $(rand 4) == 0 )) && continue
    randtext 1 > "$H/.ssh/$k"; chmod "$(pick 600 400 644 640 604 600)" "$H/.ssh/$k"
    randtext 1 > "$H/.ssh/$k.pub"; chmod "$(pick 644 664 666 600 646 644)" "$H/.ssh/$k.pub"
  done
  (( $(rand 3) )) && { randtext 1 > "$H/.ssh/authorized_keys"; chmod "$(pick 600 644 640 600)" "$H/.ssh/authorized_keys"; }
  randtext 1 > "$H/.ssh/known_hosts"; chmod 666 "$H/.ssh/known_hosts"
  mkdir "$H/.ssh/id_old"; chmod 777 "$H/.ssh/id_old"
  touch "$H/.ssh/config"; chmod 644 "$H/.ssh/config"
}
ARGS=('' '-f' '-x' '-f -f' 'extra')
capture() { stat -c 'home %a' "$H"; }
