# 0114 · Changing case with ${VAR^} and ${VAR,,}

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★☆☆ · **Commands:** ${v^}, ${v^^}, ${v,,}, ${#v}, ${v:0:1}

The file `person.txt` contains a first name and a last name separated by one space, written with
random upper/lower case (e.g. `aDA LoveLACE`). Using **parameter expansion** for the case changes
(no `tr`, `sed`...), print:

```
Name    : Ada Lovelace
Reversed: LOVELACE, Ada
Initials: A.L.
Login   : alovelace
Length  : 12
```

- `Name`: each word with its first letter uppercase and the rest lowercase, separated by one space
- `Reversed`: the last name all uppercase, a comma and a space, then the first name as in `Name`
- `Initials`: the two initials in uppercase, each followed by a dot
- `Login`: the first initial followed by the whole last name, all lowercase
- `Length`: the number of characters of the `Name` value (including the space)

Hint: `${v,,}` lowercases, `${v^}` uppercases the first letter, `${v^^}` everything, `${#v}` is the length.
