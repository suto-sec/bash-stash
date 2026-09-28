# checker spec for 1714 (see lib/engine.sh)
SEEDS=1
RUN_AS_ROOT=1
setup() { sudo groupdel auditores >/dev/null 2>&1; true; }
filter() { grep -v '^Removing user'; }
