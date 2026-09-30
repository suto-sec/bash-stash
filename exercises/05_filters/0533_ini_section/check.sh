# checker spec for 0533 (see lib/engine.sh)
ARGS=('config.ini db' 'config.ini server' 'config.ini empty' 'config.ini nosuch' 'config.ini db_old' '"my conf.ini" app' 'config.ini logging')
sec() {
  local i n; echo "[$1]"; n=$(randr 1 4)
  for ((i = 1; i <= n; i++)); do
    case $(rand 5) in 0) echo "# $(words 2)" ;; 1) echo "; $(word)" ;; 2) echo ;; 3) echo "   " ;; esac
    echo "$(word)_$i=$(word)"
  done
}
setup() {
  local s
  { echo "global=$(word)"
    for s in $(pick "server db empty db_old logging" "db_old logging db server empty" "empty db server logging db_old"); do
      if [[ $s == empty ]]; then echo "[empty]"
      elif [[ $s == db_old ]]; then sec db_old; echo "note=copy of [db]"
      else sec "$s"; fi
    done
  } > config.ini
  { sec server; sec app; sec x; } > "my conf.ini"
}
