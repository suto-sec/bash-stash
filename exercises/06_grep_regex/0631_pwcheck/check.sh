# checker spec for 0631 (see lib/engine.sh)
SCRIPT_NAME=pwcheck.sh
SEEDS=3
COMPARE="stdout exit errmsg"
mkpw() {
  local i
  for i in $(seq "$1"); do
    case $(rand 10) in
      0) echo "# $(words 2)" ;;
      1) echo ;;
      2) pick "$(word)$i:x:$i:$i:/home/$(word):/bin/sh" "$(word)$i:x:$i:$i::/home/x:/bin/bash:extra" \
              "$(word):x:u$i:100::/:/bin/sh" "$(word)$i:x:1:1:::" "Root$i:x:0:0::/root:/bin/bash" \
              "$i$(word):x:1:1::/:/bin/sh" "$(word) $(word):x:1:1::/:/bin/sh" " #$(word):x:1:1::/:/bin/sh" ;;
      *) echo "$(pick "$(word)" _apt sys-$(word) "$(word)_$(word)")$i:x:$(randr 0 2000):$(randr 0 2000):$(pick "$(word)" '' "$(word) $(word)"):/home/$(word):$(pick /bin/bash /bin/sh /usr/sbin/nologin /bin/false /bin/bash)" ;;
    esac
  done
}
setup() {
  local i
  mkpw 24 > passwd.txt
  mkpw 8 > "my passwd"
  { echo "# only good lines"; for i in $(seq 5); do echo "$(word)$i:x:$i:$i:$(word) $(word):/home/$(word):$(pick /bin/bash /bin/sh)"; done; } > clean.txt
}
ARGS=('passwd.txt' '"my passwd"' 'clean.txt' '/etc/passwd' '' 'a b' 'nofile')
extra_check() {
  if [[ $REF_CODE == [04] && $ERR != "$REF_ERR" ]]; then
    fail "stderr must be exactly the 'line N: ...' messages"
    printf '%s\n' "    expected stderr:" "$REF_ERR" | head -n 6
  fi
  true
}
