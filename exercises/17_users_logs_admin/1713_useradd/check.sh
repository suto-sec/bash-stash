# checker spec for 1713 (see lib/engine.sh)
SEEDS=1
RUN_AS_ROOT=1
setup() { sudo userdel -r pepe >/dev/null 2>&1; true; }
extra_check() { sudo grep -q '^pepe:\$' /etc/shadow || fail "pepe has no password set"; [[ -d /home/pepe ]] || fail "/home/pepe was not created"; }
