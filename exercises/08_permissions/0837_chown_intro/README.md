# 0837 · Quick refresher: chown

**Topic:** Permissions, chmod, umask, chown · **Difficulty:** ★☆☆☆☆ · **Commands:** chown

`chown NEWOWNER file` changes the owner of a file. Only root may do it, so the checker runs your script **as root** (in real life you would write `sudo chown ...`).

The file `informe.txt` exists in the current directory. Make `luke` its owner. Nothing is printed.

Afterwards `ls -l informe.txt` shows `luke` as the owner.

Hint: `chown luke file`
