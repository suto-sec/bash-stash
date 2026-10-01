Write `emptyfinder.sh DIR`. It prints the path of every **empty regular file** (size 0) anywhere below `DIR`, as `find` shows it. The order does not matter. Names may contain spaces.

`find DIR -type f -empty`.
