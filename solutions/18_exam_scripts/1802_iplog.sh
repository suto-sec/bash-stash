#!/bin/bash
# ipLog.sh [<path>] [<ip>] - look for an IP in log files
AUTH=/var/log/auth.log

valid_ip() {
  [[ $1 =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]] || return 1
  local i
  for i in 1 2 3 4; do (( 10#${BASH_REMATCH[i]} <= 255 )) || return 1; done
}
log_files() { find "$1" -type f -name '*.log' | sort; }
usage() { echo "Usage: $(basename "$0") [<path>] [<ip>]" >&2; }

echo "User: $(whoami)"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Bash: $BASH_VERSION"

case $# in
  0)
    tail -n 100 "$AUTH" || exit 4
    ;;
  1)
    if valid_ip "$1"; then
      echo "IP $1 appears in $(grep -cwF "$1" "$AUTH") lines of $AUTH"
    elif [ -d "$1" ]; then
      IP=$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$AUTH" | tail -n 1)
      echo "Last IP in $AUTH: $IP"
      FOUND=0
      while IFS= read -r f; do
        if grep -qwF "$IP" "$f"; then echo "$f"; FOUND=1; fi
      done < <(log_files "$1")
      [ $FOUND -eq 0 ] && echo "No log file in $1 contains $IP"
    else
      echo "Error: '$1' is neither a valid IP nor a directory" >&2
      exit 2
    fi
    ;;
  2)
    [ -d "$1" ] || { echo "Error: '$1' is not a directory" >&2; exit 2; }
    valid_ip "$2" || { echo "Error: '$2' is not a valid IP" >&2; exit 3; }
    N=0
    while IFS= read -r f; do
      while IFS= read -r line; do
        echo "$f:$line"
        N=$((N + 1))
      done < <(grep -wF "$2" "$f")
    done < <(log_files "$1")
    echo "Total: $N lines"
    ;;
  *)
    echo "Error: too many arguments" >&2
    usage
    exit 1
    ;;
esac
# without this, a final "[ ... ] && echo" that is false would make the script exit with 1
exit 0

