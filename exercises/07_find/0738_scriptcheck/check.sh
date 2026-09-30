# checker spec for 0738 (see lib/engine.sh)
SCRIPT_NAME=scriptcheck.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "scripts/old stuff" scripts/bin clean
  local i f
  for i in $(seq "$(randr 6 10)"); do
    f="scripts/$(pick . 'old stuff' bin)/$(word)$(pick '' ' ')$i$(pick .sh .sh .sh .bash .txt)"
    case $(rand 5) in
      0) printf '#!/bin/bash\necho %s\n' "$i" ;;
      1) printf 'echo %s\n' "$i" ;;
      2) printf '#!/bin/sh\nls\n' ;;
      3) printf ' #!/bin/bash\necho x\n' ;;
      4) printf '# comment\n#!/bin/bash\necho %s\n' "$i" ;;
    esac > "$f"
    chmod "$(pick 644 755 744 600 700 654 664)" "$f"
  done
  mkdir -p scripts/tools.sh
  printf '#!/bin/bash\necho ok\n' > "clean/good one.sh"; chmod 755 "clean/good one.sh"
  printf '#!/bin/sh\necho ok\n' > clean/b.sh; chmod 700 clean/b.sh
  touch afile
}
ARGS=('scripts' '-f scripts' '"scripts/old stuff"' '-f "$W/scripts"' 'clean' '' '-f' '-x scripts' 'a b' 'noexiste' '-f afile')
