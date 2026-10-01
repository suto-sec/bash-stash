Write `cleanup.sh DIR`. It prints the path (as `find` shows it) of every **regular file** below `DIR` whose name ends in `.tmp` or in `~` **and** that was last modified **more than 7 days ago**. The order does not matter.

`find DIR -type f \( -name "*.tmp" -o -name "*~" \) -mtime +7`.
