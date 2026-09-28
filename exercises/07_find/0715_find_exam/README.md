# 0715 · The exam filter

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -type f -perm /111 \( -name -o -name \)

This is the core of the exam-style deploy script (1801). Under `src` (recursively), print sorted the **regular files**
(not directories) that have **some** execute permission enabled (user, group or other) and whose
name ends in `.sh` **or** `.bin`.

---
Write your solution in `answer.sh`, then run `check 0715`.  
To experiment with the same test files the checker uses: `play 0715`.
