# checker spec for 1433 (see lib/engine.sh)
SCRIPT_NAME=cmp_dirs.sh
SEEDS=4
COMPARE="stdout exit errmsg"
setup() {
  local i n
  mkdir left "right side"
  for ((i = 1; i <= $(randr 4 7); i++)); do
    n=$(pick "$(word)$i" "my $(word)$i").txt
    case $(rand 7) in
      0) words 3 > "left/$n"; touch -d "2025-02-0$(randr 1 3) 10:00" "left/$n" ;;
      1) words 3 > "right side/$n"; touch -d "2025-02-01 10:00" "right side/$n" ;;
      2) words 3 > "left/$n"; cp "left/$n" "right side/$n"
         touch -d "2025-02-0$(randr 1 3) 10:00" "left/$n" "right side/$n" ;;
      3) words 3 > "left/$n"; words 2 > "right side/$n"
         touch -d "2025-02-0$(randr 1 3) 10:00" "left/$n"; touch -d "2025-02-0$(randr 1 3) 10:00" "right side/$n" ;;
      4) words 3 > "left/$n"; mkdir "right side/$n" ;;
      5) mkdir "left/$n"; words 1 > "right side/$n" ;;
      6) words 3 > "left/$n"; words 2 > "right side/$n"; touch -d "2025-02-02 10:00" "left/$n" "right side/$n" ;;
    esac
  done
  echo h > "left/.hidden"
  cp -rp left copy
  echo x > file.txt
}
ARGS=('left "right side"' '"right side" left' 'left copy' 'left left' 'left "$W/left"' 'left nodir' 'file.txt left' 'nodir nodir2' '' 'left' 'a b c' '"$W/right side" copy')
extra_check() {
  local tok
  if [[ $REF_CODE == [34] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
