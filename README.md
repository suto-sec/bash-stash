# bash stash — bash from zero to exam

272 auto-checked exercises (19 topics) covering the Unix shell, core commands, bash scripting and
basic system administration, in an Ubuntu container with a classroom-like setup.
The goal: be able to write an exam-style script like `deploy_bins.sh` (exercise 1801) from scratch, with
only a terminal, VS Code and `man`.

## Start

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
are safe), `./lab build` (rebuild the image).

## Workflow

1. Open this folder in VS Code.
2. Read `exercises/<topic>/<id>_<name>/README.md`.
3. Write your solution in the `answer.sh` next to it (quizzes: `answer.txt`).
4. `check <id>` in the lab terminal. On failure you get a diff (expected vs yours), the failing
   arguments and the fixture seed to reproduce it with `play <id> <seed>`.
5. Only after passing (or being truly stuck), compare with `solutions/<topic>/<id>_<name>.sh`:
   they are written to be the clean/idiomatic version.

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

## For maintenance

- `tools/src/*.txt` — source of every exercise (statement + checker spec + solution);
  `tools/build.sh` regenerates `exercises/` and `solutions/` (never overwrites your answers).
- `lib/engine.sh` — the checker (spec format documented at the top).
- `tools/validate.sh [ids]` (inside the lab) — proves every reference passes and an empty answer fails.
- `container/` — image definition (users, fake logs, sessions).

## License

MIT — see [LICENSE](LICENSE).
