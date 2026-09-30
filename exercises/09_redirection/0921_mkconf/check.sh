# checker spec for 0921 (see lib/engine.sh)
SCRIPT_NAME=mkconf.sh
SEEDS=4
COMPARE="stdout exit files errmsg"
setup() {
  local i C=$H/.config/apps
  if [[ $(rand 3) != 0 ]]; then
    mkdir -p "$C"
    echo "# old web" > "$C/web.conf"
    for i in $(seq "$(rand 3)"); do echo "# old" > "$C/$(word)$i.conf"; done
    echo "notes" > "$C/notes.txt"
  fi
  true
}
ARGS=('web 8080' '-f web 8080' 'db 5432' '-f new_app-2 1' 'x 65535' 'Web 80' '"my app" 80' '2db 80' 'web 0' 'web 65536' 'web 080' 'web 80x'
      'web' '-f web' 'a b c' '-x web 80' 'web 80 -f' '')
