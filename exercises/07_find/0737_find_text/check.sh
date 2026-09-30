# checker spec for 0737 (see lib/engine.sh)
SCRIPT_NAME=buscatexto.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p logs/app "logs/web app/old"
  local i j f
  for i in $(seq "$(randr 6 10)"); do
    f="logs/$(pick . app 'web app' 'web app/old')/$(word)$(pick '' ' ')$i.$(pick log log txt conf)"
    for j in $(seq "$(randr 2 8)"); do
      echo "$(word) $(pick error Error ERROR: errors error_code timeout Timeout timeouts ok ok ok) $(word)"
    done > "$f"
  done
  echo "error error" > logs/app/secret.log; chmod 000 logs/app/secret.log
  touch afile
}
ARGS=('error logs' 'Error logs log' 'timeout "logs/web app"' 'error "$W/logs" txt' 'zzz logs' 'error' 'a b c d' '"" logs' 'error noexiste' 'error afile')
