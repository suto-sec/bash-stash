# 0319 · Repairing broken links

**Topic:** Files, copies & links · **Difficulty:** ★★★☆☆ · **Commands:** test -L -e, readlink, basename, ln -sf, rm

The directory `links` contains symbolic links (some of them **broken**) and regular files. The directory
`repuesto` contains replacement files.

For every **broken** symbolic link directly inside `links` (order of the `links/*` glob), let `T` be the
last component (basename) of its stored target:

- if `repuesto/T` exists, replace the link by a new symbolic link with the same name whose stored
  target is `../repuesto/T`, and print `fixed NAME -> ../repuesto/T`
- otherwise delete the link and print `removed NAME`

(`NAME` is the link's name without the directory.) Working links and regular files are left alone.
Finish with the line `N fixed, M removed`.
