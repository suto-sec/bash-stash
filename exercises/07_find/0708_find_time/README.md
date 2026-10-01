# 0708 · Searching by modification time

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -mtime, -newer

The files in `logs` have different modification dates. Print sorted, separated by `---`:

1. files modified **more than 7 days** ago (`-mtime +7`)
2. files modified in the **last 3 days** (`-mtime -3`)
3. files **newer** than `logs/referencia` (`-newer`)
