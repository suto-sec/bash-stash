Write `tgzclean.sh FILE.tgz`. It removes from inside the archive **every file bigger than 8 KB (more than 8192 bytes)**; all other members keep their path and content. The archive keeps its name (it is rewritten). Print `Removed N files` (N = how many were removed).

Plan: `mktemp -d`, extract there, delete with `find ... -size +8192c`, create the archive again with `tar -czf ARCHIVE -C TMP .`, remove the temporary directory. Use the **absolute** path of the archive if you `cd`.
