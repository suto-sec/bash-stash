# 1008 · Collecting files

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★☆☆☆ · **Commands:** find, xargs cp -t, mkdir

Create the directory `temporal` and copy into it every file ending in `.sh` found anywhere under
`$HOME` (the checker gives you a fake home with some scripts). Use `find ... | xargs cp -t temporal`
(or `xargs -I{} cp {} temporal`). No two scripts have the same name.
