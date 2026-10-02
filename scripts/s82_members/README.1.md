A group file has one line per group: `name:x:gid:member1,member2,...` (the 4th field may be empty). Write `members.sh GROUP FILE`. It prints the members of the group called exactly `GROUP`, **one per line in the order they appear**. A group with no members prints nothing. Careful: `sudo` is not `sudoers`.

You may assume the group exists in this step.
