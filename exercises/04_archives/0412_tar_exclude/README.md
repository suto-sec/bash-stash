# 0412 · Archiving while excluding a subdirectory

**Topic:** tar, gzip & compression · **Difficulty:** ★★★☆☆ · **Commands:** tar -czf --exclude, tar -tzf

Create a compressed archive `codigo.tgz` with everything under `proyecto` (paths inside must
start with `proyecto/`), **excluding** the subdirectory `proyecto/tmp` and everything inside it
(see `tar --exclude`).

Then, without extracting, print the number of entries the archive contains
(`tar -tzf codigo.tgz | wc -l`).
