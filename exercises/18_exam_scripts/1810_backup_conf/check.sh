# checker spec for 1810 (see lib/engine.sh)
SCRIPT_NAME=backup_conf.sh
COMPARE="stdout exit errmsg files"
setup() { mkdir -p etc/{nginx,ssh,app/sub} vacio out; local i; for i in $(seq 7); do randtext 2 > "etc/$(pick . nginx ssh app/sub)/$(word)$i.$(pick conf conf txt conf.bak)"; done; mkdir etc/dir.conf; touch vacio/readme; }
ARGS=('etc' 'etc out' 'etc/app "$W/nuevo"' 'vacio' 'noexiste' '' 'a b c')
