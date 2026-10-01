# 1026 · dirsizes.sh (size of every subdirectory)

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** find -mindepth -maxdepth, xargs -0, wc -c, sort -k

Write `dirsizes.sh`:

```
dirsizes.sh DIR
```

For every subdirectory **directly inside** `DIR` (first level only), compute the number of regular
files it contains (recursively) and their total size in bytes (the sum of the sizes of those files,
e.g. `find ... -print0 | xargs -0 cat | wc -c`). Print one line per subdirectory:

```
<bytes> <files> <name>
```

where `<name>` is just the subdirectory name (no path). Sort by bytes, biggest first; ties by name in
alphabetical order (as `sort` orders them). A subdirectory without files prints `0 0 <name>`.
Regular files placed directly in `DIR` are not counted anywhere. Finish with:

```
Total: <F> files, <B> bytes in <D> directories
```

Errors (message on **stderr**, nothing on stdout):

- not exactly one argument: error and the correct usage, exit **1**
- `DIR` does not exist: exit **2** (the message must include the name)
- `DIR` exists but is not a directory: exit **3** (the message must include the name)
- `DIR` has no subdirectories: exit **4**

Names may contain spaces.
