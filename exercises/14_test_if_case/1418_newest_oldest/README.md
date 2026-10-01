# 1418 · The newest and the oldest

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** test -nt -ot -e, for

Write `ages.sh file...`. Among the arguments that exist (files, directories...), find the **newest**
(latest modification time) and the **oldest**, comparing with `-nt` / `-ot`, and print:

```
newest: <name>
oldest: <name>
```

On ties, the one that appears **first** among the arguments wins. Every argument that does not
exist is reported on **stderr** as `ignored: <name>` (in order) and otherwise ignored. If no argument
exists (or there are none), print `no files` on stderr and exit **1**.
