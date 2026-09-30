# checker spec for 0623 (see lib/engine.sh)
setup() {
  local i
  for i in $(seq 14); do
    case $(rand 6) in
      0) echo "<p>see <a href=\"ftp://files.$(word).org/x\">ftp</a> and mailto:$(word)@$(word).com</p>" ;;
      1) echo "<a href=\"$(pick http https)://$(word).$(pick com es)/\">a</a> <a href=\"http://$(word).net:8080/x\">b</a>" ;;
      *) echo "<li><a href=\"$(pick http https http)://$(pick www. '' api. '')$(word)$(pick '' -$(word)).$(pick com org es)/$(word)\">$(word)</a></li>" ;;
    esac
  done > pagina.html
}
