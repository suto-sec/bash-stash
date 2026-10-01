# 0315 · Recursive deletion and safe rmdir

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** rm -r, rmdir, 2>/dev/null

1. Delete the directory `pruebatar` and **all** its content with a single command.
2. The directory `vacios` contains several subdirectories: some are empty and some are not.
   Remove **only the empty ones** with one `rmdir` command, hiding its error messages
   (`2>/dev/null`). The script must end with exit code **0**.
