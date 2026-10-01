# 0608 · Extracting IPs with grep -o

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -oE

`acceso.log` contains lines with IPv4 addresses somewhere in the text. Print **only** the IP addresses
(`-o`), one per line, in order of appearance. An IP is 4 groups of 1-3 digits separated by dots.
