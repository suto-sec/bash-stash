# Prompt: write a content pack for bash stash

You are going to write practice material for **bash stash**, a web app that trains for a university Linux / shell-scripting exam (bash, files, permissions, find, grep, pipes, scripts, processes, users, boot). The material is delivered as **one JSON file** (a "pack") that the user imports in the app (Home → Imported → choose file). A pack can hold quizzes, practice exams, **scripts** (exercises in which the learner writes a bash script that an automatic checker grades) and **script practice exams** (one bigger script graded out of 10 by objectives).

## What I want from you

1. Ask me (the user) for anything you need that is missing: the **topic**, the **kinds** (quiz, exam, script and/or scriptexam), how many questions or scripts, the difficulty. If I already told you, do not ask again.
2. Write the pack following the format below **exactly**.
3. Reply with **only the JSON**: no explanations before or after it, no Markdown headings. A single fenced block (```json … ```) or the bare JSON are both fine. The file will be saved as `<pack id>.json`.
4. Before replying, run the **checklist** at the end and fix what fails.

The app checks the file when it is imported and shows every problem with its place ("item 1 › group 2 › question 4: …"). Anything that does not follow the format is rejected, so follow it literally.

## Language and style

- English only. Use Markdown inline code with backticks for commands, options, paths, file names and variables: `` `grep -r` ``, `` `$HOME` ``. Do not use other Markdown (no headings, no lists, no tables) inside texts. A text may contain a newline (`\n`) when really needed.
- Teach the concept. Write original questions; do not copy exam papers or course material.
- **Every option, step, pair and item needs a `why`**: one or two sentences saying why it is right, or what the wrong one actually does / where it would be right. A bare "wrong" teaches nothing. Wrong options must be as long and as plausible as the right one (do not make the right answer the longest).
- Options are shuffled by the app on every attempt: never write "all of the above", "both a and b" or refer to options by letter or position.
- Verify every claim about a command's output or behaviour as you would by running it in a standard Linux bash (Ubuntu/Debian, GNU tools). Do not ask about things that differ between systems.

## The file

```json
{
  "format": "bash-stash-pack",
  "version": 1,
  "id": "my-pack",
  "title": "Short title of the pack",
  "description": "One or two sentences (optional).",
  "items": [ { "kind": "quiz", … }, { "kind": "exam", … }, { "kind": "script", … }, { "kind": "scriptexam", … } ]
}
```

- `id`: lowercase identifier, `a-z 0-9 -`, at most 40 characters. Importing a pack with the same `id` replaces the old one (the user is asked).
- `items`: 1 to 100. Every item has a `kind` (`quiz`, `exam`, `script` or `scriptexam`) and an `id` (same identifier rules; unique per kind inside the pack).
- Do not add other fields: they are ignored.

### Item kind `quiz`

A collection of questions grouped in sections. Graded in the browser with instant feedback.

```json
{ "kind": "quiz", "id": "redirection", "title": "Redirection and pipes", "about": "What this quiz covers (optional).",
  "groups": [ { "id": "basics", "title": "The basics", "questions": [ … ] } ] }
```

- 1 to 30 groups; each group 1 to 200 questions. Group and question `id`s are identifiers; **a question id must be unique in the whole quiz and must not change** once the quiz is in use (the learner's progress is stored under it). A group `id` must be unique in the quiz.
- Mix the formats. A good quiz has mostly `single`, some `multi`, `fill`, `order`, `match`, `sort`.

Every question has `type`, `id`, `title` (short, shown in lists), `text` (the question, up to 4000 characters) and optionally `note` (a sentence shown after answering; **required for `fill`**).

#### `single`: one right option (3 to 7 options)

```json
{ "type": "single", "id": "append-op", "title": "Appending", "text": "Which operator appends standard output to a file?",
  "note": "optional",
  "options": [
    { "t": "`>>`", "ok": true,  "why": "It opens the file for appending." },
    { "t": "`>`",  "ok": false, "why": "It truncates the file first." },
    { "t": "`<`",  "ok": false, "why": "It reads input from a file." } ] }
```
Exactly one option has `"ok": true`.

#### `multi`: several right options (3 to 8 options)

Same shape as `single`, but **at least two** options are `"ok": true` and **at least one** is `false`. The learner must select exactly the right set.

#### `fill`: blanks in a sentence

```json
{ "type": "fill", "id": "exit-codes", "title": "Exit status",
  "text": "After a successful command `$?` is `{{0}}`; the number of arguments is in `{{1}}`.",
  "note": "Required: one sentence that explains the idea.",
  "blanks": [ { "answers": ["0"] }, { "answers": ["$#"] } ],
  "wrong": [ { "a": "1", "why": "1 is a failure code, not the success code." } ] }
```
- `{{0}}`, `{{1}}`… mark the blanks in `text`; each number from 0 to (number of blanks − 1) must appear, and `blanks` has one entry per number (1 to 6).
- `answers`: every accepted spelling (1 to 8). Matching ignores extra spaces but is case sensitive. Prefer blanks with one obvious answer.
- `wrong` (optional but recommended): typical wrong answers with the reason they are wrong.

#### `order`: put the steps in order (3 to 8)

```json
{ "type": "order", "id": "run-script", "title": "Running a script", "text": "Put the steps in order.",
  "items": [ { "t": "Write the script", "why": "…" }, { "t": "Make it executable", "why": "…" }, { "t": "Run it", "why": "…" } ] }
```
Write the items **in the correct order**; the app shuffles them. Every step must be distinct.

#### `match`: pair left and right (3 to 8 pairs)

```json
{ "type": "match", "id": "streams", "title": "Standard streams", "text": "Match each stream with its number.",
  "pairs": [ { "l": "standard input", "r": "0", "why": "…" }, { "l": "standard output", "r": "1", "why": "…" }, { "l": "standard error", "r": "2", "why": "…" } ],
  "extras": [ { "r": "3", "why": "Not assigned to any of these." } ] }
```
Left sides must all differ and right sides must all differ. `extras` (optional, up to 4) are decoy right sides that match nothing.

#### `sort`: put items into buckets (2 to 4 buckets, 4 to 10 items)

```json
{ "type": "sort", "id": "builtin-or-not", "title": "Builtin or external", "text": "Classify each command.",
  "buckets": ["Builtin", "External program"],
  "items": [ { "t": "`cd`", "bucket": "Builtin", "why": "…" }, { "t": "`ls`", "bucket": "External program", "why": "…" } ] }
```
Every `bucket` of an item must be exactly one of `buckets`, and every bucket must get at least one item.

### Item kind `exam`

A mock exam: **exactly 10 questions, all `single`** (3 to 5 options each, exactly one right), 1 point each, no penalty, pass at 5/10.

```json
{ "kind": "exam", "id": "basics-1", "title": "Basics exam 1", "about": "Ten single-choice questions on … (optional).",
  "questions": [ { "type": "single", "id": "q1", … }, … 10 in total … ] }
```
Exam questions have the same fields as `single` above. One concept per question, classic look-alike options, mixed difficulty. Question ids unique inside the exam.

### Item kind `script`: a script the learner writes, graded by a checker (this item contains CODE)

A script is built up in 1 to 8 **steps**. Each step adds one requirement; the learner's file grows from step to step, and every step has its own checker. One step = a plain exercise. The learner sees only the step's `readme` (the statement) and the title.

```json
{ "kind": "script", "id": "count-files", "title": "Counting files", "script": "count.sh", "level": 2,
  "tags": ["arguments", "exit codes", "files"], "cmds": "find -maxdepth 1 -type f, wc -l, test -d",
  "fixture": "setup() {\n  mkdir -p docs empty \"my docs\"\n  echo a > docs/a.txt; echo b > docs/.hidden; mkdir docs/sub\n  echo x > notadir.txt\n}\nusage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *count.sh* ]]; }",
  "steps": [
    { "title": "Count the files",
      "readme": "Write `count.sh DIR`. It prints how many **regular files** are directly inside `DIR` (hidden files count, subdirectories do not). Print only the number.",
      "check": "ARGS=('docs' 'empty' '\"my docs\"')\nCOMPARE=\"stdout exit\"",
      "solution": "#!/bin/bash\nfind \"$1\" -maxdepth 1 -type f | wc -l" },
    { "title": "The usual checks",
      "readme": "Not exactly one argument → an error message **and the correct usage** (e.g. `Usage: count.sh dir`) on standard error, exit **1**; the path does not exist → an error naming it, exit **2**; it is not a directory → an error naming it, exit **3**.",
      "check": "ARGS=('docs' 'empty' '' 'docs empty' 'nothing' 'notadir.txt')\nCOMPARE=\"stdout exit errmsg\"\nextra_check() {\n  [[ $REF_CODE == 1 ]] && { usage_ok || fail \"the message should show the correct usage\"; }\n  [[ $REF_CODE == [23] ]] && mentions \"$(eval \"set -- $CASE\"; echo \"$1\")\"\n}",
      "solution": "#!/bin/bash\nif (( $# != 1 )); then echo \"Error: one argument needed\" >&2; echo \"Usage: $0 dir\" >&2; exit 1; fi\n[[ -e $1 ]] || { echo \"Error: $1 does not exist\" >&2; exit 2; }\n[[ -d $1 ]] || { echo \"Error: $1 is not a directory\" >&2; exit 3; }\nfind \"$1\" -maxdepth 1 -type f | wc -l" } ] }
```

Fields: `id`; `title`; `script` (the file name the learner's script is run as: lowercase, ends in `.sh`); `level` (1 to 5 stars); `tags` (1 to 3 of: `arguments`, `exit codes`, `tests`, `loops`, `case`, `arithmetic`, `files`, `text`, `find`, `copy and move`, `permissions`, `archives`, `logs`, `pipes`); `cmds` (the commands practised, free text, optional); `fixture` (optional bash code shared by all steps, see below); `steps`: each with `title` (says what the step adds, not "More"), `readme`, `check` and `solution`.

**How the grading works.** For every test case of a step the checker runs the learner's script **and your reference `solution`** on identical fresh test files (3 different random fixtures) and compares what they did. So you do not write expected outputs: you write a correct `solution` and the cases.

- `solution`: the **whole script as it is at the end of this step** (a complete bash script, with `#!/bin/bash`). Step 2's solution contains step 1's work, and so on.
- `fixture`: bash code that is put in front of every step's checker. It must define `setup()`, which builds the test files in the current directory (the work dir) with `HOME` pointing at a private home (`$HOME`, also `$H`; the work dir is also `$W`). Helpers you can use inside `setup()`: `bigfile PATH BYTES`, `mkf PATH CONTENT`, `mkfl PATH LINE...`, `word` (a random word), `words N`, `pick A B C` (one of the arguments), `rand N` (0 to N-1), `randr A B`. **Never use `$RANDOM`, `date` or anything that changes between runs.** Include awkward names (spaces, dots, a hidden file, an empty directory) when the statement allows them. You may also define small helper functions here, such as `usage_ok` above.
- `check`: must define `ARGS=( ... )`: one string per test case, evaluated as the argument list of the script (shell quoting works: `'"my docs" 3'`, and `''` is "no arguments"). `$W` and `$H` can be used. A `$(helper)` inside a case runs that function before the run (it prints nothing): `'docs $(pre_make)'`. Cover normal cases, the edge cases and every error the statement lists.
  - `COMPARE="stdout exit"` says what is compared. Any of: `stdout`, `stderr`, `errmsg` (an error message must be on standard error exactly when the reference prints one), `exit` (exit code), `files` (the resulting files in the work dir and home: names, modes, contents), `owner`, `mtime`. The default is `stdout exit`. Use `files` when the script creates, copies, moves or changes things.
  - `SORT_OUTPUT=1`: ignore the order of the output lines (use it when the statement says the order does not matter).
  - Optional: `SEEDS=3`, `TIMEOUT=10`, `ENV=( VAR=value )`, `input() { ...prints what the script reads on stdin... }`.
  - `extra_check() { ... }` for what the comparison cannot say. Available there: `OUT`, `ERR`, `CODE` (the learner's stdout, stderr, exit code), `REF_OUT`, `REF_ERR`, `REF_CODE` (the reference's), `CASE` (the case string), `W`, `H`; and `fail "message"`, `mentions "text"` (the output must contain it), `must_use cmd...`, `must_not_use cmd...`. The usual use is: "the error message shows the usage" and "the error mentions the name that was wrong".
- `readme`: the statement, Markdown. **It must say everything the checker tests**: file names, exact messages and formats, the order of lines, the exit codes, what happens with hidden files or spaces. A learner must be able to pass by following the text alone. Say what is new in this step; do not repeat earlier steps. Put an example (command → output) when the format is not obvious. Use `**bold**` for the points that are easy to miss.
- Each step must be **observable**: the checker of step N must pass the solution of step N and fail the solution of step N−1 (and an empty script). The app's "Self-test" button checks this.

**Allowed code.** Only what a course on Linux shell scripting uses (`find`, `grep`, `sort`, `cut`, `tar`, `chmod`, `cp`, `mv`, `mkdir`, `wc`, `awk`, `sed`, `test`, loops, `case`, `read`, functions...). The code is read when the file is imported and **the import is refused** if it uses the network (`curl`, `wget`, `nc`, `/dev/tcp`...), `sudo`, `eval` of built strings, `source`, `exec` of another program, other languages (`python`, `perl`...), background jobs that outlive the script, `crontab`, or writes outside the sandbox (absolute paths like `/etc`, `/home`, `/tmp`; use `$HOME` and relative paths). Unusual commands are listed as warnings. The code runs in a sandbox only after the user has read it and allowed the pack.

For error handling follow the usual exam pattern: wrong number of arguments → message and usage on stderr, exit 1; a path that does not exist → exit 2; the wrong kind of thing → exit 3; use `COMPARE="stdout exit errmsg"` plus `extra_check` as in the example.

### Item kind `scriptexam`: one whole script, graded out of 10 by objectives (this item contains CODE)

Like the real exam: a statement, **one** script to write, no steps and no hints. The learner is graded by **objectives** (for example "argument checking" 3 points, "core behaviour" 4, "special cases" 3); each test case belongs to one objective and the points of an objective are earned in proportion to the cases it passes. 5 out of 10 passes.

```json
{ "kind": "scriptexam", "id": "biggest-file", "title": "The biggest file", "script": "biggest.sh", "cmds": "find, sort, head, test",
  "statement": "Write `biggest.sh DIR`. It prints the name of the largest regular file directly inside `DIR` … (every check, in order, with its exit code)",
  "objectives": [ { "id": "args", "label": "Argument checking and error messages", "points": 3 },
                  { "id": "core", "label": "Finding the biggest file", "points": 4 },
                  { "id": "edge", "label": "Special cases (spaces, hidden files, ties, no files)", "points": 3 } ],
  "fixture": "setup() {\n  mkdir -p docs empty …\n  …\n}\nusage_ok() { … }",
  "check": "SEEDS=2\nCOMPARE=\"stdout exit errmsg\"\nARGS=('docs' '\"mixed dir\"' '' 'nothing' …)\nCASE_OBJ=(core edge args args …)\nextra_check() { … }",
  "solution": "#!/bin/bash\n…" }
```

- `objectives`: 2 to 6, each `{id, label, points}` with a short lowercase `id` (letters and digits) and **points that add up to exactly 10**.
- `fixture`, `check` and `solution` work exactly as for a script (see above): `setup()` builds the test files, `ARGS=( … )` lists the cases, `COMPARE`, `SORT_OUTPUT`, `extra_check`, and the `solution` is the complete reference script.
- **`CASE_OBJ=( … )` is required**: one objective id per entry of `ARGS`, in the same order and with the same length. It says which objective each case counts for. Every objective needs at least one case (the importer warns about an objective with none), and usually several.
- Do **not** define `OBJECTIVES` or `SCRIPT_NAME` in the code: the app builds them from `objectives` and `script`.
- `statement`: Markdown, up to 8000 characters. Like an exam paper: it states everything that is tested (messages, exit codes, order, special cases) but gives no solution.
- Make it a fair exam: a competent learner who follows the statement should score 10/10; an empty script must score less than 10 (the app's Self-test checks both with your `solution`).

## Limits

Texts: question `text` and `note` up to 4000 characters; option, step, pair and item texts and `why` up to 1200; titles up to 200; a script's `readme` up to 6000 and each piece of code (`fixture`, `check`, `solution`) up to 20000 characters. At most 100 items per pack, 200 questions per quiz, 8 steps per script, and the file at most 3 MB.

## Checklist (run it before you reply)

- [ ] The reply is valid JSON (double quotes, no comments, no trailing commas, nothing outside the JSON).
- [ ] `format` is `"bash-stash-pack"`, `version` is `1`, every `id` follows the identifier rules and is unique where required.
- [ ] Every `single` has exactly one `ok: true`; every `multi` has at least two right and one wrong option.
- [ ] Every `fill` has a `note`, a `{{n}}` for each blank and one `blanks` entry per `{{n}}`.
- [ ] Every option / step / pair / item has a useful `why`.
- [ ] No option is the obvious winner by length; no "all of the above".
- [ ] Every exam has exactly 10 single-choice questions.
- [ ] Every command behaviour mentioned is correct on a standard GNU/Linux bash.
- [ ] Every scriptexam: points add up to 10, `CASE_OBJ` has as many entries as `ARGS`, no `OBJECTIVES` in the code, the statement lists every check.
- [ ] Every script: `script` ends in `.sh`; `level` 1 to 5; 1 to 3 valid `tags`; each step has `title`, `readme`, `check` (with `ARGS=(`) and `solution`.
- [ ] Every `solution` is a complete script, runs on a standard bash, and is the cumulative result of the steps so far.
- [ ] Every checker covers the error cases of the statement and the edge cases of the fixture; the statement mentions each one.
- [ ] Nothing in the code is random or time-dependent; nothing uses the network, `sudo`, `eval`, `source` or absolute paths outside `/dev/null`.
