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
  kill: { name: 'kill', desc: 'Sends a signal to a process (default TERM, ask it to stop). `kill -9 PID` (SIGKILL) cannot be ignored. `kill -l` lists signal names.',
    usage: 'kill [options] PID...',
    options: [
      { flag: '-SIGNAL / -s SIGNAL', desc: 'which signal to send (default TERM)' },
      { flag: '-9', desc: 'SIGKILL: cannot be caught or ignored, forces termination' },
      { flag: '-l', desc: 'list all signal names' },
    ],
    examples: [
      { cmd: 'kill 1234', desc: 'ask process 1234 to terminate (SIGTERM)' },
      { cmd: 'kill -9 1234', desc: 'force-kill it' },
      { cmd: 'kill -l', desc: 'list available signal names' },
    ] },
  wait: { name: 'wait', desc: "Pauses the shell until a background job (or a specific PID/job) finishes, and returns its exit status.",
    usage: 'wait [PID or job]',
    options: [
      { flag: '(no argument)', desc: 'wait for ALL background jobs to finish' },
      { flag: 'PID', desc: 'wait for one specific background job/process, and return its exit status' },
    ],
    examples: [
      { cmd: 'cmd & wait', desc: 'start in background, then wait for it before continuing' },
      { cmd: 'cmd1 & p1=$!; cmd2 & p2=$!; wait $p1 $p2', desc: 'run two jobs in parallel, wait for both' },
    ] },
  '$!': { name: '$!', desc: 'The PID of the most recently started background job.' },
  '$$': { name: '$$', desc: 'The PID of the current shell (or script).' },
  bashpid: { name: '$BASHPID', desc: 'The PID of the current bash *process* — unlike `$$`, this changes inside a subshell.' },
  sleep: { name: 'sleep', desc: 'Pauses for a given number of seconds (decimals allowed, e.g. `sleep 0.5`).' },
  trap: { name: 'trap', desc: "Runs a command when the shell receives a signal, e.g. `trap 'cleanup' EXIT`." },

  // ---- navigation & files ----
  cd: { name: 'cd', desc: 'Changes the current directory. No argument goes to $HOME; `cd -` goes to the previous directory.',
    usage: 'cd [directory]',
    options: [
      { flag: '(no argument)', desc: 'go to $HOME' },
      { flag: '-', desc: 'go to the previous directory ($OLDPWD)' },
      { flag: '-P', desc: 'resolve symlinks instead of keeping a logical path' },
    ],
    examples: [
      { cmd: 'cd /var/log', desc: 'go to an absolute path' },
      { cmd: 'cd ..', desc: 'go up one directory' },
      { cmd: 'cd -', desc: 'toggle back to the previous directory' },
    ] },
  pwd: { name: 'pwd', desc: 'Prints the current directory\'s absolute path.' },
  mkdir: { name: 'mkdir', desc: 'Creates directories. `-p` also creates missing parent directories and does not error if the target already exists.',
    usage: 'mkdir [options] directory...',
    options: [
      { flag: '-p', desc: 'also create missing parent directories; no error if the target already exists' },
      { flag: '-m MODE', desc: 'set permissions on the new directory (like chmod)' },
      { flag: '-v', desc: 'print a message for each directory created' },
    ],
    examples: [
      { cmd: 'mkdir project', desc: 'create one directory' },
      { cmd: 'mkdir -p a/b/c', desc: 'create nested directories in one call' },
      { cmd: 'mkdir -m 700 private', desc: 'create with restrictive permissions' },
    ] },
  rmdir: { name: 'rmdir', desc: 'Removes a directory, but only if it is empty.' },
  ls: { name: 'ls', desc: 'Lists directory contents. `-a` shows hidden entries, `-l` long format, `-R` recursive, `-S`/`-t` sort by size/time, `-d` list a directory itself, not its content.',
    usage: 'ls [options] [file...]',
    options: [
      { flag: '-a', desc: 'show hidden entries (dotfiles)' },
      { flag: '-l', desc: 'long format: permissions, owner, size, date' },
      { flag: '-R', desc: 'list subdirectories recursively' },
      { flag: '-S / -t', desc: 'sort by size / by modification time' },
      { flag: '-d', desc: 'list a directory itself, not its contents' },
      { flag: '-h', desc: 'with -l, show human-readable sizes' },
    ],
    examples: [
      { cmd: 'ls -la', desc: 'long listing including hidden files' },
      { cmd: 'ls -lt', desc: 'newest files first' },
      { cmd: 'ls -d */', desc: 'list only top-level directories' },
    ] },
  tree: { name: 'tree', desc: 'Prints a directory as an indented tree. `-L n` limits depth, `-d` directories only, `-a` includes hidden files, `-P pattern` keeps only matches, `--prune` drops directories left empty by that filter.' },
  du: { name: 'du', desc: 'Reports disk usage of files/directories. `-s` a single total, `-h` human-readable sizes, `-a` files too (not just directories).' },
  df: { name: 'df', desc: 'Reports free/used space of mounted filesystems.' },
  stat: { name: 'stat', desc: "Shows a file's metadata (size, permissions, owner, timestamps, inode, link count). `-c FORMAT` picks which fields to print, e.g. `%s` size, `%a` octal permissions, `%h` link count.",
    usage: 'stat [options] file...',
    options: [
      { flag: '-c FORMAT', desc: 'choose which fields to print instead of the default report' },
      { flag: '%s', desc: 'size in bytes' },
      { flag: '%a', desc: 'permissions in octal' },
      { flag: '%h', desc: 'number of hard links' },
      { flag: '%U / %G', desc: 'owner / group name' },
      { flag: '%Y', desc: 'last modification time as a Unix timestamp' },
    ],
    examples: [
      { cmd: "stat -c '%s %n' file", desc: 'print size and name' },
      { cmd: "stat -c '%a' file", desc: 'permissions in octal, e.g. 644' },
      { cmd: "stat -c '%h' file", desc: 'how many hard links point to it' },
    ] },
  touch: { name: 'touch', desc: 'Updates a file\'s timestamps, creating an empty file if it does not exist. `-d "date"` sets an arbitrary time.' },
  file: { name: 'file', desc: "Guesses a file's type by inspecting its content, not just its name." },
  mktemp: { name: 'mktemp', desc: 'Creates a uniquely-named temporary file (or `-d` a directory) and prints its path.' },

  // ---- copying, moving, links ----
  cp: { name: 'cp', desc: 'Copies files. `-r` recursively (for directories), `-a` preserves attributes/links, `-p` preserves mode/timestamps.',
    usage: 'cp [options] source... destination',
    options: [
      { flag: '-r', desc: 'copy directories recursively' },
      { flag: '-a', desc: 'archive mode: preserve permissions, timestamps, links, and recurse' },
      { flag: '-p', desc: 'preserve mode/ownership/timestamps' },
      { flag: '-i', desc: 'prompt before overwriting an existing file' },
      { flag: '-u', desc: 'only copy when the source is newer than the destination' },
    ],
    examples: [
      { cmd: 'cp file.txt backup/', desc: 'copy a file into a directory' },
      { cmd: 'cp -r src/ dst/', desc: 'copy a directory tree' },
      { cmd: 'cp -a project/ project-copy/', desc: 'copy preserving everything' },
    ] },
  mv: { name: 'mv', desc: 'Renames or moves files/directories.',
    usage: 'mv [options] source... destination',
    options: [
      { flag: '-i', desc: 'prompt before overwriting an existing file' },
      { flag: '-n', desc: 'never overwrite an existing file' },
      { flag: '-u', desc: 'only move when the source is newer than an existing destination' },
    ],
    examples: [
      { cmd: 'mv old.txt new.txt', desc: 'rename a file' },
      { cmd: 'mv file.txt dir/', desc: 'move a file into a directory' },
      { cmd: 'mv -n *.log archive/', desc: 'move without clobbering existing files' },
    ] },
  rm: { name: 'rm', desc: 'Deletes files. `-r` recursively for directories, `-f` never asks/errors on missing files.',
    usage: 'rm [options] file...',
    options: [
      { flag: '-r', desc: 'remove directories and their contents recursively' },
      { flag: '-f', desc: 'never prompt, ignore missing files' },
      { flag: '-i', desc: 'prompt before every removal' },
    ],
    examples: [
      { cmd: 'rm file.txt', desc: 'delete a file' },
      { cmd: 'rm -rf build/', desc: 'force-delete a directory tree' },
      { cmd: 'rm -i *.log', desc: 'confirm before deleting each match' },
    ] },
  ln: { name: 'ln', desc: 'Creates a link. By default a hard link (another name for the same data); `-s` creates a symbolic link (a pointer to a path, which breaks if that path is removed).',
    usage: 'ln [options] target link_name',
    options: [
      { flag: '-s', desc: 'create a symbolic link instead of a hard link' },
      { flag: '-f', desc: 'remove an existing destination first, if needed' },
    ],
    examples: [
      { cmd: 'ln -s /path/to/real link', desc: 'create a symlink' },
      { cmd: 'ln file.txt file2.txt', desc: 'create a hard link (same inode)' },
      { cmd: 'ln -sf newtarget existinglink', desc: 'repoint an existing symlink' },
    ] },
  readlink: { name: 'readlink', desc: "Prints a symbolic link's target. `-f` resolves the whole chain to a final absolute, canonical path.",
    usage: 'readlink [options] file',
    options: [
      { flag: '-f', desc: 'resolve the whole chain of symlinks to a final absolute, canonical path' },
      { flag: '-e', desc: 'like -f but requires the final target to exist' },
    ],
    examples: [
      { cmd: 'readlink link', desc: 'print what the symlink points to (one level)' },
      { cmd: 'readlink -f link', desc: 'fully resolved absolute path' },
    ] },
  basename: { name: 'basename', desc: 'Strips the directory part (and, if given, a suffix) from a path, leaving just the file name.',
    usage: 'basename PATH [SUFFIX]',
    options: [
      { flag: 'SUFFIX', desc: "if PATH ends with SUFFIX, it's also stripped" },
      { flag: '-a', desc: 'process multiple PATH arguments at once' },
    ],
    examples: [
      { cmd: 'basename /usr/bin/bash', desc: 'prints "bash"' },
      { cmd: 'basename file.tar.gz .tar.gz', desc: 'prints "file"' },
      { cmd: 'basename -a /a/x /b/y', desc: 'prints "x" then "y"' },
    ] },
  dirname: { name: 'dirname', desc: "Prints a path's directory part, dropping the final component.",
    usage: 'dirname PATH',
    examples: [
      { cmd: 'dirname /usr/bin/bash', desc: 'prints "/usr/bin"' },
      { cmd: 'dirname file.txt', desc: 'prints "."' },
      { cmd: 'dir=$(dirname "$path")', desc: "capture a path's directory into a variable" },
    ] },

  // ---- archives / compression ----
  tar: { name: 'tar', desc: 'Bundles files into one archive (and can extract them). `-c` create, `-x` extract, `-t` list, `-r` append, `-f FILE` the archive file, `-z`/`-j`/`-J` compress with gzip/bzip2/xz, `-v` verbose, `-C dir` change directory first, `-O` extract to stdout.',
    usage: 'tar [options] -f archive.tar [file...]',
    options: [
      { flag: '-c', desc: 'create a new archive' },
      { flag: '-x', desc: 'extract an archive' },
      { flag: '-t', desc: "list an archive's contents without extracting" },
      { flag: '-f FILE', desc: 'the archive file to operate on (almost always needed)' },
      { flag: '-z / -j / -J', desc: 'also compress/decompress with gzip / bzip2 / xz' },
      { flag: '-C DIR', desc: 'change to DIR before adding/extracting' },
    ],
    examples: [
      { cmd: 'tar -czf out.tar.gz dir/', desc: 'create a gzip-compressed archive' },
      { cmd: 'tar -xzf out.tar.gz', desc: 'extract a .tar.gz archive' },
      { cmd: 'tar -tf out.tar', desc: 'list contents without extracting' },
      { cmd: 'tar -xzf out.tar.gz -C /tmp', desc: 'extract into a specific directory' },
    ] },
  gzip: { name: 'gzip', desc: 'Compresses a file in place (replacing it with a `.gz`). `-d` decompress, `-k` keep the original, `-r` recurse into directories, `-9` best compression.' },
  gunzip: { name: 'gunzip', desc: 'Decompresses a `.gz` file (same as `gzip -d`).' },
  zcat: { name: 'zcat', desc: 'Prints the decompressed content of a `.gz` file without writing anything to disk.' },
  bzip2: { name: 'bzip2', desc: 'Compresses a file into `.bz2`, generally smaller but slower than gzip. `-k` keeps the original, `-d` decompresses.' },
  bunzip2: { name: 'bunzip2', desc: 'Decompresses a `.bz2` file.' },
  xz: { name: 'xz', desc: 'Compresses a file into `.xz`, usually the smallest of the common formats. `-k` keeps the original, `-d` decompresses, `-9` best compression.' },
  compress: { name: 'compress', desc: 'The classic Unix compressor, producing a `.Z` file.' },
  uncompress: { name: 'uncompress', desc: 'Decompresses a `.Z` file.' },

  // ---- text filters ----
  cat: { name: 'cat', desc: "Prints a file's content. With several files, concatenates them. `-n` numbers lines.",
    usage: 'cat [options] [file...]',
    options: [
      { flag: '-n', desc: 'number all output lines' },
      { flag: '-A', desc: 'show non-printing characters (tabs as ^I, line ends as $)' },
      { flag: '-s', desc: 'squeeze multiple blank lines into one' },
    ],
    examples: [
      { cmd: 'cat file.txt', desc: "print a file's content" },
      { cmd: 'cat a.txt b.txt > combined.txt', desc: 'concatenate two files into one' },
      { cmd: 'cat -n script.sh', desc: 'print with line numbers' },
    ] },
  head: { name: 'head', desc: "Prints a file's first lines (`-n N`) or bytes (`-c N`). `-n -N` prints everything except the last N lines.",
    usage: 'head [options] [file...]',
    options: [
      { flag: '-n N', desc: 'print the first N lines (default 10)' },
      { flag: '-n -N', desc: 'print everything EXCEPT the last N lines' },
      { flag: '-c N', desc: 'print the first N bytes instead of lines' },
    ],
    examples: [
      { cmd: 'head -n 5 file', desc: 'first 5 lines' },
      { cmd: 'head -c 100 file', desc: 'first 100 bytes' },
      { cmd: 'ls | head -n -1', desc: 'everything except the last item' },
    ] },
  tail: { name: 'tail', desc: "Prints a file's last lines (`-n N`) or bytes (`-c N`). `-n +N` starts printing from line N onward.",
    usage: 'tail [options] [file...]',
    options: [
      { flag: '-n N', desc: 'print the last N lines (default 10)' },
      { flag: '-n +N', desc: 'start printing from line N to the end' },
      { flag: '-c N', desc: 'print the last N bytes instead of lines' },
      { flag: '-f', desc: "keep the file open and print new lines as they're appended" },
    ],
    examples: [
      { cmd: 'tail -n 20 file', desc: 'last 20 lines' },
      { cmd: 'tail -f /var/log/syslog', desc: 'follow a log file live' },
      { cmd: 'tail -n +2 file', desc: 'everything except the first line (skip a header)' },
    ] },
  wc: { name: 'wc', desc: 'Counts lines (`-l`), words (`-w`) or bytes/characters (`-c`/`-m`) of its input.',
    usage: 'wc [options] [file...]',
    options: [
      { flag: '-l', desc: 'count lines' },
      { flag: '-w', desc: 'count words' },
      { flag: '-c', desc: 'count bytes' },
      { flag: '-m', desc: 'count characters (differs from -c with multibyte text)' },
      { flag: '-L', desc: 'print the length of the longest line' },
    ],
    examples: [
      { cmd: 'wc -l file.txt', desc: 'number of lines in a file' },
      { cmd: "find . -name '*.sh' | wc -l", desc: 'count how many files matched' },
      { cmd: 'wc -l < file.txt', desc: 'count lines without printing the filename' },
    ] },
  cut: { name: 'cut', desc: "Extracts columns from each line. `-d` sets the field delimiter, `-f` picks field numbers, `-c` picks character positions.",
    usage: 'cut -d DELIM -f LIST [file...]   (or)   cut -c LIST [file...]',
    options: [
      { flag: '-d CHAR', desc: 'set the field delimiter (default: tab)' },
      { flag: '-f LIST', desc: 'comma/range list of fields to keep, e.g. 1,3 or 2-4' },
      { flag: '-c LIST', desc: 'character positions to keep, instead of fields' },
      { flag: '--complement', desc: 'keep everything EXCEPT the selected fields' },
      { flag: '-s', desc: "with -f, skip lines that don't contain the delimiter" },
    ],
    examples: [
      { cmd: 'cut -d: -f1 /etc/passwd', desc: 'list all usernames' },
      { cmd: 'cut -c1-5 file', desc: 'first 5 characters of each line' },
      { cmd: 'cut -d, -f2,4 data.csv', desc: '2nd and 4th CSV columns' },
    ] },
  sort: { name: 'sort', desc: "Sorts lines. `-n`/`-h` numeric/human-readable comparison, `-r` reverse, `-u` drop duplicates, `-t` field delimiter, `-k N` sort by field N.",
    usage: 'sort [options] [file...]',
    options: [
      { flag: '-n', desc: 'compare fields as numbers, not text' },
      { flag: '-h', desc: 'compare human-readable sizes (1K, 2M, 3G)' },
      { flag: '-r', desc: 'reverse the sort order' },
      { flag: '-u', desc: 'drop duplicate lines after sorting' },
      { flag: '-t CHAR', desc: 'set the field delimiter (default: whitespace)' },
      { flag: '-k N[,M]', desc: 'sort by field N (through field M), instead of the whole line' },
    ],
    examples: [
      { cmd: 'sort -n numbers.txt', desc: 'numeric ascending sort' },
      { cmd: 'sort -t: -k3,3n /etc/passwd', desc: 'sort by the numeric UID field' },
      { cmd: 'sort -ru names.txt', desc: 'unique lines, reverse alphabetical order' },
      { cmd: 'sort file1 file2 | uniq -c', desc: 'merge two files and count duplicate lines' },
    ] },
  uniq: { name: 'uniq', desc: "Collapses ADJACENT duplicate lines (so input is usually sorted first). `-c` prefixes each line with its count, `-d` shows only lines that repeated.",
    usage: 'uniq [options] [input [output]]',
    options: [
      { flag: '-c', desc: 'prefix each line with the number of times it repeated' },
      { flag: '-d', desc: 'print only lines that had duplicates' },
      { flag: '-u', desc: 'print only lines that were NOT duplicated' },
      { flag: '-i', desc: 'ignore case when comparing' },
    ],
    examples: [
      { cmd: 'sort file | uniq -c', desc: 'count occurrences of each distinct line' },
      { cmd: 'sort file | uniq -d', desc: 'show only values that appear more than once' },
      { cmd: 'sort file | uniq -c | sort -rn', desc: 'most frequent lines first' },
    ] },
  tr: { name: 'tr', desc: "Translates or deletes characters from stdin. `tr a-z A-Z` maps ranges; `-d` deletes characters; `-s` squeezes runs of repeats into one.",
    usage: 'tr [options] SET1 [SET2]',
    options: [
      { flag: 'SET1 SET2', desc: 'maps each character in SET1 to the character at the same position in SET2' },
      { flag: '-d SET1', desc: 'delete characters in SET1, no SET2 needed' },
      { flag: '-s SET1', desc: 'squeeze runs of repeated characters in SET1 into one' },
      { flag: '-c SET1', desc: 'complement: operate on characters NOT in SET1' },
    ],
    examples: [
      { cmd: "tr 'a-z' 'A-Z'", desc: 'uppercase everything read from stdin' },
      { cmd: "tr -d '\\n'", desc: 'remove all newlines' },
      { cmd: "tr -s ' '", desc: 'collapse repeated spaces into one' },
      { cmd: "echo \"$s\" | tr -cd '0-9'", desc: 'keep only digits' },
    ] },
  sed: { name: 'sed', desc: "A stream editor. `s/old/new/` substitutes (add `g` for every match on the line); `/pattern/d` deletes matching lines; `-n 'N,Mp'` prints only a line range; `-i` edits the file in place.",
    usage: "sed [options] 'script' [file...]",
    options: [
      { flag: 's/old/new/', desc: 'substitute the first match per line (append g to replace every match)' },
      { flag: '/pattern/d', desc: 'delete lines matching pattern' },
      { flag: "-n 'N,Mp'", desc: 'print only lines N through M (needs -n to suppress the default output)' },
      { flag: '-i', desc: 'edit the file in place (e.g. -i.bak keeps a backup with that suffix)' },
      { flag: '-e SCRIPT', desc: "add another script/expression, to combine several -e's" },
    ],
    examples: [
      { cmd: "sed 's/foo/bar/g' file", desc: 'replace every foo with bar' },
      { cmd: "sed -n '2,4p' file", desc: 'print only lines 2 through 4' },
      { cmd: "sed -i '/^#/d' file", desc: 'delete comment lines in place' },
      { cmd: "sed 's/^/> /' file", desc: 'prefix every line with "> "' },
    ] },
  tee: { name: 'tee', desc: 'Copies stdin to both stdout and a file (or several, and `-a` to append) at once.' },
  nl: { name: 'nl', desc: 'Numbers the lines of a file (skipping blank lines by default, unlike `cat -n`).' },
  tac: { name: 'tac', desc: "Prints a file's lines in reverse order (`cat` backwards)." },
  paste: { name: 'paste', desc: 'Joins the corresponding lines of several files side by side, separated by tab (or `-d` a custom character).',
    usage: 'paste [options] file...',
    options: [
      { flag: '-d CHAR', desc: 'use CHAR instead of tab to join columns' },
      { flag: '-s', desc: "merge each file's lines into a single line instead of side by side" },
    ],
    examples: [
      { cmd: 'paste names.txt scores.txt', desc: 'join two files column by column' },
      { cmd: 'paste -d, a.txt b.txt', desc: 'join with a comma instead of tab' },
      { cmd: 'paste -s -d+ nums.txt | bc', desc: 'join numbers with + then evaluate' },
    ] },
  diff: { name: 'diff', desc: 'Shows the differences between two files, line by line. `-q` only says whether they differ, `-r` compares directories recursively.' },
  cmp: { name: 'cmp', desc: 'Compares two files byte by byte; silent (just an exit code) with `-s`.',
    usage: 'cmp [options] file1 file2',
    options: [
      { flag: '-s', desc: 'silent: report only via exit status, no message' },
      { flag: '-l', desc: 'list every differing byte position and its value in both files' },
    ],
    examples: [
      { cmd: 'cmp -s a b && echo identical', desc: 'check without printing anything' },
      { cmd: 'cmp file1 file2', desc: 'reports the first byte/line where they differ' },
    ] },
  od: { name: 'od', desc: 'Dumps a file in octal, hex or another base — useful for seeing bytes a text viewer would hide.' },
  split: { name: 'split', desc: 'Splits a file into smaller pieces. `-l N` by number of lines, `-d` numeric suffixes.' },

  // ---- search ----
  grep: { name: 'grep', desc: "Prints the lines of its input that match a pattern. `-i` ignore case, `-v` invert (non-matching lines), `-c` count only, `-n` show line numbers, `-o` print only the matched part, `-w`/`-x` match a whole word/line, `-r` recurse into directories, `-E` use extended regular expressions, `-F` treat the pattern as a literal string.",
    usage: 'grep [options] PATTERN [file...]',
    options: [
      { flag: '-i', desc: 'ignore case when matching' },
      { flag: '-v', desc: 'invert: print lines that do NOT match' },
      { flag: '-c', desc: 'print only a count of matching lines' },
      { flag: '-n', desc: 'prefix each match with its line number' },
      { flag: '-o', desc: 'print only the matched part of the line, not the whole line' },
      { flag: '-w / -x', desc: 'match a whole word / a whole line only' },
      { flag: '-r / -R', desc: 'recurse into directories' },
      { flag: '-E', desc: 'use extended regular expressions (+, ?, |, () need no backslash)' },
      { flag: '-l', desc: 'print only the names of files that contain a match' },
    ],
    examples: [
      { cmd: "grep -n 'error' app.log", desc: 'show matching lines with their line numbers' },
      { cmd: "grep -v '^#' config", desc: 'show every line except comments' },
      { cmd: "grep -rl 'TODO' src/", desc: 'list files under src/ that contain TODO' },
      { cmd: "grep -Eo '[0-9]+' file", desc: 'print just the numbers found on each line' },
    ] },
  find: { name: 'find', desc: "Searches a directory tree for files matching conditions: `-name`, `-iname` (case-insensitive), `-type f/d`, `-size`, `-perm`, `-mtime`, `-newer`, `-maxdepth`/`-mindepth`. `-exec cmd {} \\;` runs a command per match; `-delete` removes matches.",
    usage: 'find [path...] [expression]',
    options: [
      { flag: '-name PATTERN', desc: 'match by filename (glob), case-sensitive; -iname is the case-insensitive version' },
      { flag: '-type f|d|l', desc: 'restrict to regular files, directories, or symbolic links' },
      { flag: '-size [+-]N[c|k|M]', desc: 'match by size; + larger than N, - smaller than N (c=bytes, k=KB, M=MB)' },
      { flag: '-mtime [+-]N', desc: 'modified more than (+) or less than (-) N days ago' },
      { flag: '-maxdepth / -mindepth N', desc: 'limit how many directory levels to descend' },
      { flag: '-exec CMD {} \\;', desc: "run CMD once per match, with {} replaced by the match's path" },
      { flag: '-delete', desc: 'remove each match — put it last, after the filters that select what to delete' },
    ],
    examples: [
      { cmd: "find . -name '*.txt'", desc: 'all .txt files under the current directory' },
      { cmd: 'find . -type d -empty', desc: 'empty directories' },
      { cmd: "find . -name '*.log' -delete", desc: 'delete every matching file' },
      { cmd: 'find . -type f -print0 | xargs -0 wc -l', desc: 'safely handle filenames containing spaces' },
    ] },
  xargs: { name: 'xargs', desc: "Builds and runs a command using arguments read from stdin (one call per batch, not one per line, unless `-n1`). `-I{}` substitutes each input into a placeholder; `-0` expects NUL-separated input (pair with `find -print0`).",
    usage: 'xargs [options] [command]',
    options: [
      { flag: '-n N', desc: 'pass at most N arguments per invocation of command' },
      { flag: '-I{}', desc: 'replace {} in command with each input item (one call per line)' },
      { flag: '-0', desc: 'expect NUL-separated input instead of whitespace/newline (pair with find -print0)' },
      { flag: '-r', desc: "don't run command at all if there was no input" },
    ],
    examples: [
      { cmd: "find . -name '*.tmp' -print0 | xargs -0 rm", desc: 'safely delete matches, even with spaces in names' },
      { cmd: 'echo "a b c" | xargs -n1 echo', desc: 'one argument per line' },
      { cmd: 'ls *.txt | xargs -I{} cp {} backup/', desc: 'copy each file individually' },
    ] },

  // ---- permissions ----
  chmod: { name: 'chmod', desc: "Changes permissions. Symbolic form: `u/g/o/a` `+/-/=` `r/w/x` (e.g. `u+x`). Octal form: three digits, one per r/w/x group (e.g. `755`). `-R` recurses into directories.",
    usage: 'chmod MODE file...',
    options: [
      { flag: 'u/g/o/a', desc: 'user / group / others / all' },
      { flag: '+ / - / =', desc: 'add, remove, or set permissions exactly' },
      { flag: 'r/w/x', desc: 'read, write, execute' },
      { flag: 'OCTAL', desc: 'three digits, one per class (e.g. 755 = rwxr-xr-x)' },
      { flag: '-R', desc: 'apply recursively to a directory tree' },
      { flag: 'X', desc: 'set execute on directories, or on files that already have it for someone' },
    ],
    examples: [
      { cmd: 'chmod +x script.sh', desc: 'make a file executable for everyone' },
      { cmd: 'chmod 644 file', desc: 'owner read/write, others read-only' },
      { cmd: 'chmod -R g+w dir/', desc: 'recursively grant the group write access' },
      { cmd: 'chmod u=rwx,g=rx,o= file', desc: 'set exact permissions per class' },
    ] },
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
  echo: { name: 'echo', desc: 'Prints its arguments. `-n` omits the trailing newline, `-e` interprets escapes like `\\t`/`\\n`.',
    usage: 'echo [options] [string...]',
    options: [
      { flag: '-n', desc: 'omit the trailing newline' },
      { flag: '-e', desc: 'interpret backslash escapes like \\n, \\t (off by default)' },
    ],
    examples: [
      { cmd: 'echo "Hello, $USER"', desc: 'print with variable expansion' },
      { cmd: 'echo -n "no newline"', desc: 'print without a trailing newline' },
      { cmd: 'echo -e "line1\\nline2"', desc: 'interpret \\n as a real newline' },
    ] },
  printf: { name: 'printf', desc: 'Prints formatted text using a format string (`%s`, `%d`, `%x`...), like the C function. Unlike `echo`, it never adds a newline on its own.',
    usage: "printf 'FORMAT' [arguments...]",
    options: [
      { flag: '%s', desc: 'string' },
      { flag: '%d / %i', desc: 'integer' },
      { flag: '%x / %o', desc: 'hexadecimal / octal' },
      { flag: '%-10s', desc: 'left-justify a string in a 10-character field' },
      { flag: '%05d', desc: 'zero-pad a number to 5 digits' },
      { flag: '\\n \\t', desc: 'newline, tab — interpreted inside the format string' },
    ],
    examples: [
      { cmd: "printf '%s\\n' \"$var\"", desc: 'print a value with a trailing newline' },
      { cmd: "printf '%-10s%5d\\n' name 42", desc: 'column-aligned output' },
      { cmd: "printf '%03d\\n' 7", desc: 'prints 007' },
      { cmd: 'printf \'%s\\n\' "${arr[@]}"', desc: "print each array element on its own line" },
    ] },
  read: { name: 'read', desc: "Reads one line from standard input into one or more variables, splitting on IFS. `-r` disables backslash escaping, `-p` shows a prompt, `-a` reads into an array.",
    usage: 'read [options] var...',
    options: [
      { flag: '-r', desc: "don't let backslashes escape characters (almost always wanted)" },
      { flag: '-p PROMPT', desc: 'display PROMPT before reading, without a newline' },
      { flag: '-a ARRAY', desc: 'read words into an array instead of separate variables' },
      { flag: '-s', desc: "silent: don't echo input (for passwords)" },
      { flag: '-t N', desc: 'time out after N seconds' },
    ],
    examples: [
      { cmd: 'read -r line', desc: 'read one line into $line' },
      { cmd: 'IFS=: read -r user pass uid < /etc/passwd', desc: 'split a line into named variables' },
      { cmd: 'read -p "Name: " name', desc: 'prompt, then read into $name' },
      { cmd: 'read -ra parts <<< "$line"', desc: 'split a string into an array' },
    ] },
  ifs: { name: 'IFS', desc: 'The shell variable listing the characters used to split words/fields, e.g. `while IFS=: read ...` splits on colons.' },
  export: { name: 'export', desc: 'Marks a variable (or function, with `-f`) so that it is inherited by child processes.' },
  unset: { name: 'unset', desc: 'Removes a variable or function.' },
  env: { name: 'env', desc: 'Prints the current environment variables, or runs a command with a modified environment.' },
  printenv: { name: 'printenv', desc: 'Prints environment variables (only those that are exported).' },
  source: { name: 'source (or `.`)', desc: 'Runs a script in the *current* shell instead of a new subshell, so its variable/directory changes persist afterwards.' },
  expr: { name: 'expr', desc: 'Evaluates an expression (arithmetic, string) given as separate arguments, e.g. `expr 3 + 4`.' },
  bc: { name: 'bc', desc: 'An arbitrary-precision calculator that reads expressions from stdin; `scale=N` sets the number of decimals.' },
  seq: { name: 'seq', desc: 'Prints a sequence of numbers, e.g. `seq 1 2 10` (start, step, end).',
    usage: 'seq [first [increment]] last',
    options: [
      { flag: '-s SEP', desc: 'separator between numbers (default: newline)' },
      { flag: '-w', desc: 'pad numbers with leading zeros so they align' },
    ],
    examples: [
      { cmd: 'seq 5', desc: 'prints 1 2 3 4 5, one per line' },
      { cmd: 'seq 2 2 10', desc: 'even numbers from 2 to 10' },
      { cmd: 'seq -s, 1 3', desc: 'prints "1,2,3"' },
    ] },
  date: { name: 'date', desc: "Prints (or with `-d` parses) a date/time. `+FORMAT` customises the output, e.g. `date +%Y-%m-%d`." },
  '$(( ))': { name: '$(( expression ))', desc: 'Evaluates an integer arithmetic expression and substitutes its value, e.g. `$((3 * 4))`.',
    usage: '$(( expression ))',
    examples: [
      { cmd: 'echo $((3 * 4 + 2))', desc: 'arithmetic evaluated and substituted' },
      { cmd: 'n=$((n + 1))', desc: 'increment a counter' },
    ] },
  '$( )': { name: '$( command )', desc: "Command substitution: runs a command and substitutes its output as text. `` `command` `` is the older, equivalent syntax." },
  '$(func)': { name: '$(function)', desc: 'Calling a function inside `$( )` captures whatever it prints, letting a function "return" data (as opposed to `return`, which only sets a 0-255 exit code).' },
  '${...}': { name: '${VAR}', desc: 'Braces around a variable name disambiguate it from surrounding text, and enable expansions like `${VAR:-default}`, `${VAR#prefix}`, `${VAR%suffix}`, `${VAR/old/new}`, `${VAR:offset:length}`.' },
  quoting: { name: 'quoting', desc: 'Double quotes `"..."` still expand `$variables` and `$(...)` but protect spaces/globs; single quotes `\'...\'` take everything literally.' },
  arrays: { name: 'arrays', desc: 'Bash arrays: `a=(x y z)`, `${a[0]}` an element, `${a[@]}` all elements, `${#a[@]}` the count, `a+=(w)` to append.' },

  // ---- script parameters ----
  '$#': { name: '$#', desc: 'The number of arguments passed to the script or function.',
    examples: [
      { cmd: 'if [ "$#" -lt 1 ]; then echo usage; fi', desc: 'require at least one argument' },
    ] },
  '$@': { name: '$@', desc: 'All arguments, each preserved as a separate word — use it quoted, `"$@"`, to keep multi-word arguments intact.' },
  '$*': { name: '$*', desc: 'All arguments joined into a single word when quoted (`"$*"`), unlike `"$@"`.' },
  '$0': { name: '$0', desc: "The script's own name (or path) as it was invoked." },
  '$?': { name: '$?', desc: 'The exit status of the last command (0 means success).' },
  'exit codes': { name: 'exit codes', desc: 'A script or command ends with a number from 0 to 255: 0 means success, anything else signals a specific kind of failure, checked via `$?` or `if command; then`.',
    examples: [
      { cmd: 'if grep -q pattern file; then echo found; fi', desc: "use a command's exit status directly in a condition" },
      { cmd: 'cmd; if [ $? -ne 0 ]; then echo failed; fi', desc: 'check $? explicitly after the fact' },
      { cmd: 'exit 1', desc: 'end a script with a specific non-zero status' },
    ] },
  shift: { name: 'shift', desc: 'Drops `$1` and renumbers the remaining positional parameters down by one (or by `N`, given an argument).',
    usage: 'shift [N]',
    options: [
      { flag: 'N', desc: 'number of positions to shift (default 1)' },
    ],
    examples: [
      { cmd: 'while [ "$#" -gt 0 ]; do echo "$1"; shift; done', desc: 'process each argument in turn' },
      { cmd: 'shift 2', desc: 'drop the first two positional parameters' },
    ] },

  // ---- conditionals ----
  test: { name: 'test (or `[ ]`)', desc: 'Evaluates a condition and returns an exit status accordingly: 0 (true) or 1 (false). `[ expr ]` is the same command spelled differently.',
    usage: '[ expression ]  (or:  test expression)',
    options: [
      { flag: '-e FILE', desc: 'true if FILE exists' },
      { flag: '-f / -d FILE', desc: 'true if FILE exists and is a regular file / a directory' },
      { flag: '-z / -n STRING', desc: 'true if STRING is empty / non-empty' },
      { flag: '-eq -ne -lt -le -gt -ge', desc: 'numeric comparisons between two integers' },
      { flag: '= / !=', desc: 'string equality / inequality' },
    ],
    examples: [
      { cmd: '[ -f "$f" ] && echo exists', desc: 'check a file exists before using it' },
      { cmd: '[ "$n" -gt 0 ]', desc: 'numeric comparison' },
      { cmd: '[ -z "$var" ] && echo empty', desc: 'check a variable is unset or empty' },
      { cmd: '[ "$a" = "$b" ]', desc: 'string equality test' },
    ] },
  '[[ ]]': { name: '[[ ]]', desc: "Bash's extended conditional: safer word-splitting than `[ ]`, plus glob matching (`==`) and regex matching (`=~`)." },
  '[[ =~ ]]': { name: '[[ $x =~ regex ]]', desc: 'Tests a string against an extended regular expression inside `[[ ]]`; captured groups become available in `${BASH_REMATCH[@]}`.',
    usage: '[[ STRING =~ REGEX ]]',
    examples: [
      { cmd: '[[ "$ip" =~ ^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$ ]]', desc: 'check a string looks like an IPv4 address' },
      { cmd: '[[ "$x" =~ ^([a-z]+)-([0-9]+)$ ]] && echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"', desc: 'capture groups from a match' },
    ] },
  '(( ))': { name: '(( expression ))', desc: 'Evaluates an arithmetic expression as a condition — true if it evaluates to non-zero, e.g. `(( x > 10 ))`.' },
  case: { name: 'case', desc: 'Matches a value against a list of glob-style patterns, running the commands under the first one that matches.',
    usage: 'case VALUE in\n  PATTERN) commands ;;\n  ...\nesac',
    options: [
      { flag: '*)', desc: 'a default/catch-all pattern, usually last' },
      { flag: 'pat1|pat2)', desc: 'matches either pattern' },
    ],
    examples: [
      { cmd: 'case "$1" in\n  start) ... ;;\n  stop) ... ;;\n  *) echo usage ;;\nesac', desc: 'branch on a value' },
      { cmd: 'case "$ext" in *.jpg|*.png) echo image ;; esac', desc: 'match one of several glob patterns' },
    ] },

  // ---- loops & functions ----
  for: { name: 'for', desc: '`for x in list; do ...; done` runs a block once per item; `for ((i=0;i<n;i++))` is the C-style counting form.',
    usage: 'for var in list; do commands; done\nfor ((init; cond; incr)); do commands; done',
    examples: [
      { cmd: 'for f in *.txt; do echo "$f"; done', desc: 'loop over matching files' },
      { cmd: 'for ((i=0; i<5; i++)); do echo "$i"; done', desc: 'C-style counting loop' },
      { cmd: 'for i in {1..10}; do echo "$i"; done', desc: 'loop over a brace-expanded range' },
    ] },
  while: { name: 'while', desc: 'Repeats a block for as long as a condition (often `read line` or `test ...`) keeps succeeding.',
    usage: 'while CONDITION; do commands; done',
    examples: [
      { cmd: 'while read -r line; do echo "$line"; done < file', desc: 'process a file line by line' },
      { cmd: 'while [ "$n" -lt 10 ]; do n=$((n+1)); done', desc: 'loop while a condition holds' },
    ] },
  until: { name: 'until', desc: 'Like `while`, but repeats for as long as the condition keeps *failing*.' },
  select: { name: 'select', desc: 'Shows a numbered menu built from a list and repeatedly reads a choice into a variable.' },
  break: { name: 'break', desc: 'Exits the innermost enclosing loop immediately.' },
  continue: { name: 'continue', desc: 'Skips to the next iteration of the innermost enclosing loop.' },
  functions: { name: 'functions', desc: 'Defined as `name() { ...; }`. Arguments become `$1`, `$2`, `"$@"` *inside* the function, separate from the script\'s own. `local` keeps a variable from leaking out.' },
  local: { name: 'local', desc: "Declares a variable scoped to the current function, instead of the whole script.",
    usage: 'local [name[=value] ...]',
    examples: [
      { cmd: 'local i', desc: 'declare i as local to the current function' },
      { cmd: 'local result=0', desc: 'declare and initialize in one step' },
    ] },
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
  ';': { name: '; (command separator)', desc: 'Separates commands on the same line, run one after another regardless of whether the previous one succeeded.' },
  '`...`': { name: '`command` (backtick substitution)', desc: 'The older syntax for command substitution — runs a command and substitutes its output as text. `$(command)` is the modern, equivalent form.' },
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
// Each fallback carries its own canonical key, so two different raw tokens matched by the same
// rule (e.g. "${NAME}" and "${x#pat}") collapse into one entry instead of duplicate-looking cards.
const FALLBACK_PATTERNS = [
  [/^\$\{/, 'param-expansion-fallback', { name: '${...} (parameter expansion)', desc: 'Braces around a variable enable expansions beyond a plain `$VAR` — trimming, defaults, substring, case changes and more.' }],
  [/^\$\(\(/, '$(( ))', { name: '$(( ))', desc: 'Evaluates an integer arithmetic expression and substitutes its value.' }],
  [/^\[\[/, '[[ ]]', { name: '[[ ]]', desc: "Bash's extended conditional test." }],
];
function explainToken(token) {
  const t = norm(token);
  if (GLOSSARY[t]) return { key: t, ...GLOSSARY[t] };
  const b = norm(baseWord(t));
  if (GLOSSARY[b]) return { key: b, ...GLOSSARY[b] };
  for (const [re, key, entry] of FALLBACK_PATTERNS) if (re.test(t)) return { key, ...entry };
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
