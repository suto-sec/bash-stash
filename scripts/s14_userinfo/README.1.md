Write `userinfo.sh FILE USER`. `FILE` has one user per line in the `/etc/passwd` layout (`name:x:uid:gid:comment:home:shell`). Print the **home directory** of `USER` (6th field). Only an exact name matches: `ana` is not `anaelle`.

`grep "^ana:" file` selects the line and `cut -d: -f6` the field.
