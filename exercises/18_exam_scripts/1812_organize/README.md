# 1812 · Organising files by extension

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** for, ${f##*.}, ${x,,}, mkdir -p, mv

Write `ordena.sh [DIR]` (default: current directory) that moves every **regular file directly inside**
`DIR` (not recursive, hidden files ignored) into a subdirectory of `DIR` named after its extension in
**lowercase** (`foto.JPG` → `DIR/jpg/foto.JPG`). Files without extension go to `DIR/other`.
The extension is the text after the **last** dot; a name like `README` has none.

Finally print one line per extension used, sorted: `<ext>: N files`.
If `DIR` is not a directory: stderr, exit 1.
