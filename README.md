# bash stash — bash from zero to exam

272 auto-checked exercises (19 topics) covering the Unix shell, core commands, bash scripting and
basic system administration, in an Ubuntu container with a classroom-like setup.
The goal: be able to write an exam-style script like `deploy_bins.sh` (exercise 1801) from scratch, with
only a terminal, VS Code and `man`.

## Requirements

Linux (or WSL) with **podman** (recommended) or **docker**. Nothing else: the Ubuntu image carries
everything, including VS Code for the browser. The first start builds the image (a few minutes).

## Start: web UI

```bash
./lab web        # starts the lab and opens http://localhost:8080
```

- **Left:** every topic and exercise with its status (✔ passed, ● in progress, ◉ solution viewed,
  ○ not started), search, and overall progress.
- **Middle:** the statement, **Check** (`Ctrl+Enter`) with the checker's diff when something is
  wrong, and **Show solution** (asks for confirmation if you haven't passed the exercise yet; the
  exercise is then marked *solution viewed* until you pass it).
- **Right:** your workspace, switchable at any time between
  - **Terminal**: a real bash shell in the lab, opened in the exercise folder (buttons: `cd here`,
    `nano answer`, new session), exactly like an exam without a GUI;
  - **VS Code**: plain VS Code in the browser (no extensions, AI chat disabled), opened on the
    exercise folder with `answer.sh`, with its own integrated terminal.

  Both edit the same files, so you can switch whenever you like.
- ☀/☾ switches the light/dark theme of the site, the terminal and VS Code.

The web UI only listens on `127.0.0.1` and only accepts requests from pages served by itself.

## Start: command line

```bash
./lab            # opens a shell in the Ubuntu lab as alumno (builds/starts the container if needed)
```

Inside the lab (you land in `~/lab`, which is this folder, shared with your machine):

| command | what it does |
|---------|--------------|
| `next` | shows the first exercise you haven't passed yet |
| `check 0703` | checks one exercise |
| `check 07` | checks every attempted exercise of topic 07 |
| `check all` | checks everything you attempted + progress table |
| `progress` | per-topic progress (no re-run) |
| `play 0703` | builds the exercise's test files in `~/play/0703` so you can experiment by hand, and prints the exact command to run your answer like the checker does |
| `man`, `info`, `whatis`, `apropos` | full manual pages are installed: practise using them, it's your only help in the exam |

From your own terminal you can also run any of them without entering: `./lab check 0703`.
Other host commands: `./lab root` (root shell), `./lab reset` (throw the container away; your files
are safe), `./lab build` (rebuild the image). The web UI and the command line share the same
answers and progress.

## Workflow

1. Open an exercise (web UI, or `exercises/<topic>/<id>_<name>/README.md`).
2. Write your solution in its `answer.sh` (quizzes: `answer.txt`).
3. Check it. On failure you get a diff (expected vs yours), the failing arguments and the fixture
   seed to reproduce it with `play <id> <seed>`.
4. Only after passing (or being truly stuck), compare with the solution
   (`solutions/<topic>/<id>_<name>.sh`): they are written to be the clean/idiomatic version.

## Topics (in study order)

| # | topic | exercises |
|---|-------|-----------|
| 01 | echo, quoting, substitution | 12 |
| 02 | directories & navigation | 14 |
| 03 | files, copies & links | 15 |
| 04 | tar, gzip, compress | 8 |
| 05 | filters: wc head tail cut sort uniq tr sed tee nl paste diff od split | 24 |
| 06 | grep & regular expressions | 16 |
| 07 | find | 16 |
| 08 | permissions, chmod, umask, chown | 12 |
| 09 | redirection | 12 |
| 10 | pipes, xargs, command substitution | 16 |
| 11 | variables, arithmetic, environment | 12 |
| 12 | processes, jobs, signals | 10 |
| 13 | script parameters & exit codes | 13 |
| 14 | test, if, case | 14 |
| 15 | loops & read | 18 |
| 16 | functions | 10 |
| 17 | users, groups, sessions, auth.log, cron, sudoers | 18 |
| 18 | **exam-style scripts** (`deploy_bins.sh`, the log analyser `ipLog.sh` and 20 more) | 22 |
| 19 | theory quizzes (man/less/info, shell, inodes/umask, redirection, users/sudo, processes, boot/GRUB/UEFI, systemd, "what does it print", globs vs regex) | 10 |

Difficulty goes ★☆☆☆☆ → ★★★★★ inside each topic and overall. `exercises/INDEX.md` lists them all.
If you are short of time before the exam: do topics 07, 13, 14, 15 and then all of 18.

## The lab environment

Ubuntu 24.04 with man/info pages, `/usr/share/dict/words`, `tree`, `bc`, `pstree`, `cron`, `sudo`,
the user `alumno` (password `lab`), other users/groups (`luke`, `sally`, `rod`, `jgarcia`,
`devs`, `secops`...), logged-in sessions for `who`/`last`, and a realistic `/var/log/auth.log`
(ssh brute-force attempts, sudo, cron...) for the log exercises. `~/scripts.tgz` contains some classic
example scripts. Known limitation: `w` crashes inside the container (procps bug without systemd), and
`systemctl` doesn't work (no systemd) — those parts are covered by quizzes.

## How checking works

Your `answer.sh` and the reference solution are run (always with `bash`) on **identical, randomly
generated fixtures** at the same path, with an isolated `$HOME`, several times with different seeds
and argument lists. Depending on the exercise the checker compares stdout, stderr (or just "there is an
error message"), exit code, the resulting files (type, permissions, link count, content; archives by
content), owners/mtimes, and custom state. Some exercises also require/forbid a command (e.g. "use
`cut`") or limit the number of lines. Because fixtures are random, hard-coding the output doesn't pass.

Progress is stored in `.progress/` (delete it to start over).

## Theory quizzes

Besides the exercises, the web UI has a **Theory** section on the home page: 13 collections and more
than 830 interactive questions on the concepts behind the commands. They are graded in the browser with
instant feedback, in six styles: single choice, multiple choice, fill in the blank, put in order (drag
or arrows), match the pairs, and sort into categories (drag or click). After each answer *every* option
is explained: why the right ones are right and why each wrong one is not.

| collection | topics |
|-----------|--------|
| 01 shell basics & getting help | what a shell is, builtin vs external, PATH, exit statuses, man / info / less, line editing |
| 02 jobs, processes & signals | foreground/background, ps/top, PIDs, zombies, signals and kill |
| 03 files, links & archives | paths, inodes, hard/symbolic links, cp/mv/rm, df/du, tar/gzip |
| 04 permissions | rwx on files and directories, chmod, umask, chown, setuid/sticky |
| 05 text filters | wc, cut, sort, uniq, tr, sed, tee, diff and friends |
| 06 grep & regular expressions | options, BRE/ERE, anchors, groups, globs vs regex |
| 07 find | tests, sizes and times, operators, exec/delete/xargs, traps |
| 08 expansion, quoting & variables | quotes, environment, globs, braces, substitution, arithmetic, aliases |
| 09 redirection, pipes & xargs | streams, redirection order, here-documents, pipes, tee, xargs |
| 10 scripts: running & parameters | shebang, source vs bash, parameters, exit codes, read, cron |
| 11 scripts: logic | test, if, case, loops, functions, debugging, typical bugs |
| 12 users, groups, sessions & sudo | passwd/shadow/group, su and sudo, who/w/last, startup files |
| 13 boot, GRUB, systemd & shutdown | firmware, UEFI/GPT, GRUB, kernel, systemd units and targets, shutdown |

Clicking a collection replaces the sidebar with its questions grouped by subcategory; the main panel
shows the question, a **Check answer** button (Enter) and then the explanations. Results are stored per
question in `.progress/theory/` (a question is ✔ once answered correctly; "Reset progress" clears a
collection) and do not count towards the exercise totals. They are a separate pipeline from the exercises:
sources in `tools/theory/*.txt` (format in `tools/THEORY_AUTHORING.md`), compiled by
`node tools/build_theory.js` into `theory/*.json`; nothing under `exercises/` or `solutions/` is involved.

The quizzes are available in **English and Spanish**: Settings (⚙) → *Theory language*. The switch only
affects the Theory section (its home-page cards, categories, questions and explanations); exercises and
the rest of the app stay in English. Progress is shared between the two languages.

## For maintenance

- `tools/src/*.txt` — source of every exercise (statement + checker spec + solution);
  `tools/build.sh` regenerates `exercises/` and `solutions/` (never overwrites your answers).
- `lib/engine.sh` — the checker (spec format documented at the top).
- `tools/theory/*.txt` + `node tools/build_theory.js` — theory quiz sources and their compiler/validator (writes `theory/*.json`).
- `tools/validate.sh [ids]` (inside the lab) — proves every reference passes and an empty answer fails.
- `container/` — image definition (users, fake logs, sessions, code-server).
- `web/` — web UI: `server.js` (Node: API, terminal over websocket, proxy to code-server) and `public/`.

## License

[PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0) — see [LICENSE](LICENSE). Free for any noncommercial use (personal, educational, research); commercial use is not permitted.
