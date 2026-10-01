# 0728 · bigfiles.sh: files over a size

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -size Nc, stat, sort, validation, exit codes

Write `bigfiles.sh`:

```
bigfiles.sh DIR KB
```

It lists every **regular file** under `DIR` (recursively) whose size is **strictly greater than
KB kibibytes** (`KB * 1024` bytes), one per line as

```
<bytes> <path>
```

from biggest to smallest; ties by path (alphabetical). The path is as `find` prints it (starting with
`DIR` as given). Then it prints the summary line `N files, T bytes` (T = sum of the listed sizes).

Careful: `-size +4k` does **not** mean "more than 4096 bytes" (find rounds sizes up to whole units);
work in bytes (`c`).

Checks, **in this order** (messages on **stderr**, wording free):

- not exactly 2 arguments: usage message, exit **1**
- `DIR` is not a directory (or doesn't exist): message including `DIR`, exit **2**
- `KB` is not a non-negative integer (only digits): message including `KB`, exit **3**

If no file is big enough, print just `0 files, 0 bytes` and exit **4**. Otherwise exit 0.
File names may contain spaces.
