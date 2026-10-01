# 0906 · Here documents

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★☆☆☆ · **Commands:** << EOF, << 'EOF'

Create the file `config.ini` with a **here document** (`cat > config.ini << EOF`) so that it contains
(with `<user>` and `<home>` being the values of `$USER` and `$HOME`):

```
[usuario]
nombre=<user>
home=<home>
```

Then **append** to it, with a second here document whose delimiter is **quoted** (no expansion),
exactly these lines:

```
[notas]
# $HOME is not expanded here
precio=5$
```
