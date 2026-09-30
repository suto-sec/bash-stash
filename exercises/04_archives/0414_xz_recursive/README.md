# 0414 · Recursive compression without gzip -r

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** find -type f, xz, wc -l

Recursively compress, **in place**, every regular file under the directory `datos` using `xz`
(each file becomes `<file>.xz`, keeping its path; empty directories are left as they are). Do not
touch anything outside `datos` (there is a decoy file `afuera.txt` at the top level).

`xz` has no `-r` option like `gzip`, so you'll need to locate the files yourself (hint:
`find datos -type f`).

Finally print `Compressed N files.` where `N` is the number of `.xz` files now under `datos`.

---
Write your solution in `answer.sh`, then run `check 0414`.  
To experiment with the same test files the checker uses: `play 0414`.
