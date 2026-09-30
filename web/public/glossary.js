// Generic, non-spoiling explanations of the commands/concepts an exercise's "Commands:" line
// names. These describe what a command or piece of syntax does in general — never how to apply
// it to solve a particular exercise — so the reference glossary and the per-exercise "Info"
// panel are safe to show before you've solved anything.
'use strict';
const GLOSSARY = {
  // ---- getting help ----
  man: { name: 'man', desc: 'Shows the manual page of a command. `man 5 passwd` picks a section when a name exists in several (1 commands, 2 syscalls, 5 file formats, 8 admin...).' },
  info: { name: 'info', desc: 'Reads GNU-style documentation, organised as linked nodes rather than one long page. Move with arrows/Enter, `u` up a level, `l` last page, `q` quit.' },
  whatis: { name: 'whatis', desc: 'Prints the one-line description of a manual page, if a page with that exact name exists.' },
  apropos: { name: 'apropos', desc: 'Searches the one-line descriptions of all manual pages for a keyword (same as `man -k`).' },
  which: { name: 'which', desc: 'Shows the path of the executable that would run for a command name, searching $PATH.' },
  whereis: { name: 'whereis', desc: "Shows a command's binary, source and manual page locations." },
  less: { name: 'less', desc: 'A pager: shows text one screen at a time. `/pattern` searches, `q` quits.' },

  // ---- shell / job control ----
  jobs: { name: 'jobs', desc: 'Lists the jobs (background/suspended commands) of the current shell, numbered.' },
  bg: { name: 'bg', desc: 'Resumes a suspended job in the background.' },
  fg: { name: 'fg', desc: 'Brings a background or suspended job to the foreground.' },
  '&': { name: '&', desc: 'Placed after a command, runs it in the background: the shell does not wait for it and reads the next line immediately.' },
  '^z': { name: 'Ctrl+Z', desc: 'Suspends the foreground process (sends SIGTSTP). The process is paused, not terminated.' },
  '^c': { name: 'Ctrl+C', desc: 'Sends SIGINT to the foreground process, which by default terminates it.' },
  ps: { name: 'ps', desc: 'Lists processes. Common options: `-e`/`-A` all processes, `-f` full format, `-o FIELDS` choose columns, `-p PID` a specific process.' },
  pstree: { name: 'pstree', desc: 'Shows processes as a tree of parents and children.' },
  top: { name: 'top', desc: 'Shows a live, auto-refreshing list of processes ordered by resource usage.' },
  kill: { name: 'kill', desc: 'Sends a signal to a process (default TERM, ask it to stop). `kill -9 PID` (SIGKILL) cannot be ignored. `kill -l` lists signal names.' },
  wait: { name: 'wait', desc: "Pauses the shell until a background job (or a specific PID/job) finishes, and returns its exit status." },
  '$!': { name: '$!', desc: 'The PID of the most recently started background job.' },
  '$$': { name: '$$', desc: 'The PID of the current shell (or script).' },
  bashpid: { name: '$BASHPID', desc: 'The PID of the current bash *process* — unlike `$$`, this changes inside a subshell.' },
  sleep: { name: 'sleep', desc: 'Pauses for a given number of seconds (decimals allowed, e.g. `sleep 0.5`).' },
  trap: { name: 'trap', desc: "Runs a command when the shell receives a signal, e.g. `trap 'cleanup' EXIT`." },

  // ---- navigation & files ----
  cd: { name: 'cd', desc: 'Changes the current directory. No argument goes to $HOME; `cd -` goes to the previous directory.' },
  pwd: { name: 'pwd', desc: 'Prints the current directory\'s absolute path.' },
  mkdir: { name: 'mkdir', desc: 'Creates directories. `-p` also creates missing parent directories and does not error if the target already exists.' },
  rmdir: { name: 'rmdir', desc: 'Removes a directory, but only if it is empty.' },
  ls: { name: 'ls', desc: 'Lists directory contents. `-a` shows hidden entries, `-l` long format, `-R` recursive, `-S`/`-t` sort by size/time, `-d` list a directory itself, not its content.' },
  tree: { name: 'tree', desc: 'Prints a directory as an indented tree. `-L n` limits depth, `-d` directories only, `-a` includes hidden files, `-P pattern` keeps only matches, `--prune` drops directories left empty by that filter.' },
  du: { name: 'du', desc: 'Reports disk usage of files/directories. `-s` a single total, `-h` human-readable sizes, `-a` files too (not just directories).' },
  df: { name: 'df', desc: 'Reports free/used space of mounted filesystems.' },
  stat: { name: 'stat', desc: "Shows a file's metadata (size, permissions, owner, timestamps, inode, link count). `-c FORMAT` picks which fields to print, e.g. `%s` size, `%a` octal permissions, `%h` link count." },
  touch: { name: 'touch', desc: 'Updates a file\'s timestamps, creating an empty file if it does not exist. `-d "date"` sets an arbitrary time.' },
  file: { name: 'file', desc: "Guesses a file's type by inspecting its content, not just its name." },
  mktemp: { name: 'mktemp', desc: 'Creates a uniquely-named temporary file (or `-d` a directory) and prints its path.' },

  // ---- copying, moving, links ----
  cp: { name: 'cp', desc: 'Copies files. `-r` recursively (for directories), `-a` preserves attributes/links, `-p` preserves mode/timestamps.' },
  mv: { name: 'mv', desc: 'Renames or moves files/directories.' },
  rm: { name: 'rm', desc: 'Deletes files. `-r` recursively for directories, `-f` never asks/errors on missing files.' },
  ln: { name: 'ln', desc: 'Creates a link. By default a hard link (another name for the same data); `-s` creates a symbolic link (a pointer to a path, which breaks if that path is removed).' },
  readlink: { name: 'readlink', desc: "Prints a symbolic link's target. `-f` resolves the whole chain to a final absolute, canonical path." },
  basename: { name: 'basename', desc: 'Strips the directory part (and, if given, a suffix) from a path, leaving just the file name.' },
  dirname: { name: 'dirname', desc: "Prints a path's directory part, dropping the final component." },

  // ---- archives / compression ----
  tar: { name: 'tar', desc: 'Bundles files into one archive (and can extract them). `-c` create, `-x` extract, `-t` list, `-r` append, `-f FILE` the archive file, `-z`/`-j`/`-J` compress with gzip/bzip2/xz, `-v` verbose, `-C dir` change directory first, `-O` extract to stdout.' },
  gzip: { name: 'gzip', desc: 'Compresses a file in place (replacing it with a `.gz`). `-d` decompress, `-k` keep the original, `-r` recurse into directories, `-9` best compression.' },
  gunzip: { name: 'gunzip', desc: 'Decompresses a `.gz` file (same as `gzip -d`).' },
  zcat: { name: 'zcat', desc: 'Prints the decompressed content of a `.gz` file without writing anything to disk.' },
  bzip2: { name: 'bzip2', desc: 'Compresses a file into `.bz2`, generally smaller but slower than gzip. `-k` keeps the original, `-d` decompresses.' },
  bunzip2: { name: 'bunzip2', desc: 'Decompresses a `.bz2` file.' },
  xz: { name: 'xz', desc: 'Compresses a file into `.xz`, usually the smallest of the common formats. `-k` keeps the original, `-d` decompresses, `-9` best compression.' },
  compress: { name: 'compress', desc: 'The classic Unix compressor, producing a `.Z` file.' },
  uncompress: { name: 'uncompress', desc: 'Decompresses a `.Z` file.' },

  // ---- text filters ----
  cat: { name: 'cat', desc: "Prints a file's content. With several files, concatenates them. `-n` numbers lines." },
  head: { name: 'head', desc: "Prints a file's first lines (`-n N`) or bytes (`-c N`). `-n -N` prints everything except the last N lines." },
  tail: { name: 'tail', desc: "Prints a file's last lines (`-n N`) or bytes (`-c N`). `-n +N` starts printing from line N onward." },
  wc: { name: 'wc', desc: 'Counts lines (`-l`), words (`-w`) or bytes/characters (`-c`/`-m`) of its input.' },
  cut: { name: 'cut', desc: "Extracts columns from each line. `-d` sets the field delimiter, `-f` picks field numbers, `-c` picks character positions." },
  sort: { name: 'sort', desc: "Sorts lines. `-n`/`-h` numeric/human-readable comparison, `-r` reverse, `-u` drop duplicates, `-t` field delimiter, `-k N` sort by field N." },
  uniq: { name: 'uniq', desc: "Collapses ADJACENT duplicate lines (so input is usually sorted first). `-c` prefixes each line with its count, `-d` shows only lines that repeated." },
  tr: { name: 'tr', desc: "Translates or deletes characters from stdin. `tr a-z A-Z` maps ranges; `-d` deletes characters; `-s` squeezes runs of repeats into one." },
  sed: { name: 'sed', desc: "A stream editor. `s/old/new/` substitutes (add `g` for every match on the line); `/pattern/d` deletes matching lines; `-n 'N,Mp'` prints only a line range; `-i` edits the file in place." },
  tee: { name: 'tee', desc: 'Copies stdin to both stdout and a file (or several, and `-a` to append) at once.' },
  nl: { name: 'nl', desc: 'Numbers the lines of a file (skipping blank lines by default, unlike `cat -n`).' },
  tac: { name: 'tac', desc: "Prints a file's lines in reverse order (`cat` backwards)." },
  paste: { name: 'paste', desc: 'Joins the corresponding lines of several files side by side, separated by tab (or `-d` a custom character).' },
  diff: { name: 'diff', desc: 'Shows the differences between two files, line by line. `-q` only says whether they differ, `-r` compares directories recursively.' },
  cmp: { name: 'cmp', desc: 'Compares two files byte by byte; silent (just an exit code) with `-s`.' },
  od: { name: 'od', desc: 'Dumps a file in octal, hex or another base — useful for seeing bytes a text viewer would hide.' },
  split: { name: 'split', desc: 'Splits a file into smaller pieces. `-l N` by number of lines, `-d` numeric suffixes.' },

  // ---- search ----
  grep: { name: 'grep', desc: "Prints the lines of its input that match a pattern. `-i` ignore case, `-v` invert (non-matching lines), `-c` count only, `-n` show line numbers, `-o` print only the matched part, `-w`/`-x` match a whole word/line, `-r` recurse into directories, `-E` use extended regular expressions, `-F` treat the pattern as a literal string." },
  find: { name: 'find', desc: "Searches a directory tree for files matching conditions: `-name`, `-iname` (case-insensitive), `-type f/d`, `-size`, `-perm`, `-mtime`, `-newer`, `-maxdepth`/`-mindepth`. `-exec cmd {} \\;` runs a command per match; `-delete` removes matches." },
  xargs: { name: 'xargs', desc: "Builds and runs a command using arguments read from stdin (one call per batch, not one per line, unless `-n1`). `-I{}` substitutes each input into a placeholder; `-0` expects NUL-separated input (pair with `find -print0`)." },

  // ---- permissions ----
  chmod: { name: 'chmod', desc: "Changes permissions. Symbolic form: `u/g/o/a` `+/-/=` `r/w/x` (e.g. `u+x`). Octal form: three digits, one per r/w/x group (e.g. `755`). `-R` recurses into directories." },
  chown: { name: 'chown', desc: 'Changes the owning user (and, with `user:group`, the group) of files. `-R` recurses.' },
  chgrp: { name: 'chgrp', desc: 'Changes the owning group of files.' },
  umask: { name: 'umask', desc: 'Sets the mask of permission bits removed from newly created files/directories. Given with no argument, it prints the current mask.' },

  // ---- redirection & pipes ----
  '>': { name: '>', desc: "Redirects a command's standard output to a file, overwriting it." },
  '>>': { name: '>>', desc: "Redirects a command's standard output to a file, appending to it." },
  '<': { name: '<', desc: "Redirects a file's content to a command's standard input." },
  '2>': { name: '2>', desc: "Redirects a command's standard error to a file." },
  '2>&1': { name: '2>&1', desc: 'Sends standard error to wherever standard output is currently going. Order matters: it must come after the `>` that sets that destination.' },
  '&>': { name: '&>', desc: 'Redirects both standard output and standard error to the same file.' },
  '|': { name: '|', desc: "Connects one command's standard output to the next command's standard input." },
  '<<': { name: '<<EOF (here document)', desc: 'Feeds the following lines, up to a matching delimiter, to a command\'s standard input. Quoting the delimiter (`<<\'EOF\'`) stops `$variables` from being expanded inside it.' },
  '<<<': { name: '<<< (here string)', desc: "Feeds a single string to a command's standard input, as if it were a one-line file." },
  '<()': { name: '<(...) (process substitution)', desc: "Runs a command and makes its output readable as if it were a file — handy for commands like `diff` that expect two file arguments." },

  // ---- variables, substitution, arithmetic ----
  echo: { name: 'echo', desc: 'Prints its arguments. `-n` omits the trailing newline, `-e` interprets escapes like `\\t`/`\\n`.' },
  printf: { name: 'printf', desc: 'Prints formatted text using a format string (`%s`, `%d`, `%x`...), like the C function. Unlike `echo`, it never adds a newline on its own.' },
  read: { name: 'read', desc: "Reads one line from standard input into one or more variables, splitting on IFS. `-r` disables backslash escaping, `-p` shows a prompt, `-a` reads into an array." },
  ifs: { name: 'IFS', desc: 'The shell variable listing the characters used to split words/fields, e.g. `while IFS=: read ...` splits on colons.' },
  export: { name: 'export', desc: 'Marks a variable (or function, with `-f`) so that it is inherited by child processes.' },
  unset: { name: 'unset', desc: 'Removes a variable or function.' },
  env: { name: 'env', desc: 'Prints the current environment variables, or runs a command with a modified environment.' },
  printenv: { name: 'printenv', desc: 'Prints environment variables (only those that are exported).' },
  source: { name: 'source (or `.`)', desc: 'Runs a script in the *current* shell instead of a new subshell, so its variable/directory changes persist afterwards.' },
  expr: { name: 'expr', desc: 'Evaluates an expression (arithmetic, string) given as separate arguments, e.g. `expr 3 + 4`.' },
  bc: { name: 'bc', desc: 'An arbitrary-precision calculator that reads expressions from stdin; `scale=N` sets the number of decimals.' },
  seq: { name: 'seq', desc: 'Prints a sequence of numbers, e.g. `seq 1 2 10` (start, step, end).' },
  date: { name: 'date', desc: "Prints (or with `-d` parses) a date/time. `+FORMAT` customises the output, e.g. `date +%Y-%m-%d`." },
  '$(( ))': { name: '$(( expression ))', desc: 'Evaluates an integer arithmetic expression and substitutes its value, e.g. `$((3 * 4))`.' },
  '$( )': { name: '$( command )', desc: "Command substitution: runs a command and substitutes its output as text. `` `command` `` is the older, equivalent syntax." },
  '$(func)': { name: '$(function)', desc: 'Calling a function inside `$( )` captures whatever it prints, letting a function "return" data (as opposed to `return`, which only sets a 0-255 exit code).' },
  '${...}': { name: '${VAR}', desc: 'Braces around a variable name disambiguate it from surrounding text, and enable expansions like `${VAR:-default}`, `${VAR#prefix}`, `${VAR%suffix}`, `${VAR/old/new}`, `${VAR:offset:length}`.' },
  '${var}': { name: '${VAR}', desc: 'Braces around a variable name disambiguate it from surrounding text, and enable expansions like `${VAR:-default}`, `${VAR#prefix}`, `${VAR%suffix}`, `${VAR/old/new}`, `${VAR:offset:length}`.' },
  quoting: { name: 'quoting', desc: 'Double quotes `"..."` still expand `$variables` and `$(...)` but protect spaces/globs; single quotes `\'...\'` take everything literally.' },
  arrays: { name: 'arrays', desc: 'Bash arrays: `a=(x y z)`, `${a[0]}` an element, `${a[@]}` all elements, `${#a[@]}` the count, `a+=(w)` to append.' },

  // ---- script parameters ----
  '$#': { name: '$#', desc: 'The number of arguments passed to the script or function.' },
  '$@': { name: '$@', desc: 'All arguments, each preserved as a separate word — use it quoted, `"$@"`, to keep multi-word arguments intact.' },
  '$*': { name: '$*', desc: 'All arguments joined into a single word when quoted (`"$*"`), unlike `"$@"`.' },
  '$0': { name: '$0', desc: "The script's own name (or path) as it was invoked." },
  '$?': { name: '$?', desc: 'The exit status of the last command (0 means success).' },
  'exit codes': { name: 'exit codes', desc: 'A script or command ends with a number from 0 to 255: 0 means success, anything else signals a specific kind of failure, checked via `$?` or `if command; then`.' },
  shift: { name: 'shift', desc: 'Drops `$1` and renumbers the remaining positional parameters down by one (or by `N`, given an argument).' },

  // ---- conditionals ----
  test: { name: 'test (or `[ ]`)', desc: 'Evaluates a condition and returns an exit status accordingly: 0 (true) or 1 (false). `[ expr ]` is the same command spelled differently.' },
  '[[ ]]': { name: '[[ ]]', desc: "Bash's extended conditional: safer word-splitting than `[ ]`, plus glob matching (`==`) and regex matching (`=~`)." },
  '[[ =~ ]]': { name: '[[ $x =~ regex ]]', desc: 'Tests a string against an extended regular expression inside `[[ ]]`; captured groups become available in `${BASH_REMATCH[@]}`.' },
  '(( ))': { name: '(( expression ))', desc: 'Evaluates an arithmetic expression as a condition — true if it evaluates to non-zero, e.g. `(( x > 10 ))`.' },
  case: { name: 'case', desc: 'Matches a value against a list of glob-style patterns, running the commands under the first one that matches.' },

  // ---- loops & functions ----
  for: { name: 'for', desc: '`for x in list; do ...; done` runs a block once per item; `for ((i=0;i<n;i++))` is the C-style counting form.' },
  while: { name: 'while', desc: 'Repeats a block for as long as a condition (often `read line` or `test ...`) keeps succeeding.' },
  until: { name: 'until', desc: 'Like `while`, but repeats for as long as the condition keeps *failing*.' },
  select: { name: 'select', desc: 'Shows a numbered menu built from a list and repeatedly reads a choice into a variable.' },
  break: { name: 'break', desc: 'Exits the innermost enclosing loop immediately.' },
  continue: { name: 'continue', desc: 'Skips to the next iteration of the innermost enclosing loop.' },
  functions: { name: 'functions', desc: 'Defined as `name() { ...; }`. Arguments become `$1`, `$2`, `"$@"` *inside* the function, separate from the script\'s own. `local` keeps a variable from leaking out.' },
  local: { name: 'local', desc: "Declares a variable scoped to the current function, instead of the whole script." },
  return: { name: 'return', desc: "Exits a function with a numeric status (0-255), retrievable via `$?` — not a way to send back data (use `$(function)` for that)." },
  recursion: { name: 'recursion', desc: 'A function calling itself (directly or indirectly) to solve a smaller version of the same problem.' },
  counters: { name: 'counters', desc: 'A variable incremented across loop iterations to accumulate a total or a count, e.g. `n=$((n + 1))`.' },

  // ---- users / admin ----
  who: { name: 'who', desc: 'Lists the sessions currently logged into the system.' },
  w: { name: 'w', desc: 'Like `who`, plus what each logged-in user is currently running.' },
  last: { name: 'last', desc: 'Shows the login history, read from the wtmp log.' },
  id: { name: 'id', desc: "Prints a user's UID, GID and group memberships. `-u`/`-g`/`-G` show only one; `-n` shows names instead of numbers." },
  groups: { name: 'groups', desc: 'Lists the groups a user belongs to.' },
  whoami: { name: 'whoami', desc: 'Prints the current effective user name.' },
  su: { name: 'su', desc: 'Starts a shell (or `-c "cmd"` a single command) as another user, usually root.' },
  sudo: { name: 'sudo', desc: "Runs a single command as another user (usually root), governed by rules in /etc/sudoers. `-u user` picks the user, `-i` loads that user's environment." },
  passwd: { name: 'passwd', desc: "Changes a user's password. `-l`/`-u` lock/unlock the account, `-e` forces a change at next login, `-S` shows its status." },
  useradd: { name: 'useradd', desc: 'Creates a new user account. `-m` creates its home directory, `-s` sets its shell, `-G` its supplementary groups, `-c` its full name (GECOS).' },
  usermod: { name: 'usermod', desc: "Modifies an existing user's account, e.g. `-aG group` adds it to a group *without* removing its others." },
  groupadd: { name: 'groupadd', desc: 'Creates a new group.' },
  gpasswd: { name: 'gpasswd', desc: '`gpasswd -d user group` removes a user from a group.' },
  getent: { name: 'getent', desc: 'Looks up an entry (user, group...) the same way the system itself would, via `getent passwd NAME`, `getent group NAME`, etc.' },
  visudo: { name: 'visudo', desc: 'Safely edits (and syntax-checks before saving) the sudoers configuration.' },
  crontab: { name: 'crontab', desc: '`-l` lists a user\'s scheduled jobs, `-e` edits them, `-r` removes them all. A schedule line reads `minute hour day month weekday command`.' },

  // ---- more syntax forms (matched by exact token, since they have no separable "base word") ----
  '>&2': { name: '>&2', desc: 'Redirects a stream to file descriptor 2, i.e. sends it to standard error instead of standard output.' },
  '&&': { name: '&&', desc: 'Runs the next command only if the previous one succeeded (exit status 0).' },
  '||': { name: '||', desc: 'Runs the next command only if the previous one failed (a non-zero exit status).' },
  '"$@"': { name: '"$@"', desc: 'All arguments, quoted so that each one stays intact as a single word even if it contains spaces.' },
  '"$*"': { name: '"$*"', desc: 'All arguments joined into one single word, space-separated (or by the first character of IFS).' },
  variables: { name: 'variables', desc: 'Set with `NAME=value` (no spaces around `=`) and read with `$NAME` or `${NAME}`.' },
  arithmetic: { name: 'arithmetic', desc: "Integer math in bash is done with `$(( ))`, `(( ))` or the `expr`/`bc` commands — plain `+`/`-` in a string do not add numbers." },
  bash_rematch: { name: 'BASH_REMATCH', desc: 'After a successful `[[ $x =~ regex ]]`, this array holds the whole match (`[0]`) and each parenthesised group (`[1]`, `[2]`...).' },
  'declare -a': { name: 'declare -A', desc: 'Declares an associative array (string keys instead of numeric indices): `declare -A m; m[key]=value`.' },
  'ifs=': { name: 'IFS=', desc: 'Setting IFS to empty (or a custom value) just for one command, e.g. `IFS= read -r line`, controls how that command splits words without affecting the rest of the script.' },
  'ifs=:': { name: 'IFS=... read', desc: 'Setting IFS before `read` changes the field separator it splits on, e.g. `IFS=: read -r a b` splits on colons.' },
  comm: { name: 'comm', desc: 'Compares two *sorted* files line by line, printing three columns: unique to the first, unique to the second, and common to both.' },
  realpath: { name: 'realpath', desc: 'Prints the absolute, canonical path of a file, resolving any `..`, `.` and symbolic links.' },
  '/etc/passwd': { name: '/etc/passwd', desc: 'One line per user: login:x:UID:GID:full name:home:shell.' },
  '/etc/shadow': { name: '/etc/shadow', desc: "Holds users' encrypted passwords and aging info; only readable by root." },
  '/etc/group': { name: '/etc/group', desc: 'One line per group: name:x:GID:comma-separated extra members.' },
  scope: { name: 'variable scope', desc: 'Without `local`, a variable assigned inside a function is visible everywhere in the script; `local` confines it to that function.' },
  '"$@" forwarding': { name: '"$@" forwarding', desc: 'Passing a function\'s (or script\'s) own `"$@"` straight through to another command, keeping each argument intact.' },
  'die/usage pattern': { name: 'die/usage helper', desc: 'A small function (often called `die` or `usage`) that prints an error to stderr and exits, called from several validation checks instead of repeating that code.' },
  'regex validation': { name: 'regex validation', desc: 'Using `[[ $x =~ pattern ]]` (or `grep -E`) to check that a value has the expected shape before using it.' },
  'bash -c': { name: 'bash -c', desc: 'Runs the string argument as a bash command, e.g. `bash -c \'echo hi\'` — used to run a snippet in a fresh (sub)shell.' },
  '${!#}': { name: '${!#}', desc: "The value of the last positional parameter (equivalent to `\${@: -1}`)." },
  '$((10#...))': { name: '$((10#N))', desc: 'Forces a number to be read in base 10 — needed for strings like `08` that bash would otherwise misread as invalid octal.' },
  relativepaths: { name: 'relative paths', desc: "A path not starting with `/`, interpreted from the current directory; `.` is itself, `..` its parent." },
  '..': { name: '..', desc: "Refers to the parent of the current directory." },
  '~': { name: '~', desc: "Expands to the current user's home directory." },
  '*/': { name: '*/', desc: 'A glob that only matches directories (a trailing slash forces that), unlike a plain `*`.' },
  '--noreport': { name: '--noreport (tree)', desc: "tree's option to omit its final \"N directories, M files\" summary line." },
  'link count': { name: 'link count', desc: 'How many directory entries (hard links) point at the same inode — shown by `ls -l` or `stat -c %h`.' },
  '${v^}': { name: '${v^}', desc: 'Uppercases the first character of the variable.' },
  '${v^^}': { name: '${v^^}', desc: 'Uppercases every character of the variable.' },
  '${v,,}': { name: '${v,,}', desc: 'Lowercases every character of the variable.' },
  '${v:0:1}': { name: '${v:offset:length}', desc: 'Extracts a substring: `length` characters starting at `offset` (0-based).' },
  '${v//x/y}': { name: '${v//x/y}', desc: 'Replaces every occurrence of x with y in the variable (a single `/` before x replaces only the first occurrence).' },
  '${v#x}': { name: '${v#pattern}', desc: 'Removes the shortest match of `pattern` from the start of the variable (`##` removes the longest match).' },
  '${v%x}': { name: '${v%pattern}', desc: 'Removes the shortest match of `pattern` from the end of the variable (`%%` removes the longest match).' },
  '${#v}': { name: '${#v}', desc: 'The length, in characters, of the variable.' },
  '$(cat ...)': { name: '$(cat file)', desc: "Command substitution used to read a whole file's content into a variable." },
  'word splitting': { name: 'word splitting', desc: 'How an unquoted value gets broken into separate words at each IFS character — the reason `"$@"` and `"$var"` are usually quoted.' },
  '-delete': { name: 'find -delete', desc: "find's action to remove every matched file/directory — put it last, after the filters that select what to delete." },
  '-path': { name: 'find -path', desc: "Matches against a file's whole path (not just its final name), e.g. `-path '*/2025/*'`." },
  '-type d': { name: 'find -type', desc: '`f` for regular files, `d` for directories, `l` for symbolic links.' },
  '--include': { name: 'grep --include', desc: "Combined with `-r`, limits a recursive search to file names matching a pattern, e.g. `--include='*.log'`." },
  'exit n': { name: 'exit N', desc: 'Ends the script immediately with N as its exit status.' },
  scale: { name: 'bc scale', desc: "In `bc`, `scale=N` sets how many decimal digits results are shown/rounded to." },
  'if elif': { name: 'if / elif / else', desc: 'A chain of conditions tried in order; the block under the first true one runs, `else` catches the rest.' },
  options: { name: 'option parsing', desc: "Reading flags like `-n`/`-m` out of a script's own arguments, usually with a `while`/`case` loop that shifts each one off before reaching the real arguments." },
  '( ) &': { name: '( commands ) &', desc: 'Runs a group of commands in a subshell, in the background — useful to isolate `cd`/variable changes or to launch several things at once.' },
  '$home': { name: '$HOME', desc: "The current user's home directory." },
  '$hostname': { name: '$HOSTNAME', desc: "The machine's name, available directly as a variable (no command needed)." },
  '$var': { name: '$VAR', desc: 'Expands to the value of the variable VAR.' },
  '/dev/null': { name: '/dev/null', desc: 'A special file that discards anything written to it, and reads as empty — used to throw output away.' },
  globbing: { name: 'globbing', desc: 'Wildcard patterns the *shell* expands before running a command: `*` any characters, `?` one character, `[abc]` one of a set.' },
  '{a..b}': { name: '{a..b} (brace expansion)', desc: 'Expands to every value in the range, e.g. `{1..5}` becomes `1 2 3 4 5`, done by the shell before the command runs.' },
  x: { name: 'X (chmod)', desc: 'In `chmod`, capital `X` sets execute only on directories, or on files that already have execute set for someone.' },
  'exec 3>': { name: 'exec 3> file', desc: 'Opens a file on a custom file descriptor (here 3) for writing, kept open across later commands until explicitly closed.' },
  'exec 3>&-': { name: 'exec 3>&-', desc: 'Closes file descriptor 3.' },
  'exec 4<': { name: 'exec 4< file', desc: 'Opens a file on a custom file descriptor (here 4) for reading.' },
  '<( )': { name: '<(...) (process substitution)', desc: "Runs a command and exposes its output as if it were a file, e.g. `diff <(cmd1) <(cmd2)`." },
};

function baseWord(token) { return (token.match(/^\S+/) || [token])[0]; }
function norm(s) { return s.trim().toLowerCase(); }

// Returns {key, name, desc} for a raw "Commands:" token, falling back to the token itself
// (desc: null) when nothing in the glossary matches.
const FALLBACK_PATTERNS = [
  [/^\$\{/, { name: '${...} (parameter expansion)', desc: 'Braces around a variable enable expansions beyond a plain `$VAR` — trimming, defaults, substring, case changes and more.' }],
  [/^\$\(\(/, { name: '$(( ))', desc: 'Evaluates an integer arithmetic expression and substitutes its value.' }],
  [/^\[\[/, { name: '[[ ]]', desc: "Bash's extended conditional test." }],
  [/^-[a-z]/i, { name: 'a command-line option', desc: 'A flag of the command this appears alongside in the exercise — check that command\'s own glossary entry or `man`.' }],
];
function explainToken(token) {
  const t = norm(token);
  if (GLOSSARY[t]) return { key: t, ...GLOSSARY[t] };
  const b = norm(baseWord(t));
  if (GLOSSARY[b]) return { key: b, ...GLOSSARY[b] };
  for (const [re, entry] of FALLBACK_PATTERNS) if (re.test(t)) return { key: t, ...entry };
  return { key: t, name: token.trim(), desc: null };
}

// Splits an exercise's "Commands:" string into distinct, explained entries.
function explainCmds(cmdsStr) {
  const seen = new Set();
  const out = [];
  for (const raw of (cmdsStr || '').split(',')) {
    const tok = raw.trim();
    if (!tok) continue;
    const e = explainToken(tok);
    if (seen.has(e.key)) continue;
    seen.add(e.key);
    out.push(e);
  }
  return out;
}
