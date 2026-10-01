Write `cmpfiles.sh FILE1 FILE2`. It prints `same` when the two files have exactly the same content and `different` otherwise. Exit code 0 in both cases.

`cmp -s a b` succeeds silently when the files are identical.
