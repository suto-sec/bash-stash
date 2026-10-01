# 0717 · Skipping directories with -prune

**Topic:** find · **Difficulty:** ★★★☆☆ · **Commands:** find -prune -o -print, -path

Under `proj` there is a JavaScript project. Print, separated by a line `---`:

1. every **regular file** ending in `.js`, **sorted**, but without descending into any directory
   called exactly `node_modules` or `.git` (at any depth). Use `-prune`:
   `find proj \( ... \) -prune -o <conditions> -print`
2. the **number** of regular `.js` files that are somewhere **inside** a `node_modules` directory
   (at any depth), i.e. the ones you skipped in step 1 because of `node_modules`.

Careful with the decoys: a directory like `node_modules_old` or a file called `node_modules.js`
is **not** `node_modules`. Remember that with `-o` you need an explicit `-print` on the side you want.
