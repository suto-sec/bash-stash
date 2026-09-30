# checker spec for 0624 (see lib/engine.sh)
setup() {
  local i
  for i in $(seq 20); do
    case $(rand 9) in
      0) echo "# $(words 3)" ;;
      1) echo "    # indented $(word)" ;;
      2) printf '\t# tab %s\n' "$(word)" ;;
      3) echo ;;
      4) printf '%s\n' "$(pick '   ' $'\t' $' \t ')" ;;
      5) echo "$(word)$i=$(pick '' '   ' $'\t')" ;;
      6) echo "color$i=#$(word)" ;;
      *) echo "$(word)$i=$(pick "$(word)" "/srv/$(word) # not a comment" "$(randr 1 999)")" ;;
    esac
  done > app.conf
}
