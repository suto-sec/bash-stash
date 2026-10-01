# 0756 · Quick refresher: find -exec

**Topic:** find · **Difficulty:** ★☆☆☆☆ · **Commands:** find -exec {} \;

`-exec COMMAND {} \;` runs `COMMAND` once for every file that `find` finds; `{}` stands for the file's name.

Under the directory `scripts` there are some `.sh` files (also in a subdirectory) and a `.txt` file. With **one** `find` command, give the owner execute permission to every file that ends in `.sh` (`chmod u+x`). Nothing is printed. The `.txt` file must not change.

Hint: `find dir -name '*.sh' -exec chmod u+x {} \;`. Afterwards `ls -l scripts` shows an `x` in the owner's permissions of the `.sh` files.
