Write `archiver.sh DIR`. It creates `$HOME/archives/NAME.tgz`, a gzip-compressed tar archive of the directory `DIR`, where `NAME` is the name of `DIR` (without its path); `$HOME/archives` already exists in this step. Inside the archive the files are stored under `NAME/`. Print `Created <full path of the archive>`.

`tar czf archive.tgz -C "$(dirname dir)" "$(basename dir)"` stores the directory under its own name.
