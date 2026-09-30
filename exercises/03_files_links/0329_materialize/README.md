# 0329 · materialize.sh (links into real copies)

**Topic:** Files, copies & links · **Difficulty:** ★★★★☆ · **Commands:** test -L -e -d, readlink -f, cp -r, rm, exit codes

Write `materialize.sh DIR` that replaces every **symbolic link directly inside** `DIR` by a real copy of
what it points to, so the directory can be shipped without its links:

- link to a regular file → the link is replaced by a copy of the file (same name as the link);
  print `NAME: file`
- link to a directory → replaced by a recursive copy of the directory; print `NAME: dir`
- **broken** link → left as it is; print `broken: NAME` on **stderr**

(`NAME` is the link's name, without the directory.) Links are processed in the order of the `DIR/*`
glob; links may point to other links. Use plain `cp` / `cp -r` (no `-p`). Other entries are not
touched. Finally print `Replaced N links, M broken`.

Exit codes: **1** not exactly one argument (usage on stderr); **2** `DIR` is not a directory (stderr);
**3** if at least one broken link was found; **0** otherwise.

---
Write your solution in `answer.sh`, then run `check 0329`.  
To experiment with the same test files the checker uses: `play 0329`.
