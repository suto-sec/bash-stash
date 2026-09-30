#!/bin/bash
# mkproj.sh name [lang] - create a project skeleton

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") name [sh|py|c]" >&2
  exit 1
fi
name=$1
lang=${2-sh}

if [[ ! $name =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]]; then
  echo "Error: invalid project name '$name'" >&2
  exit 2
fi
case $lang in
  sh | py | c) ;;
  *) echo "Error: unknown language '$lang'" >&2; exit 3 ;;
esac
# -e is false for a broken symlink, so also check -L
if [ -e "$name" ] || [ -L "$name" ]; then
  echo "Error: '$name' already exists" >&2
  exit 4
fi

mkdir -p "$name/src" "$name/tests"
echo "# $name" > "$name/README"
main=$name/src/main.$lang
case $lang in
  sh)
    printf '#!/bin/bash\necho "Hello from %s"\n' "$name" > "$main"
    chmod 755 "$main"
    ;;
  py) echo "print(\"Hello from $name\")" > "$main" ;;
  c)  echo 'int main(void) { return 0; }' > "$main" ;;
esac
echo "Project $name created ($lang)"

