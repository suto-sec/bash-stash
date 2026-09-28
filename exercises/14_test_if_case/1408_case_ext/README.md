# 1408 · case: classify by extension

**Topic:** test, if & case · **Difficulty:** ★★☆☆☆ · **Commands:** case, patterns, |

For each argument (a file name), print `name: TYPE` where TYPE is:

- `image` for `.jpg`, `.jpeg`, `.png`, `.gif` (any case: also `.JPG`)
- `document` for `.pdf`, `.odt`, `.docx`, `.txt`
- `archive` for `.tar`, `.tgz`, `.tar.gz`, `.zip`
- `script` for `.sh`
- `unknown` otherwise

Use one `case` with patterns like `*.jpg|*.png)`.

---
Write your solution in `answer.sh`, then run `check 1408`.  
To experiment with the same test files the checker uses: `play 1408`.
