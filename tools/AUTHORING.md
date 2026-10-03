# Authoring exercises

Everything the checker needs lives in one source block per exercise inside `tools/src/*.txt`.
`tools/build.sh [files...]` turns the blocks into `exercises/<topic>/<id>_<slug>/` (README.md, check.sh,
blank answer) and `solutions/<topic>/<id>_<slug>.sh`. `tools/validate.sh <ids...>` (run inside the lab:
`./lab tools/validate.sh 0525 0526`) proves that the reference passes its own checker and that an empty
answer fails. **Both must hold for every exercise.**

## Block format

```
@@topic 05_filters | Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee...
@@ex 0525 slug_name | Human title
@@level 3
@@cmds cut, sort, uniq -c
@@readme
Markdown statement (the title and meta line are added automatically).
@@check
bash: checker spec (sourced by lib/engine.sh)
@@solution
#!/bin/bash
reference solution
```

- The `@@topic` line must be copied **exactly** from the topic's original source file, so that
  new exercises land in the same folder. Several source files may share a topic.
- IDs: `TTNN` (topic + number); never reuse or skip into another topic's range.
- `@@level`: 1-2 basic, 3 normal, 4 exam level, 5 beyond the exam.

## Checker spec (see the header of lib/engine.sh)

| name | meaning |
|------|---------|
| `SCRIPT_NAME=x.sh` | name the answer is installed/run as (matters for `$0`, usage messages) |
| `ARGS=( '' 'dir' '"a b" x' '"$W/abs"' )` | one string per test case, `eval`'d in the work dir; `$W` work dir, `$H` home |
| `COMPARE="stdout exit"` | any of `stdout stderr errmsg exit files owner mtime` |
| `SORT_OUTPUT=1` | compare stdout ignoring line order (avoid: better to specify the order) |
| `SEEDS=3` | random fixtures per case (1 if nothing is random) |
| `ENV=(VAR=val)` | extra environment |
| `setup()` | builds the fixture; cwd = `$W`, `HOME=$H` |
| `input()` | stdin for the script |
| `filter()` | normalises stdout before comparing (e.g. dates) |
| `capture()` | prints normalised state after the run; compared ref vs yours |
| `extra_check()` | custom assertions with `fail "msg"`; helpers `must_use`, `must_not_use`, `max_lines`, `mentions`; variables `OUT ERR CODE REF_OUT REF_ERR REF_CODE CASE W H ANSWER` |

`errmsg` means "stderr must be non-empty exactly when the reference's is" (free wording).
`files` compares every path under work and home: type, permissions, link count, symlink target and
content (archives by what they contain, not by timestamps).

### How runs happen

The answer and the reference run **separately on identical fixtures at the same path**, with
`bash`, `env -i` (PATH, HOME=$H, USER=alumno, LANG=en_US.UTF-8, TZ=Europe/Madrid), umask 022,
cwd = `$W`, stdin from `input()` or empty, 10 s timeout. Observable behaviour is compared.

### Fixture helpers (use these, never `$RANDOM`: bash reseeds it in every subshell)

`rand N` (0..N-1), `randr A B`, `pick a b c`, `word`, `words N`, `randtext LINES`,
`bigfile PATH BYTES`, `ip_rand`, `mkfl FILE line1 line2...`, `mkf FILE content`.
Every call returns a **new** value: store it in a variable if you need it twice
(`d=$(word); mkdir "$d"; touch "$d/x"`).

## Rules that keep exercises fair

1. **Specify the output completely**: exact text, order (and tie-breaks), format of numbers,
   what goes to stdout vs stderr, exit codes. Anything not specified must not be compared
   (use `errmsg`, `filter`, `extra_check` instead).
2. **Deterministic**: no dates, PIDs, timings, `$RANDOM`, or directory-order-dependent output in what
   is compared (sort `find`/glob output where order matters, or say "in the order of the `*` glob").
3. **Random fixtures that matter**: vary names, sizes, counts, contents so that hard-coding fails;
   include spaces in file names for scripts; include decoys (things that must NOT match).
4. `setup()` must print nothing to stderr (that is reported as a checker bug).
5. Solutions: clean, idiomatic, commented only where it helps; only commands from the course
   material (the lab's cheatsheet): echo/printf, cd pwd mkdir rmdir ls tree du df stat touch cp mv rm
   ln readlink basename dirname file tar gzip gunzip zcat compress uncompress mktemp cat head tail wc
   cut sort uniq tr sed tee nl tac paste diff cmp od split grep find xargs chmod chown chgrp umask
   test [ [[ (( )) expr bc seq read who last id groups whoami ps kill jobs wait sleep env printenv
   export unset source date crontab sudo useradd groupadd usermod passwd getent. **No awk, perl,
   python.**
6. Exam-level scripts (`@@level 4`): `SCRIPT_NAME`, argument validation with distinct exit codes and
   messages on stderr, several `ARGS` cases covering success and every error, `SEEDS=2` or more,
   names with spaces, a final summary line. Error cases: use `COMPARE` with `errmsg`, and
   `mentions` in `extra_check` when the statement asks to name the offending argument.
7. Don't touch the system outside `$W`/`$H` unless the exercise is about it (then undo in `setup`).
