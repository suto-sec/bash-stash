# Authoring the Scripts (home page: Coding exercises → Scripts)

A **script** is one exercise: a bash script built up in steps (3–6, as many as it needs). Every step adds one requirement and has its own
checker; the learner's file grows from step to step (`.progress/scripts/<id>/<name>.sh`). A script is done when all its steps pass. They
are far easier than the practice exams (`EXAMS_AUTHORING.md`, "Script practice exams") and lead up to them; English only.

Sources: `tools/src/scripts/<NN>_<slug>.txt`; `node tools/build_scripts.js` writes `scripts/<id>_<slug>/` (meta.json, README.N.md,
check.N.sh) and `solutions/scripts/<id>_<slug>/N.sh`. Format: the header of `tools/build_scripts.js`; see `01_greet.txt` for a minimal example.

Rules
- Step 1 is tiny; each next step adds exactly one idea. Statements say what is new, never re-explain earlier steps.
- Each step's `@@solution` is the whole script at that step. Error handling follows the exam pattern: a usage message on stderr and exit 1,
  a missing thing exit 2, a wrong kind of thing exit 3 (use `COMPARE="stdout exit errmsg"` and `extra_check` for "mentions the name" / usage).
- A shared `@@fixture` (setup) serves every step; `play sNN` builds the fixture of the last step.
- Run `./lab tools/validate_scripts.sh` (inside a lab instance). For every step: the reference passes, a do-nothing script fails and the
  PREVIOUS step's reference fails (so no step is dead). Use `tools/validate.sh` after touching `lib/engine.sh`.
- Tests of the web UI must use a scratch progress dir (`LAB_PROGRESS=/tmp/x node web/server.js`; `./lab` does not forward the variable).
- Do not reuse the scenarios of the pilot practice exams (`newest`, `lowstock`, `quarantine`) nor those planned for the remaining ones.

Writing a step statement (the learner sees only this text and the step title)
- The **title** says what the step adds ("Optional step size", not "Count in steps"); never reuse a vague word like "More" or "Something else".
- Say the new behaviour in one sentence, then show an **example** (command → output) whenever the output format is not obvious.
- List every check as `condition → what is printed where → exit code`, in the order the checker applies them. Anything the checker tests must be
  written down: file names, exact messages (`Directory <path> created`), the order of lines, whether case matters, what happens to hidden files.
- Name the tools only as hints; do not refer to commands outside the browser (the lab has no `check`/`play` commands: say "the terminal folder",
  "Reset exercise instance").
- The first time a step asks for "the correct usage", give an example message (`(e.g. `Usage: name args`)`): the checker accepts any message that
  contains `Usage`/`usage`/`Uso` or the script name.

## The first 30 scripts (the original plan; groups are set by number in tools/build_scripts.js)

First steps (s01–s08): 01 greet (args, default, usage) · 02 kind (-f/-d/-e, exit codes) · 03 sumargs (loop, arithmetic, validation) ·
04 lines (wc, many files, option -w) · 05 ext (case on extensions, counters) · 06 countdown (while, validated integer) ·
07 table (multiplication table, nested loops, printf) · 08 vowels (tr / wc on the arguments).

Files and text (s09–s20): 09 safecopy (copy without overwriting) · 10 backup1 (copy to ~/backup, create it with a message, count) ·
11 bigfiles (files above N bytes) · 12 findext (find by extension, count) · 13 lowernames (lower-case names safely) ·
14 userinfo (cut on a passwd-like file) · 15 grepcount (matches per file) · 16 loglevels (count log levels) · 17 wordtop (most frequent line) ·
18 tailn (last N lines, validated N) · 19 samenames (names common to two directories) · 20 emptyfinder (empty files and directories).

Close to the exam (s21–s30): 21 execlist (find -perm, copy to a directory) · 22 oldfiles (find -mtime, move with a message) ·
23 permfix (chmod scripts) · 24 ownedby (find -user, report) · 25 archiver (tar+gzip to ~/archives) · 26 rotate (numbered copies) ·
27 diskuse (du per subdirectory, sorted) · 28 totals (CSV totals per category) · 29 syncnew (copy newer files, count) · 30 publish
(capstone: validate, create the destination with a message, copy the matching files, count the successes, exit codes).

## Stars, tags and grouping (built)

Every script has `@@level 1-5` (the same ★ scale as the exercises) and `@@tags` (1-3 from the vocabulary in `tools/build_scripts.js`: arguments,
exit codes, tests, loops, case, arithmetic, files, text, find, copy and move, permissions, archives, logs, pipes). The Scripts section of the home
page has a dropdown that groups them by Difficulty (default), Topic (a script appears under each of its tags), Number of steps or Progress; the
choice (`localStorage` `scriptGroup`) drives the home grid, the home sidebar tree and the sidebar inside a script. The Scripts counter counts
each script once. 87 scripts (s01-s87) are written and pass `tools/validate_scripts.sh`; s31-s67 were added in later batches to even out the stars and
tags, and s68-s87 are exam-style (the argument checks with exit codes 1/2/3, a default directory, a count at the end, one option such as `-c`, `-f` or `-n`,
in the manner of the June exam's `deploy_bins.sh`) and are part of the suggested path (`web/public/path-data.js`).

The home page also has **Order by** (number, title, difficulty, steps, progress, topic) and a direction (`localStorage` `scriptOrder`, `scriptDir`), with a
reset, and the same three choices in a panel at the top of the sidebar of a script. The setting *Scripts → Instructions* (`localStorage` `scMode`)
shows the steps one at a time or every part on one page, checked with the last step's checker (`POST /api/scripts/:id/markall` then counts every step as
passed). Scripts can also come from an imported pack (`web/import-prompt.md`): they are written as `scripts/imp-<pack>-<item>_script/`, git-ignored, and
never count in the course totals.
