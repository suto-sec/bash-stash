Write `tgzinfo.sh FILE.tgz`. It prints three lines about the members of the gzip-compressed tar archive (`tar -tzf` lists them; a **directory** entry ends in `/`, including the archive's own `./`):

```
Entries: 12
Directories: 4
Files: 8
```
`Entries` counts every member; `Directories` those ending in `/`; `Files` the rest.
