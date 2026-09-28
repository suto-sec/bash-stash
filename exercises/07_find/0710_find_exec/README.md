# 0710 · Running a command on every result

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -exec {} \;, -exec {} +

Under `scripts` (recursively), **add execute permission for the user** to every regular file ending in
`.sh`, using `find ... -exec chmod ...`. Nothing to print.

---
Write your solution in `answer.sh`, then run `check 0710`.  
To experiment with the same test files the checker uses: `play 0710`.
