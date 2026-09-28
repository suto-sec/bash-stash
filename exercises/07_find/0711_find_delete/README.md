# 0711 · Deleting found files

**Topic:** find · **Difficulty:** ★★☆☆☆ · **Commands:** find -delete, -exec rm

Delete every regular file under the current directory whose name ends in `~` (backup files),
at any depth. Directories ending in `~` must stay.

---
Write your solution in `answer.sh`, then run `check 0711`.  
To experiment with the same test files the checker uses: `play 0711`.
