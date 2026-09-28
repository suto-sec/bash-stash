#!/bin/bash
X=global
Y=global
f() {
  local X=local_f
  Y=changed_by_f
  echo "in f: X=$X Y=$Y"
}
echo "before: X=$X Y=$Y"
f
echo "after: X=$X Y=$Y"
Y=reset
R=$(f)
echo "$R"
echo "subshell: Y=$Y"

