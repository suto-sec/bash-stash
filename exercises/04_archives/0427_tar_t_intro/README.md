# 0427 · tar -t: listing an archive

**Topic:** tar, gzip & compression · **Difficulty:** ★☆☆☆☆ · **Commands:** tar -tf

`tar -t` lists the content of an archive without extracting anything.

The file `paquete.tar` exists in the current directory. Print the paths of the files stored inside it, one per line.

Expected output:

```
f1.txt
f2.txt
f3.txt
```

Hint: `tar -tf ARCHIVE.tar` (`t` = list, `f` = the archive's name follows).

---
Write your solution in `answer.sh`, then run `check 0427`.  
To experiment with the same test files the checker uses: `play 0427`.
