# checker spec for 1718 (see lib/engine.sh)
SEEDS=1
COMPARE="exit"
extra_check() {
  local f=$W/lab_sudoers
  [[ -f $f ]] || { fail "lab_sudoers not created"; return; }
  sudo visudo -c -f "$f" >/dev/null 2>&1 || { fail "visudo reports a syntax error"; return; }
  local c; c=$(sed 's/#.*//' "$f" | tr -s ' \t' ' ')
  grep -qE '^ ?%devs ALL ?= ?(\(root\) |\(ALL\) )?NOPASSWD: ?/usr/bin/systemctl restart cups ?$' <<< "$c" || fail "rule 1 (devs, systemctl restart cups, NOPASSWD) not found"
  grep -qE '^ ?luke ALL ?= ?(\(root\) |\(ALL\) )?(PASSWD: ?)?/bin/kill ?, ?NOPASSWD: ?/bin/ls ?$' <<< "$c" || fail "rule 2 (luke: kill with password, ls without) not found"
  grep -qE '^ ?jgarcia ALL ?= ?\(ALL(:ALL)?\) ALL ?$' <<< "$c" || fail "rule 3 (jgarcia ALL=(ALL) ALL) not found"
}
