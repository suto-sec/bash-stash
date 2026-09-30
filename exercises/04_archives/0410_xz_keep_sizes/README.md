# 0410 · xz -k and measuring sizes

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** xz -k, stat -c%s

The directory `reportes` contains several `.rpt` files of different sizes, and a file
`aviso.log` that must not be touched.

For every `.rpt` file directly inside `reportes`, **in the order given by the `*.rpt` glob**:

1. Compress it with `xz`, **keeping** the original file too (see `xz -k`).
2. Print a line:

   ```
   <file>: <original_bytes> -> <compressed_bytes> bytes
   ```

   where `<file>` is the path as matched by the glob (e.g. `reportes/alpha1.rpt`), and both sizes
   are measured with `stat -c%s` — the original size **before** compressing, the compressed size
   **after**.

Finally print `Total: N files processed`.

---
Write your solution in `answer.sh`, then run `check 0410`.  
To experiment with the same test files the checker uses: `play 0410`.
