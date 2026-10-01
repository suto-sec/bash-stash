# 1838 · Removing broken symbolic links

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -xtype l, readlink, rm

Write `fix_broken_links.sh DIR`. It finds every **broken symbolic link** under `DIR` (recursively;
a broken link is one whose target does not exist, `find -xtype l`), prints
`broken: <path> -> <target>` (`<target>` as `readlink` reports it, sorted by path), removes each of
them (`rm`), and finally prints `Removed N broken links`.

Checks, in this order:
- not exactly 1 argument: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.

Valid (non-broken) symbolic links are left untouched and never printed.
