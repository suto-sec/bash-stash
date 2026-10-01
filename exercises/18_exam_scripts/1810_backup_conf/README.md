# 1810 · Backing up configuration files

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -name, tar -czf -C, mkdir -p, relative/absolute paths

Write `backup_conf.sh SRC [DEST]` that archives every **regular** file ending in `.conf` under `SRC`
(recursively) into `DEST/conf_backup.tgz`. Paths inside the archive are **relative to SRC**
(e.g. `nginx/site.conf`). `DEST` defaults to `$HOME/backups`; if it does not exist create it and print
`Created <DEST>`. Then print `Archived N files into <DEST>/conf_backup.tgz` (DEST as given / default).

- no arguments or more than 2: usage on stderr, exit 1
- `SRC` is not a directory: stderr, exit 2
- no `.conf` files: stderr message, exit 3 and **no** archive is created

Careful: `SRC` and `DEST` may be relative; if you `cd` into `SRC`, relative `DEST` breaks.
