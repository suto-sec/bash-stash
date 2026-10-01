# 1022 · Numbered pages with seq and xargs

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★☆☆ · **Commands:** seq -f, xargs -I{}, xargs, ls

`n.txt` contains a number N (between 4 and 15). Using `seq` piped to `xargs` (**no loops**):

1. Create the directory `pages` and, inside it, N copies of `template.txt` named
   `page_01.txt`, `page_02.txt`, ..., always with **two digits** (`seq -f '%02g'`).
2. Delete the **even** pages (`page_02.txt`, `page_04.txt`, ...). Hint: `seq -f` can build the whole
   path: `seq -f 'pages/page_%02g.txt' 2 2 N`.
3. Print how many files are left in `pages`, and then, on one line separated by spaces, their names
   in `ls` order (`ls pages | xargs`).
