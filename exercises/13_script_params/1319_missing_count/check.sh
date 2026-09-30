# checker spec for 1319 (see lib/engine.sh)
SEEDS=3
SCRIPT_NAME=need.sh
COMPARE="stdout stderr exit"
setup() {
  local n
  for n in alpha.txt "my file" data.csv "notes 2" conf; do
    case $(rand 3) in
      0) echo "$(word)" > "$n" ;;
      1) mkdir "$n" ;;
    esac
  done
}
ARGS=('"my file" alpha.txt' 'alpha.txt data.csv conf "notes 2" "my file" nothing' '' 'x y z' 'conf')
