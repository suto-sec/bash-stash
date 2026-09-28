# 0402 · Listing an archive

**Topic:** tar, gzip & compression · **Difficulty:** ★★☆☆☆ · **Commands:** tar -tzf, tar -tvzf

The file `backup.tgz` exists in the current directory. Without extracting it, print:

1. the list of paths it contains (just the names, as `tar` lists them)
2. a line `---`
3. only the number of entries (`tar ... | wc -l`)

---
Write your solution in `answer.sh`, then run `check 0402`.  
To experiment with the same test files the checker uses: `play 0402`.
