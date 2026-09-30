# checker spec for 0923 (see lib/engine.sh)
SCRIPT_NAME=runall.sh
SEEDS=3
COMPARE="stdout exit files errmsg"
mkjob() { printf '#!/bin/bash\n%s\n' "$2" > "$1"; chmod "${3:-755}" "$1"; }
setup() {
  mkdir -p jobs/sub.sh jobs/logs
  mkjob jobs/a.sh "echo a $(word); echo a2 $(word)"
  mkjob "jobs/my job.sh" "echo $(word); echo oops $(word) >&2; exit $(pick 0 1 3)"
  mkjob jobs/reader.sh 'read -r x; echo "input: [$x]"; read -r y && echo "more: [$y]"; exit 0'
  mkjob jobs/fail.sh "echo $(word) >&2; echo $(word) >&2; exit $(pick 2 0)"
  mkjob jobs/off.sh "echo never" 644
  mkjob jobs/notes.txt "echo never"
  [[ $(rand 2) == 1 ]] && mkjob jobs/zz.sh "true"
  echo "old" > jobs/logs/a.out
  echo "old" > jobs/logs/fail.err
  touch file.txt
}
input() { printf 'secret %s\nsecond line\n' "$(word)"; }
ARGS=('jobs' '"$W/jobs" "my logs"' 'jobs out/logs' 'jobs file.txt' 'nodir' '' 'a b c')
