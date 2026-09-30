# checker spec for 0736 (see lib/engine.sh)
SCRIPT_NAME=cambiaext.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "fotos/my trip" fotos/2024/jan
  local i n
  for i in $(seq "$(randr 8 13)"); do
    n="fotos/$(pick . 'my trip' 2024 2024/jan)/$(pick "$(word)" "$(word) $(word)" beach)"
    echo "$i" > "$n.$(pick jpeg jpeg JPEG jpeg.bak txt)"
    [[ $(rand 4) == 0 ]] && echo old > "$n.jpg"
  done
  echo x > fotos/beach.jpeg; echo y > fotos/beach.jpg
  mkdir -p fotos/album.jpeg
  touch afile
}
ARGS=('fotos jpeg jpg' '"fotos/my trip" jpeg jpg' '"$W/fotos" txt md' 'fotos png gif' 'fotos jpeg' 'nodir jpeg jpg' 'afile jpeg jpg' 'fotos jpg jpg' 'fotos "" jpg')
