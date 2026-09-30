# checker spec for 0121 (see lib/engine.sh)
SCRIPT_NAME=genconf.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  echo "$(word)$(pick _ - '')$(randr 1 9)" > name.txt
  randr 1024 64535 > port.txt
  mkdir -p "mis confs" "$H/conf"
  echo "old = 1" > "$H/conf/$(cat name.txt).conf"
  [[ $(rand 2) == 1 ]] && rm -r "$H/conf"
  true
}
ARGS=('"$(cat name.txt)" "$(cat port.txt)" "mis confs"' 'web1 1024 "nuevo dir/sub"' '"$(cat name.txt)"x "$(cat port.txt)"' 'db-2 64535 "$W/mis confs"' '"$(cat name.txt)" "$(cat port.txt)"' 'Web 8080 x' '"my app" 8080 x' '"" 8080 x' 'web 1023 x' 'web 64536 x' 'web 80a x' 'web' 'a 2000 b c')
