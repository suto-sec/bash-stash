# checker spec for 1722 (see lib/engine.sh)
SCRIPT_NAME=nextuid.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local u
  for u in $(seq 995 1012) 1500 1501 1503 65534; do
    [[ $(rand 3) != 0 ]] && echo "$(word)$u:x:$u:100::/home/x:/bin/sh"
  done > pw
  [[ $(rand 2) == 1 ]] && { tac pw > pw2; mv pw2 pw; }
  echo "extra:x:1000:100::/home/e:/bin/sh" >> pw
}
ARGS=('' 'pw' 'pw 1005' 'pw 1500' 'pw 0' '/etc/passwd 1003' 'noexiste' 'pw abc' 'pw -3' 'a b c')
