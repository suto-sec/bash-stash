# 0742 · \( -o \) and ! : a precedence trap with -path

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find \( -o \), !, -path, -type f

Under `cache`, print **sorted** the regular files whose name ends in `.tmp` or `.cache`, **excluding**
any that live (at any depth) inside a directory called exactly `keep`.

This is a precedence trap: `find cache -type f -name '*.tmp' -o -name '*.cache' ! -path '*/keep/*'`
is **wrong** — `-o` binds looser than the implicit AND between tests, so the `!` exclusion only
applies to the second branch of the `-o`. You must group the OR explicitly:
`\( -name '*.tmp' -o -name '*.cache' \) ! -path '*/keep/*'`.

Watch the decoys: a directory literally called `keeper` is **not** `keep` (its files must stay), and
a top-level file called `keep.tmp` is not *inside* a directory called `keep` (it must stay too).
