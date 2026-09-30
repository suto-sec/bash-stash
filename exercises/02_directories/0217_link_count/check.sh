# checker spec for 0217 (see lib/engine.sh)
setup() {
  local i j d
  mkdir proj
  for i in $(seq "$(randr 2 5)"); do
    d="proj/$(word)$i"; mkdir "$d"
    for j in $(seq 0 "$(randr 0 4)"); do
      case $(rand 3) in 0) mkdir "$d/$(word)$j" ;; 1) mkdir "$d/.$(word)$j" ;; *) touch "$d/$(word)$j.txt" ;; esac
    done
  done
  mkdir "proj/.hidden$(word)"; touch "proj/file.txt"
}
extra_check() { must_not_use find tree; }
