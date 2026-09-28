# 0606 · Alternatives with grep -E

**Topic:** grep & regular expressions · **Difficulty:** ★★☆☆☆ · **Commands:** grep -E, |

Print the words of `/usr/share/dict/words` that contain `car` **or** `truck`, but only those that
**start** with one of those two strings. Use one `grep -E` with a group: `^(...|...)`.

---
Write your solution in `answer.sh`, then run `check 0606`.  
To experiment with the same test files the checker uses: `play 0606`.
