# 0724 · Same name in several places

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -type f, sed, sort, uniq -d

Under `music` there are files with the same **name** in different directories. Print:

1. the **names** (without the directory part) of the regular files that appear in **more than one**
   directory, sorted, once each
2. `---`
3. the number of **different** names of regular files under `music`

Directories don't count, even if they have the same name as a file. Some names have spaces.
Hint: remove everything up to the last `/` with `sed`.
