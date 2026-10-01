# 0734 · badlinks.sh: broken symbolic links

**Topic:** find · **Difficulty:** ★★★★☆ · **Commands:** find -xtype l, readlink, option parsing, rm

Write `badlinks.sh`:

```
badlinks.sh [-d] DIR
```

It finds the **broken symbolic links** under `DIR` (recursively): links whose final target does not
exist (a link to a broken link is broken too). For each one, in sorted path order, print

```
<path> -> <target>
```

where `<target>` is the link's content exactly as `readlink` prints it, and the path is as `find`
prints it. Then print `N broken links found`.

With the option `-d` (only allowed as the **first** argument) the broken links are also **deleted**:
the lines are printed as `deleted <path> -> <target>` and the summary is `N broken links deleted`.
Valid links, files and directories are never touched.

Errors (stderr, wording free):

- missing `DIR`, too many arguments, or an unknown option (a first argument starting with `-`
  other than `-d`): usage, exit **1**
- `DIR` is not a directory: exit **2**

Names may contain spaces.
