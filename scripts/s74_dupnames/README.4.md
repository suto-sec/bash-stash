Finish with `N repeated names` (N = how many names were listed). If there are none print `No repeated names` instead and exit **4**; otherwise exit 0.

Careful: a name like `*` or `[x]` must be matched literally by `find -name`... in this fixture none is special, so `-name "$name"` is fine.
