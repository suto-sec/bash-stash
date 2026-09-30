#!/bin/bash
# Checker engine. An exercise directory contains:
#   README.md   statement
#   answer.sh   the student's answer (answer.txt for quizzes)
#   check.sh    spec, sourced here. It may define:
#     TYPE=script|quiz        (default script)
#     SCRIPT_NAME=name.sh     name the answer is installed/run as (default: script.sh)
#     ARGS=( 'case' ... )     one string per test case, eval'd as the argument list.
#                             $W (work dir) and $H (home dir) may be used inside.
#     COMPARE="stdout exit"   any of: stdout stderr errmsg exit files owner mtime
#     SORT_OUTPUT=1           compare stdout ignoring line order
#     SEEDS=3                 how many random fixtures to try
#     TIMEOUT=10              seconds per run
#     RUN_AS_ROOT=1           run the answer with sudo
#     ENV=( VAR=val ... )     extra environment for the run
#     setup()                 builds the fixture; cwd=$W, HOME=$H. Use rand/randr/pick/word
#                             (never $RANDOM: it is reseeded in subshells)
#     input()                 prints what the script receives on stdin
#     filter()                normalises stdout (stdin->stdout) before comparing
#     capture()               prints normalised state after each run (cwd=$W); compared
#                             between yours and the reference (label "state")
#     extra_check()           custom assertions; call fail "msg". Available:
#                             OUT ERR CODE (yours), REF_OUT REF_ERR REF_CODE, CASE, W, H
# The reference solution lives in solutions/<topic>/<id>_<slug>.sh (.txt for quizzes).
# Your answer and the reference run on identical fixtures at the same path, and their
# observable behaviour is compared.

LAB=${LAB:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}
SBROOT=${SBROOT:-/tmp/lab-$(id -u)}
SB=$SBROOT/sb
RES=$SBROOT/res
PROGRESS=$LAB/.progress

if [[ -t 1 || -n ${LAB_COLOR:-} ]]; then R=$'\e[31m' G=$'\e[32m' Y=$'\e[33m' B=$'\e[1m' D=$'\e[2m' N=$'\e[0m'; else R= G= Y= B= D= N=; fi

die() { echo "${R}$*${N}" >&2; exit 2; }

# one checker at a time: the sandbox path is shared (web UI + terminals)
lab_lock() { mkdir -p "$SBROOT"; exec 9>"$SBROOT.lock"; flock 9; }

# ---------------------------------------------------------------- lookup
ex_dir() { # id or id prefix -> exercise dir
  local id=$1 m
  m=( "$LAB"/exercises/*/"$id"_* )
  [[ -d ${m[0]} ]] || die "No exercise with id '$id'"
  (( ${#m[@]} == 1 )) || die "Ambiguous id '$id'"
  echo "${m[0]}"
}
ex_id()   { local b; b=$(basename "$1"); echo "${b%%_*}"; }
ex_sol()  { local d=$1 t; t=$(basename "$(dirname "$d")"); echo "$LAB/solutions/$t/$(basename "$d")"; }
all_ex()  { printf '%s\n' "$LAB"/exercises/*/[0-9]*_* ; }

attempted() { # file -> true if it has something besides comments/blank lines
  [[ -f $1 ]] && grep -qvE '^[[:space:]]*(#.*)?$' "$1"
}

# ---------------------------------------------------------------- fixture helpers (usable in setup)
# Deterministic PRNG whose state lives in a file, so it also advances inside $(...) subshells
# (bash reseeds $RANDOM in every subshell, which would make fixtures irreproducible).
RNGF=${RNGF:-$SBROOT/rng}
rng_seed() { mkdir -p "$(dirname "$RNGF")"; echo $(( $1 % 2147483648 )) > "$RNGF"; }
rand()  { local s; s=$(<"$RNGF"); s=$(( (s * 1103515245 + 12345) % 2147483648 )); echo "$s" > "$RNGF"; echo $(( (s >> 8) % $1 )); } # 0..n-1
randr() { echo $(( $1 + $(rand $(( $2 - $1 + 1 ))) )); }  # a..b
pick()  { local a=("$@"); echo "${a[$(rand ${#a[@]})]}"; }
WORDS=(alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike
       november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu
       apple banana cherry grape lemon mango melon orange peach pear plum kiwi
       linux kernel shell script process thread signal socket buffer cache)
word()  { pick "${WORDS[@]}"; }
words() { local i o=(); for ((i=0;i<$1;i++)); do o+=("$(word)"); done; echo "${o[*]}"; }
mkf()   { mkdir -p "$(dirname "$1")"; printf '%s' "${2-}" > "$1"; }             # file with exact content
mkfl()  { local f=$1; shift; mkdir -p "$(dirname "$f")"; printf '%s\n' "$@" > "$f"; }   # file with lines
randtext() { local i; for ((i=0;i<$1;i++)); do words "$(randr 1 8)"; done; }
bigfile()  { mkdir -p "$(dirname "$1")"; head -c "$2" /dev/zero | tr '\0' 'x' > "$1"; } # path bytes
ip_rand()  { echo "$(randr 1 223).$(rand 256).$(rand 256).$(randr 1 254)"; }

# ---------------------------------------------------------------- running
reset_sb() {
  if [[ -e $SB ]]; then
    chmod -R u+rwx "$SB" 2>/dev/null
    rm -rf "$SB" 2>/dev/null || sudo rm -rf "$SB"
  fi
  mkdir -p "$SB/work" "$SB/home" "$SB/bin" "$RES"
}

load_spec() { # dir
  TYPE=script SCRIPT_NAME=script.sh COMPARE="stdout exit" SORT_OUTPUT= SEEDS=3 TIMEOUT=10 RUN_AS_ROOT=
  ARGS=("") ENV=()
  unset -f setup input filter extra_check capture
  setup() { :; }
  source "$1/check.sh"
}

prepare() { # seed
  reset_sb
  rng_seed "$1"
  ( cd "$SB/work" && export HOME=$SB/home W=$SB/work H=$SB/home && umask 022 && SEED=$1 && setup ) \
    >/dev/null 2>"$RES/setup.err"
  [[ -s $RES/setup.err ]] && { cat "$RES/setup.err" >&2; die "fixture setup failed (checker bug)"; }
  return 0
}

archive_state() { # tar file -> its paths (no ./ prefix) + md5 of every member, order-independent
  local t p=(); t=$(mktemp -d); [[ -r $1 ]] || p=(sudo)
  "${p[@]}" tar xf "$1" -C "$t" 2>/dev/null || echo "INVALID ARCHIVE"
  ( cd "$t" && find . -mindepth 1 | sed 's#^\./##' | sort
    find . -type f -print0 | sort -z | "${p[@]}" xargs -0r md5sum )
  "${p[@]}" rm -rf "$t"
}

content_hash() { # file -> hash of its *content* (archives: of what they contain, not timestamps)
  local f=$1 p=()
  [[ -r $f ]] || p=(sudo -n)
  case $f in
    *.tar.gz|*.tgz|*.tar) archive_state "$f" | md5sum ;;
    *.gz)  "${p[@]}" gzip -dc "$f" 2>&1 | md5sum ;;
    *.Z)   "${p[@]}" uncompress -c "$f" 2>&1 | md5sum ;;
    *.bz2) "${p[@]}" bzip2 -dc "$f" 2>&1 | md5sum ;;
    *.xz)  "${p[@]}" xz -dc "$f" 2>&1 | md5sum ;;
    *)     "${p[@]}" md5sum "$f" ;;
  esac | cut -c1-32
}

snapshot() { # -> stdout: state of work+home
  local fmt='%y %M %n %p -> %l' f pre=()
  [[ $COMPARE == *owner* ]] && fmt+=' %u:%g'
  [[ $COMPARE == *mtime* ]] && fmt+=' %TY-%Tm-%Td_%TH:%TM'
  [[ -n $RUN_AS_ROOT ]] && pre=(sudo)
  cd "$SB" || return
  "${pre[@]}" find work home -mindepth 1 -printf "$fmt\n" 2>/dev/null | sed 's/ -> $//' | sort
  "${pre[@]}" find work home -type f -print0 2>/dev/null | sort -z |
    while IFS= read -r -d '' f; do echo "$(content_hash "$f")  $f"; done
  cd - >/dev/null
}

# ---------------------------------------------------------------- helpers for extra_check
ans_code()     { grep -vE '^[[:space:]]*(#.*)?$' "$ANSWER"; }                 # answer without comments
must_use()     { local w; for w; do ans_code | grep -qE -- "(^|[^[:alnum:]_-])$w([^[:alnum:]_]|$)" || fail "your answer must use '$w'"; done; }
must_not_use() { local w; for w; do ans_code | grep -qE -- "(^|[^[:alnum:]_-])$w([^[:alnum:]_]|$)" && fail "your answer must not use '$w'"; done; }
max_lines()    { local n; n=$(ans_code | wc -l); (( n <= $1 )) || fail "use at most $1 line(s) of code (you have $n)"; }
mentions()     { [[ "$OUT$ERR" == *"$1"* ]] || fail "the message should mention '$1'"; }

run_side() { # side script seed case
  local side=$1 script=$2 seed=$3 case=$4 o=$RES/$1
  prepare "$seed"
  mkdir -p "$o"
  install -m 755 "$script" "$SB/bin/$SCRIPT_NAME"
  local -a args=()
  ( cd "$SB/work"; W=$SB/work H=$SB/home; eval "args=( $case )"; (( ${#args[@]} )) && printf '%s\0' "${args[@]}" ) > "$o/args" 2>/dev/null
  mapfile -d '' args < "$o/args"
  if declare -F input >/dev/null; then rng_seed $((seed+1)); ( cd "$SB/work"; W=$SB/work H=$SB/home; input ) > "$o/stdin"; else : > "$o/stdin"; fi
  local -a envv=(HOME="$SB/home" PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
                 USER=alumno LOGNAME=alumno SHELL=/bin/bash LANG=en_US.UTF-8 TERM=dumb TZ=Europe/Madrid "${ENV[@]}")
  local -a pre=(); [[ -n $RUN_AS_ROOT ]] && pre=(sudo)
  # always interpreted by bash (this is a bash lab), even without a #!/bin/bash line
  ( cd "$SB/work" && umask 022 && "${pre[@]}" env -i "${envv[@]}" timeout -k 1 "$TIMEOUT" \
      bash "$SB/bin/$SCRIPT_NAME" "${args[@]}" < "$o/stdin" > "$o/out" 2> "$o/err" 9>&- )
  echo $? > "$o/code"
  [[ $(<"$o/code") == 124 ]] && echo "(timed out after ${TIMEOUT}s — waiting for input? infinite loop?)" >> "$o/err"
  if declare -F filter >/dev/null; then filter < "$o/out" > "$o/out.f"; else cp "$o/out" "$o/out.f"; fi
  sed -i 's/[[:space:]]*$//' "$o/out.f"
  [[ -n $SORT_OUTPUT ]] && sort -o "$o/out.f" "$o/out.f"
  [[ $COMPARE == *files* ]] && snapshot > "$o/fs"
  if declare -F capture >/dev/null; then ( cd "$SB/work" && W=$SB/work H=$SB/home capture ) > "$o/capture" 2>&1; fi
  return 0
}

show_diff() { # label expected got
  echo "    ${B}$1${N} ${D}(- expected, + yours)${N}"
  diff -u "$2" "$3" | tail -n +3 | grep -v '^@@' | head -n 20 | while IFS= read -r l; do
    case $l in
      -*) echo "      ${R}${l}${N}" ;;
      +*) echo "      ${G}${l}${N}" ;;
      *)  echo "      ${l}" ;;
    esac
  done
  local n; n=$(diff "$2" "$3" | grep -c '^[<>]'); (( n > 20 )) && echo "      ${D}... ($n differing lines)${N}"
}

fail() { FAILS+=("$*"); }

check_script() { # dir answer -> 0 pass
  local dir=$1 answer=$2 sol seed c ncase=0 bad=0
  sol="$(ex_sol "$dir").sh"; [[ -f $sol ]] || die "missing reference solution $sol"
  for ((seed=1; seed<=SEEDS; seed++)); do
    for c in "${ARGS[@]}"; do
      ncase=$((ncase+1))
      run_side ref "$sol" "$((seed*7919))" "$c"
      run_side usr "$answer" "$((seed*7919))" "$c"
      FAILS=()
      OUT=$(<"$RES/usr/out") ERR=$(<"$RES/usr/err") CODE=$(<"$RES/usr/code")
      REF_OUT=$(<"$RES/ref/out") REF_ERR=$(<"$RES/ref/err") REF_CODE=$(<"$RES/ref/code")
      CASE=$c W=$SB/work H=$SB/home ANSWER=$answer SEED=$((seed*7919))
      local detail=()
      if [[ $COMPARE == *stdout* ]] && ! cmp -s "$RES/ref/out.f" "$RES/usr/out.f"; then fail "stdout differs"; detail+=(stdout); fi
      if [[ $COMPARE == *stderr* ]] && ! cmp -s "$RES/ref/err" "$RES/usr/err"; then fail "stderr differs"; detail+=(stderr); fi
      if [[ $COMPARE == *errmsg* ]]; then
        [[ -s $RES/ref/err && ! -s $RES/usr/err ]] && fail "expected an error message on stderr (>&2), got none"
        [[ ! -s $RES/ref/err && -s $RES/usr/err ]] && fail "unexpected output on stderr: $(head -c 200 "$RES/usr/err")"
      fi
      [[ $COMPARE == *exit* && $CODE != "$REF_CODE" ]] && fail "exit code: expected $REF_CODE, got $CODE"
      if [[ $COMPARE == *files* ]] && ! cmp -s "$RES/ref/fs" "$RES/usr/fs"; then fail "resulting files differ"; detail+=(fs); fi
      if declare -F capture >/dev/null && ! cmp -s "$RES/ref/capture" "$RES/usr/capture"; then fail "resulting state differs"; detail+=(capture); fi
      declare -F extra_check >/dev/null && extra_check
      if (( ${#FAILS[@]} )); then
        bad=$((bad+1))
        if (( bad <= 2 )); then
          echo "  ${R}✘${N} case: ${B}${c:-<no arguments>}${N}  ${D}(fixture seed $((seed*7919)) → play $(ex_id "$dir") $((seed*7919)))${N}"
          printf '    %s\n' "${FAILS[@]}"
          for d in "${detail[@]}"; do
            case $d in
              stdout) show_diff stdout "$RES/ref/out.f" "$RES/usr/out.f" ;;
              stderr) show_diff stderr "$RES/ref/err" "$RES/usr/err" ;;
              fs)     show_diff "files (type perms links path)" "$RES/ref/fs" "$RES/usr/fs" ;;
              capture) show_diff state "$RES/ref/capture" "$RES/usr/capture" ;;
            esac
          done
          [[ -s $RES/usr/err && " ${detail[*]} " != *" stderr "* ]] && { echo "    ${D}your stderr:${N}"; head -n 5 "$RES/usr/err" | sed 's/^/      /'; }
        fi
      fi
    done
  done
  reset_sb
  (( bad )) && { (( bad > 2 )) && echo "  ${D}... $bad of $ncase cases failed${N}"; return 1; }
  echo "  ${G}✔${N} $ncase/$ncase cases passed"
  return 0
}

norm_ans() { tr '[:upper:]' '[:lower:]' | sed -E 's/^[[:space:]]+|[[:space:]]+$//g; s/[[:space:]]+/ /g; s/^"(.*)"$/\1/'; }

check_quiz() { # dir answer
  local key="$(ex_sol "$1").txt" q acc mine ok=0 tot=0 line
  [[ -f $key ]] || die "missing key $key"
  while IFS= read -r line; do
    [[ $line =~ ^([0-9]+):(.*)$ ]] || continue
    q=${BASH_REMATCH[1]} acc=${BASH_REMATCH[2]}
    tot=$((tot+1))
    mine=$(grep -E "^[[:space:]]*$q[[:space:]]*:" "$2" | head -1 | cut -d: -f2- | norm_ans)
    local good=
    IFS='|' read -ra alts <<< "$acc"
    for a in "${alts[@]}"; do [[ -n $mine && $mine == "$(norm_ans <<< "$a")" ]] && good=1; done
    if [[ -n $good ]]; then ok=$((ok+1)); else echo "  ${R}✘${N} question $q: '${mine:-<empty>}' is not correct"; fi
  done < "$key"
  if (( ok == tot )); then echo "  ${G}✔${N} $ok/$tot correct"; return 0; fi
  echo "  $ok/$tot correct"; return 1
}

# ---------------------------------------------------------------- commands
check_one() { # id [answer-file] -> 0 pass, 1 fail, 3 not attempted
  local dir answer id rc
  dir=$(ex_dir "$1") || exit 2
  id=$(ex_id "$dir")
  load_spec "$dir"
  if [[ $TYPE == quiz ]]; then answer=${2:-$dir/answer.txt}; else answer=${2:-$dir/answer.sh}; fi
  echo "${B}[$id]${N} $(head -1 "$dir/README.md" | sed 's/^# *//')"
  if ! attempted "$answer"; then echo "  ${Y}·${N} not attempted (edit ${answer#$LAB/})"; return 3; fi
  if [[ $TYPE == quiz ]]; then check_quiz "$dir" "$answer"; else check_script "$dir" "$answer"; fi
  rc=$?
  if [[ -z ${2:-} ]]; then
    mkdir -p "$PROGRESS"
    if (( rc == 0 )); then echo pass > "$PROGRESS/$id"; else rm -f "$PROGRESS/$id"; fi
  fi
  return $rc
}

play() { # id [seed] -> build fixture in ~/play/<id>
  local dir id seed=${2:-7919}
  dir=$(ex_dir "$1") || exit 2; id=$(ex_id "$dir"); load_spec "$dir"
  local P=$HOME/play/$id
  chmod -R u+rwx "$P" 2>/dev/null; rm -rf "$P"; mkdir -p "$P/work" "$P/home"
  rng_seed "$seed"
  ( cd "$P/work" && export HOME=$P/home W=$P/work H=$P/home && umask 022 && SEED=$seed && setup ) >/dev/null
  echo "Fixture for $id (seed $seed) created:"
  echo "  work dir: $P/work"
  echo "  home dir: $P/home   (the checker runs your script with HOME set to this)"
  if declare -F input >/dev/null; then rng_seed $((seed+1)); ( cd "$P/work"; W=$P/work H=$P/home; input ) > "$P/stdin.txt"; echo "  stdin   : $P/stdin.txt"; fi
  echo
  echo "Run your answer exactly like the checker does (add the arguments you want to try):"
  local a=$dir/answer.sh; [[ $SCRIPT_NAME != script.sh ]] && echo "  (the checker installs it as $SCRIPT_NAME)"
  if declare -F input >/dev/null; then
    echo "  cd $P/work && HOME=$P/home bash ${a/#$HOME/\~} ARGS < ../stdin.txt"
  else
    echo "  cd $P/work && HOME=$P/home bash ${a/#$HOME/\~} ARGS"
  fi
  (( ${#ARGS[@]} > 1 )) || [[ -n ${ARGS[0]} ]] && echo "  test cases (ARGS) used by the checker: $(printf '[%s] ' "${ARGS[@]}")"
  true
}
