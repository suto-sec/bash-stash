# 1007 · Command substitution instead of xargs

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★☆☆☆ · **Commands:** $( ), `...`

Delete every file whose name ends in `~` under the current directory (at any depth), but this time using
**command substitution** instead of `xargs`: `rm $(find ...)`. (Like the previous exercise, the names have no spaces.)
