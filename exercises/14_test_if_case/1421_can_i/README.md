# 1421 · Can I do it? (case + permission tests)

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** case, test -f -d -r -w -x -e, dirname, $?

Write `cani.sh action path`. Print `yes` (exit **0**) or `no` (exit **1**) depending on the action:

| action | yes when |
|--------|----------|
| `read` | `path` is a regular file and you can read it |
| `write` | `path` is a regular file and you can write it |
| `run` | `path` is a regular file and you can execute it |
| `enter` | `path` is a directory and you can enter it (`x`) |
| `list` | `path` is a directory and you can read it (`r`) |
| `create` | `path` does not exist, and its parent (`dirname`) is a directory you can write **and** enter |

Errors (stderr, exact text, exit **2**): not exactly 2 arguments → `Usage: cani.sh action path`
(use `$(basename "$0")`); unknown action → `unknown action: <action>`.

Use one `case` on the action. (Tip: the exit status of a `case` is the one of the last command it ran.)

---
Write your solution in `answer.sh`, then run `check 1421`.  
To experiment with the same test files the checker uses: `play 1421`.
