# checker spec for 0325 (see lib/engine.sh)
SCRIPT_NAME=relink.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "enl/sub dir/deep" enl/x
  local i d t
  for i in $(seq 1 9); do
    d=$(pick enl "enl/sub dir" "enl/sub dir/deep" enl/x)
    t=$(pick "/srv/datos/$(word)$i.txt" "/srv/datos/$(word)/$(word)$i" /srv/datos "/srv/datos2/$(word)$i" \
             "/srv/datos_old/$(word)" "../datos/$(word)$i" "/opt/srv/datos/$(word)" "../datos" "$(word)$i")
    ln -s "$t" "$d/$(pick "l$i" "link $i" "$(word)$i")"
  done
  ln -s /srv/datos/dir "enl/first"
  ln -s ../datos/q "enl/second one"
  mkdir -p "$W/datos" "$W/nuevo/sub"; ln -s ../../datos "enl/x/todir"
  randtext 1 > "enl/$(word).txt"
  touch fich
}
ARGS=('enl /srv/datos /mnt/datos' '"$W/enl" ../datos ../nuevo' '"enl/sub dir" /srv/datos /srv/nuevo' 'enl ../../datos ../../nuevo/sub' 'enl /srv/datos' '' 'fich /a /b' 'noexiste /a /b' 'enl "" /b' 'enl /a ""')
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  true
}
