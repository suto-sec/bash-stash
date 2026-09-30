# 0725 · What can I read, enter and write?

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -readable, -writable, -executable, 2>/dev/null

Under `share` some files and directories have restrictive permissions. Using the tests that check
**your** real access (`-readable`, `-writable`, `-executable`, negated with `!` when needed), print
separated by `---`, each list sorted:

1. the regular files you **cannot read**
2. the directories you **cannot enter** (no execute permission for you)
3. the regular files ending in `.txt` that you **can write**

find will complain on stderr about directories it cannot open: hide those messages
(`2>/dev/null`). Entries inside directories that find cannot open are simply not listed.

---
Write your solution in `answer.sh`, then run `check 0725`.  
To experiment with the same test files the checker uses: `play 0725`.
