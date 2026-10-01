# checker spec for s30 step 3 (see lib/engine.sh)
SCRIPT_NAME=publish.sh
setup() {
  mkdir -p site/conf/extra site/data "my site" empty; local i
  echo a > site/conf/app.conf; echo b > site/conf/extra/db.conf; echo c > site/data/cache.conf; echo d > site/readme.txt
  echo e > site/web.conf; echo f > "my site/two words.conf"; echo g > "my site/notes.txt"; mkdir site/dir.conf
  echo "locked" > site/locked.conf; chmod 000 site/locked.conf
  touch -d "@1700100000" site/web.conf site/conf/app.conf site/conf/extra/db.conf; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *publish.sh* ]]; }
pre_pub() { mkdir -p "$H/publish"; }
pre_newer() { mkdir -p "$H/publish"; echo "published earlier" > "$H/publish/web.conf"; touch -d "@1700900000" "$H/publish/web.conf"; echo "older copy" > "$H/publish/app.conf"; touch -d "@1700000000" "$H/publish/app.conf"; }
SORT_OUTPUT=1
ARGS=('site' 'site $(pre_pub)' '"my site"' 'empty' '' 'nothing' 'notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() { [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"; }
