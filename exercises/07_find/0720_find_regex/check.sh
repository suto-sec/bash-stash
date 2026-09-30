# checker spec for 0720 (see lib/engine.sh)
setup() {
  mkdir -p camera/2024-05-01 camera/misc "camera/old stuff"
  local i d
  for i in $(seq 14); do
    d="camera/$(pick . 2024-05-01 misc 'old stuff')"
    case $(rand 12) in
      0|1|2) touch "$d/IMG_$(randr 1000 9999).jpg" ;;
      3)      touch "$d/IMG_$(randr 1000 9999).jpeg" ;;
      4)      touch "$d/IMG_$(randr 100 999).jpg" "$d/IMG_$(randr 10000 99999).jpeg" ;;
      5)      touch "$d/img_$(randr 1000 9999).jpg" "$d/IMG_$(randr 1000 9999).JPG" ;;
      6)      touch "$d/IMG_$(randr 1000 9999).jpg.bak" "$d/IMG_abcd.jpg" ;;
      7|8)    touch "$d/$(word) 202$(rand 6)-0$(randr 1 9)-$(randr 10 28).txt" ;;
      9)      touch "$d/backup-2023-11-0$(randr 1 9).tar" ;;
      10)     touch "$d/2024-5-$(randr 1 9) $(word).txt" "$d/$(word)$i.txt" ;;
      11)     mkdir -p "$d/IMG_$(randr 1000 9999).jpg" ;;
    esac
  done
  touch camera/2024-05-01/notes.txt
}
