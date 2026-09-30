# checker spec for 0633 (see lib/engine.sh)
SCRIPT_NAME=domains.sh
SEEDS=3
COMPARE="stdout exit errmsg"
mkmail() {
  local i d=("$(word).com" "$(word).org" "mail.$(word).es" example.com)
  for i in $(seq "$1"); do
    case $(rand 5) in
      0) echo "$(words 2) $(pick "joe@localhost" "@example.com" "ann@site.c" "x at example dot com" "user@@bad.com" "a@b") $(word)" ;;
      1) echo "Contact: <$(pick Ana ANA ana Luis)@$(pick Example.COM example.com "${d[0]}")>, $(word)" ;;
      *) echo "$(word) $(pick "$(word)" "$(word).$(word)" "$(word)_$(randr 1 9)" "$(word)+tag")@$(pick "${d[@]}") $(pick '' . , ';' "mailto:$(word)@${d[1]}")" ;;
    esac
  done
}
setup() { mkmail 14 > a.txt; mkmail 8 > "con espacio.txt"; mkmail 6 > b.txt; echo "no addresses here, @ at all" > none.txt; mkmail 3 > locked.txt; chmod 000 locked.txt; mkdir dir; }
ARGS=('a.txt' '"con espacio.txt" b.txt' 'a.txt nofile b.txt' 'none.txt' 'locked.txt none.txt' '' 'dir' 'a.txt b.txt "con espacio.txt" a.txt')
extra_check() {
  [[ $CASE == *nofile* ]] && mentions nofile
  [[ $CASE == *locked* ]] && mentions locked.txt
  true
}
