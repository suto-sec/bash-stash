# checker spec for 0821 (see lib/engine.sh)
SCRIPT_NAME=fixperms.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "web/css" "web/img/icons" "web/mis docs" fotos
  local i f
  for i in $(seq 1 9); do
    f="web/$(pick . css img img/icons "mis docs")/$(pick "$(word)$i.html" "$(word) $i.txt" "$(word)$i.sh")"
    touch "$f"; chmod "$(pick 644 600 755 666 640 700 777)" "$f"
  done
  chmod "$(pick 755 700 775)" web/css "web/mis docs"; chmod "$(pick 755 777)" web/img
  ln -s ../index.html web/css/link
  touch fotos/a.jpg; chmod 644 fotos/a.jpg; chmod 755 fotos
  touch fich
}
ARGS=('web 644 755' '"$W/web" 600 700' '"web/mis docs" 640 750' 'fotos 644 755' 'web 644' '' 'noexiste 644 755' 'fich 644 755' 'web 64 755' 'web 644 855' 'web rw- 755' 'web 644 655')
extra_check() {
  [[ $REF_CODE == 3 ]] && { local a; eval "set -- $CASE"; [[ $2 =~ ^[0-7]{3}$ ]] && a=$3 || a=$2; mentions "$a"; }
  true
}
