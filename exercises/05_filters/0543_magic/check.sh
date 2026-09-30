# checker spec for 0543 (see lib/engine.sh)
SCRIPT_NAME=magic.sh
SEEDS=3
COMPARE="stdout exit errmsg"
ARGS=('*' '' '"run me.sh" missing photo.png' 'folder' 'short' 'photo.png "run me.sh"')
content() {
  case $1 in
    png)    printf '\211PNG\r\n\032\n%s' "$(word)" ;;
    gzip)   words 3 | gzip -c ;;
    elf)    head -c 64 /bin/true ;;
    pdf)    printf '%%PDF-1.%d\n%s\n' "$(rand 8)" "$(words 2)" ;;
    zip)    printf 'PK\003\004%s' "$(word)" ;;
    script) printf '#!/bin/bash\necho %s\n' "$(word)" ;;
    text)   randtext 2 ;;
    empty)  : ;;
  esac
}
setup() {
  local i n name
  n=$(randr 5 9)
  for ((i = 1; i <= n; i++)); do
    name="$(word)$i$(pick .png .gz .pdf '' .sh .zip .bin)"
    [[ $(rand 3) == 0 ]] && name="my $name"
    content "$(pick png gzip elf pdf zip script text empty)" > "$name"
  done
  content "$(pick text pdf gzip)" > photo.png
  content script > "run me.sh"
  printf '#x\n' > hash.txt
  printf 'PK\003' > short
  mkdir folder
  content png > "locked$(rand 9)"; chmod 000 locked*
}
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *magic.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) [[ $CASE == *missing* ]] && mentions missing
       [[ $CASE == folder ]] && mentions folder ;;
  esac
  must_use od
}
