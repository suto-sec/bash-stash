# 0703 · Case-insensitive names

**Topic:** find · **Difficulty:** ★★☆☆☆ · **Commands:** find -iname, -path

Under `fotos`, print sorted:

1. files ending in `.jpg` in **any case** (`.JPG`, `.Jpg`...)
2. `---`
3. all entries (files **and** directories, no `-type`) whose path contains a directory called `2025` (`-path '*/2025/*'`)
