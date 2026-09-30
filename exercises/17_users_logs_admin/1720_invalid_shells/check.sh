# checker spec for 1720 (see lib/engine.sh)
SCRIPT_NAME=badshell.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i
  printf '%s\n' '# valid login shells' /bin/sh /bin/bash /usr/bin/bash /usr/bin/zsh '#/bin/tcsh' > shells
  for i in $(seq "$(randr 6 12)"); do
    echo "$(word)$i:x:$(randr 0 3000):100:$(word):/home/u$i:$(pick /bin/bash /bin/sh /bin/zsh /usr/bin/zsh /bin/tcsh /bin/bash5 /usr/sbin/nologin /bin/false /usr/bin/false /bin/sync /usr/bin/fish '#/bin/tcsh')"
  done > "mi passwd"
}
ARGS=('' '"mi passwd" shells' '"$W/mi passwd" /etc/shells' '/etc/passwd shells' 'noexiste' '"mi passwd" noexiste' 'a b c')
extra_check() { [[ $REF_CODE == 1 ]] && mentions noexiste; true; }
