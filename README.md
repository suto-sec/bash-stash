# bash stash — bash from zero to exam

A self-hosted study lab for the Unix shell, bash scripting and basic system administration, built to prepare a university
operating-systems exam where you write a bash script with **only a terminal, VS Code and `man`**. Everything runs on your own
computer, in a container, and you use it in your browser.

- **741 auto-checked coding exercises** in 20 topics, **87 scripts** built up step by step, and **script practice exams**
- **834 theory quiz questions** in 6 formats, **32 theory practice exams**, **71 man-page drills** (questions and tasks)
- a **reference manual** with 200 entries (every option, real example output), and a **suggested path** with an **exam-readiness** page
- a terminal and **VS Code** in the browser, side by side with the statement
- **import your own** quizzes, exams, scripts and script exams from one JSON file (for example written by an AI assistant)

Everything you do is stored in the `.progress/` folder of the project (delete it to start over). Nothing leaves your computer.

---

## Install (step by step)

You need three things on your computer: **a container engine** (podman or Docker), **git**, and **a Linux-style terminal**.
After that, two commands start everything. Pick your system:

| your system | what to install | where you type the commands |
|---|---|---|
| **Linux** | podman (or Docker), git, curl | any terminal |
| **macOS** | Docker Desktop, git | the Terminal app |
| **Windows 10/11** | WSL 2 with Ubuntu, and Docker Desktop (or podman inside Ubuntu) | **the Ubuntu terminal** (not PowerShell, not Git Bash) |

Disk space: about **4 GB free** (the lab image is about 1.8 GB). The first start downloads and builds it and takes **5 to 15 minutes**;
every start after that takes a few seconds.

### Linux

1. Open a terminal and install the tools (choose your distribution):

   ```bash
   # Ubuntu 24.04 / Debian 12 and newer
   sudo apt update && sudo apt install -y podman git curl

   # Fedora
   sudo dnf install -y podman git curl

   # Arch / Manjaro
   sudo pacman -S --needed podman git curl
   ```

   Podman must be **version 4.3 or newer** (`podman --version`). On older systems (for example Ubuntu 22.04) use Docker instead:
   `sudo apt install -y docker.io git curl && sudo usermod -aG docker $USER`, then **log out and in again**.
   If you use Docker, your Linux user id must be 1000 (check with `id -u`; the first user of a normal installation is).
2. Download the project and start it:

   ```bash
   git clone https://github.com/suto-sec/bash-stash.git
   cd bash-stash
   ./lab web
   ```

3. Wait until it prints `bash stash is running at http://localhost:8080`. Your browser opens by itself; if it does not, open that address.

### macOS

1. Install **Docker Desktop** from <https://www.docker.com/products/docker-desktop/> (or `brew install --cask docker`), start it and wait until
   the whale icon in the menu bar stops moving. Git comes with the Xcode command line tools (`xcode-select --install`).
2. In the Terminal app:

   ```bash
   git clone https://github.com/suto-sec/bash-stash.git
   cd bash-stash
   ./lab web
   ```

3. Wait for `bash stash is running at http://localhost:8080`. The browser opens by itself; otherwise open that address.

### Windows

Windows cannot run the `./lab` script directly, so you use **WSL** (the Windows Subsystem for Linux, built into Windows 10/11).
All the commands below are typed in the **Ubuntu** terminal, never in PowerShell or Git Bash.

1. **Install WSL with Ubuntu.** Open **PowerShell as administrator** (right-click Start → *Terminal (Admin)*) and run:

   ```powershell
   wsl --install -d Ubuntu-24.04
   ```

   Restart the computer when it asks. Then open **Ubuntu** from the Start menu; the first time it asks you to invent a Linux username and password
   (the password is not shown while you type; that is normal).
2. **Install the container engine.** Choose one:
   - *Simplest:* install **Docker Desktop** for Windows (<https://www.docker.com/products/docker-desktop/>), start it, open
     *Settings → Resources → WSL integration*, switch **Ubuntu-24.04** on and press *Apply*.
   - *Without Docker Desktop:* in the Ubuntu terminal run `sudo apt update && sudo apt install -y podman git curl`.
3. In the **Ubuntu terminal** download the project **into your Linux home folder** and start it:

   ```bash
   cd ~
   git clone https://github.com/suto-sec/bash-stash.git
   cd bash-stash
   ./lab web
   ```

   Do **not** put the project under `/mnt/c/...` (your Windows drives): it is very slow there and breaks permissions.
4. When it prints `bash stash is running at http://localhost:8080`, open that address in your normal Windows browser (WSL forwards `localhost`).

> **Windows vs Linux, in short:** after the install, everything is identical: same commands, same screens, same files. The differences are only
> *getting there*: on Linux the tools are installed with the package manager and `./lab` runs natively; on Windows you first create a Linux
> environment with WSL and run everything inside it; on macOS you use Docker Desktop and the Terminal app. The `lab` script detects Git Bash/Cygwin and
> tells you to use WSL, and opens the right browser on Linux, macOS and WSL.

### Daily use

| you want to | type (in the project folder) |
|---|---|
| start the lab | `./lab web` |
| stop it and free the memory | `./lab reset` (your progress and answers are safe: they live in the project folder) |
| open a shell inside the lab | `./lab` |
| use another port (if 8080 is taken) | `LAB_PORT=8090 ./lab web`, then open `http://localhost:8090` |
| update to the newest version | `git pull`, then `./lab reset`, then `./lab build`, then `./lab web` |
| start from zero | delete the `.progress/` folder (and your `answer.sh` files if you want those blank too) |
| remove everything | `./lab reset`, `podman rmi bash-stash` (or `docker rmi bash-stash`), then delete the project folder |

### If something goes wrong

| what you see | what to do |
|---|---|
| `Need podman or docker` | the engine is not installed (or not in this terminal): redo step 1 of your system. On Windows, run it in the Ubuntu terminal and enable WSL integration in Docker Desktop. |
| `permission denied: ./lab` | the file lost its executable bit (it happens when the project was downloaded as a ZIP): run `chmod +x lab` or start with `bash lab web`. |
| `Cannot connect to the Docker daemon` | Docker is not running: start Docker Desktop (Windows/macOS) or `sudo systemctl start docker` (Linux). On Linux also check `groups` shows `docker` (log out and in after `usermod`). |
| podman: `no subuid ranges found` / `cannot find newuidmap` | rootless podman needs: `sudo apt install uidmap` and `sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER`, then `podman system migrate`. |
| `address already in use` / port 8080 busy | use another port: `LAB_PORT=8090 ./lab web`. |
| `bad interpreter` or `\r: command not found` | the files got Windows line endings. In WSL: `git config --global core.autocrlf false`, delete the folder, clone again **inside WSL**. (The repository now forces Unix line endings, so a fresh clone is fine.) |
| the page is blank or says it cannot connect right after `./lab web` | wait about 30 seconds and reload: the terminal and VS Code services are still starting. |
| the first start seems stuck | the image is being built (a few minutes, about 1.8 GB). `podman ps` / `docker ps` should show `bash-stash` when it is done. |
| `selinux` / `Permission denied` in the container (Fedora and friends) | the script already mounts the project with the `:Z` label; if it still fails, run `./lab reset` and start again, and make sure the project is in your home folder. |
| anything else | `./lab reset` and `./lab web` again. Logs: `./lab root cat /tmp/web.log`. |

The web page only listens on `127.0.0.1` (your own computer) and only accepts requests from pages served by itself.

---

## Using it

Open `http://localhost:8080`. The home page has five tabs:

- **Start**: one big button (the suggested path for a new user, *Continue* afterwards), your **exam readiness**, the suggested path folded to a row,
  and tiles to the rest.
- **Coding exercises**: *Tracks* (Minimal 272, Intermediate 342, Full 642 exercises), *Introduction* (83 tiny warm-ups), *Scripts*
  (87, grouped and ordered the way you choose, in steps or all at once) and *Practice exams* (whole-script exams graded out of 10).
- **Theory**: 13 *quizzes* (830+ questions) and 32 *practice exams* (10 single-choice questions each, three difficulty levels).
- **Man drills**: 55 questions and 16 coding tasks that you solve with the manual open, like in the exam.
- **Imported**: your own content (see below).

Everywhere: **Ctrl+K** searches everything (exercises, scripts, exams, quizzes, manual entries); **Alt+G** then a key jumps to a place
(*h* home, *r* reference, *t* tracks, *c* scripts, *x* script exams, *q* quizzes, *e* theory exams, *m* man drills, *d* readiness,
*n*/*p* next and previous, *f* the filter box, *?* the full list). The top bar has buttons for both, plus *Readiness*, *Reference*, *Layout* and
the settings (⚙: theme, theory language, how exams behave, scripts in steps or all at once, shortcuts).

### The exercise screen

- **Left:** the topics with the status of every exercise (✔ passed, ● in progress, ◉ solution viewed, ○ not started), search, and the totals.
- **Middle:** the statement, **Check** (`Ctrl+Enter`) with the checker's diff when something is wrong, **Info** (what the commands do),
  and **Show solution** (asks for confirmation if you have not passed yet; the exercise is then marked *solution viewed* until you pass it).
- **Right:** a real **terminal** (bash, with the full manual pages) and **VS Code** in the browser, switchable at any time. Both edit the same
  files. The **Layout** button arranges statement, terminal and VS Code side by side as you like.

### Workflow

1. Open an exercise and read the statement.
2. Write your solution in `answer.sh` (scripts: the file named in the statement) with the terminal or VS Code.
3. Press **Check**. If it fails, each failing case shows what was run, plain-language hints (wrong order, missing final newline, stderr instead of
   stdout, exit code...) and *expected* vs *yours* with a character-level diff. **Try with these test files** builds that exact case in
   `~/play/<id>-failing/` and types the command in the terminal.
4. Only after passing (or being truly stuck), compare with the solution (`solutions/<topic>/<id>_<name>.sh`, written to be clean and idiomatic).

### Scripts

Whole scripts built up step by step: every step adds one requirement and has its own check, and your file keeps growing from step to step.
In the home page you can **group** them (difficulty, topic, number of steps, progress), **order** them (number, title, difficulty, steps, progress, topic;
increasing or decreasing) and reset both; the same panel is at the top of the sidebar while you work on a script. The setting
*Scripts → Instructions* switches between **in steps** and **all at once** (every part on one page and one check of the finished script;
passing it counts every step as passed).

### Script practice exams

One bash script per exam, graded out of 10 by objectives (pass at 5), in three levels. The checker can run **any time** or **only on submit**
(⚙ → *Script practice exams*), exactly as you prefer to practise. An unfinished attempt is kept.

### Theory quizzes and practice exams

Quizzes are graded in the browser with instant feedback in six formats: single choice, multiple choice, fill in the blank, put in order, match the
pairs, and sort into categories. After each answer *every* option is explained. Practice exams are 10 single-choice questions; the settings decide
whether answers are checked after each question or at the end, and whether you may go back. Quizzes and exams exist in **English and Spanish**
(⚙ → *Theory language*; it only affects the theory parts).

### Reference manual

The **Reference** page is a manual written like a good `man` page for the commands, syntax and concepts of the course: synopsis, description,
**every option**, worked examples whose output was produced by really running them, exit status, common mistakes, *see also*; 200 entries in 14
categories. The filter box takes the cursor when the page opens and understands symbols (`$@`, `>>`, `2>&1`, `[[`...). Every command in an
exercise's *Info* panel links to its entry.

### Suggested path and readiness

The **suggested path** is the exam material in order (12 stages, from quoting and variables to exam rehearsal), mixing warm-ups, exercises, scripts,
quizzes and practice exams, and leaving out what the exam is unlikely to ask. The **Readiness** page shows, per topic, how ready you are (practice,
quizzes and theory-exam answers, weighted like the real exam), the topics where one more hour pays most, and the questions you missed.

### Importing your own content

**Home → Imported** takes one or several `.json` files (a *pack*) with quizzes, theory practice exams, scripts and script practice exams. The
**Prompt for an AI assistant** button downloads a complete description of the format; give it to an AI assistant, tell it the topic, and import the
file it writes. An **Example pack** button downloads a small valid pack.

- Each file is checked before anything is saved, with every problem listed with its exact place; you can import many files at once.
- Imported items have **their own progress** and never count in the totals, the suggested path or the readiness.
- Packs can be renamed and deleted, and a **history** lists what was added, replaced, renamed, removed or allowed.
- Scripts and script exams contain **code** (a fixture and a checker, as the built-in ones). Because of that:
  nothing runs when you import; a **scanner** refuses code that uses the network, `sudo`, `eval`/`source` of built text, other languages, or touches
  anything outside its sandbox, and warns about anything unusual; before the first run you are shown the code and must **allow the pack**; the code then
  runs in a sandbox (time limit, no network, throw-away folder); and a **snapshot** of your progress and answers is taken first, with a one-button
  **roll back**. A **Self-test** button checks that every step's own solution passes its checker and an empty script does not.
- Imported data lives in `.progress/imported/` (never in git).

## The lab environment

Ubuntu 24.04 with man/info pages, `/usr/share/dict/words`, `tree`, `bc`, `pstree`, `cron`, `sudo`, the user `alumno` (password `lab`), other
users and groups (`luke`, `sally`, `rod`, `jgarcia`, `devs`, `secops`...), logged-in sessions for `who`/`last`, and a realistic `/var/log/auth.log`
(ssh brute-force attempts, sudo, cron...) for the log exercises. `~/scripts.tgz` has some classic example scripts. Known limitations: `w` crashes inside
the container (procps bug without systemd) and `systemctl` does not work (no systemd); those parts are covered by quizzes.

## How checking works

Your script and the reference solution are run (always with `bash`) on **identical, randomly generated fixtures** at the same path, with an isolated
`$HOME`, several times with different seeds and argument lists. Depending on the exercise the checker compares stdout, stderr (or just "there is an
error message"), the exit code, the resulting files (type, permissions, link count, content; archives by content), owners and mtimes, and custom state.
Some exercises also require or forbid a command or limit the number of lines. Because the fixtures are random, hard-coding the output does not pass.

## The 741 exercises

| # | topic | exercises |
|---|-------|-----------|
| 01 | echo, quoting & substitution | 28 |
| 02 | directories & navigation | 32 |
| 03 | files, copies & links | 45 |
| 04 | tar, gzip & compression | 30 |
| 05 | filters: wc head tail cut sort uniq tr sed tee... | 66 |
| 06 | grep & regular expressions | 47 |
| 07 | find | 56 |
| 08 | permissions, chmod, umask, chown | 38 |
| 09 | redirection | 31 |
| 10 | pipes, xargs, command substitution | 36 |
| 11 | variables, arithmetic, environment | 29 |
| 12 | processes, jobs, signals | 26 |
| 13 | script parameters & exit codes | 41 |
| 14 | test, if, case | 44 |
| 15 | loops, for, while, until, read | 51 |
| 16 | functions | 32 |
| 17 | users, groups, sessions, logs & cron | 40 |
| 18 | **exam-style scripts** (`deploy_bins.sh`, the log analyser `ipLog.sh` and many more) | 43 |
| 19 | theory quizzes as exercises | 10 |
| 20 | exam tasks with the manual open | 16 |

Difficulty goes ★☆☆☆☆ → ★★★★★. `exercises/INDEX.md` lists them all. Short of time? Do topics 07, 13, 14, 15 and then all of 18, or just follow
the suggested path.

## For maintenance

Sources are plain text and everything under `exercises/`, `solutions/`, `scripts/`, `script-exams/` and `theory/` is generated from them (never
overwriting your answers). Each kind has its own authoring guide.

| what | source | build / check | guide |
|---|---|---|---|
| exercises | `tools/src/*.txt` | `tools/build.sh`, `./lab tools/validate.sh [ids]` | `tools/AUTHORING.md` |
| scripts | `tools/src/scripts/*.txt` | `node tools/build_scripts.js`, `./lab tools/validate_scripts.sh [ids]` | `tools/SCRIPTS_AUTHORING.md` |
| script practice exams | `tools/src/script-exams/*.txt` | `node tools/build_script_exams.js`, `./lab tools/validate_script_exams.sh` | `tools/EXAMS_AUTHORING.md` |
| theory quizzes and exams | `tools/theory/*.txt` | `node tools/build_theory.js [exams]`, `node tools/exam_blueprint.js`, `node tools/exam_check.js` | `tools/THEORY_AUTHORING.md`, `tools/EXAMS_AUTHORING.md` |
| reference manual | `web/public/manual-*.js` | `./lab node tools/build_manual.js`, `node tools/manual_coverage.js` | `tools/MANUAL_AUTHORING.md` |
| suggested path | `web/public/path-data.js` | `node tools/path_check.js` | |
| import | `web/importer.js`, `web/scanner.js`, `web/import-prompt.md` | `node tools/test_scanner.js`, `node tools/gen_scanner_commands.js` | `web/import-prompt.md` |

Other pieces: `lib/engine.sh` is the checker (spec format at the top); `container/` is the image (users, fake logs, sessions, code-server);
`web/` is the web UI (`server.js`: the API, the terminal over a websocket and the proxy to code-server; `public/`: the pages); `lab` is the host
wrapper. Run the tools that need the lab with `./lab <command>`; the builders for theory, scripts and script exams, the scanner and the path
checks run on the host and need Node.js (any recent version).

## License

[PolyForm Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0) — see [LICENSE](LICENSE). Free for any noncommercial use
(personal, educational, research); commercial use is not permitted.
