# 0912 · Swapping stdout and stderr

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★★ · **Commands:** 3>&1 1>&2 2>&3

Run `./ruidoso.sh` so that its **stdout goes to your stderr** and its **stderr goes to your stdout**
(swap them), then pipe only its (original) **errors** through `tr a-z A-Z`. The original normal output
must still appear (on stderr) unchanged.

Hint: `./ruidoso.sh 3>&1 1>&2 2>&3 | tr a-z A-Z`
