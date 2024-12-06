#!/bin/sh
deltaX="0 1 0 -1"
deltaY="-1 0 1 0"

nl -nln input.txt > copy.txt

max=$(wc -l < copy.txt)

linenum=$(sed -nE "s@([0-9]+) .*\^.*@\1@p" copy.txt)
line=$(sed -n "${linenum}p" copy.txt | sed -nE "s@[0-9]+[[:space:]]+(.*)@\1@p")
len_before=$(printf "%s\n" "$line" | sed 's/\^.*$//' | wc -c)
dir=0 # 0 for 'N'

visited=$(mktemp)

get_char_at_pos() {
  sed -n "${1}p" copy.txt | sed -nE "s@([0-9]+[[:space:]]+.{$2})(.).*@\2@p"
}

mark_position() {
  sed -i '' -E "${1}s/^([0-9]+[[:space:]]+.{$2})(.)/\1X/" copy.txt
  printf "${1},${2}\n" >> "$visited"
}

while :; do
  delta_x=$(printf "%s\n" "$deltaX" | cut -d ' ' -f $((dir + 1)))
  delta_y=$(printf "%s\n" "$deltaY" | cut -d ' ' -f $((dir + 1)))

  new_x=$((len_before + delta_x))
  new_y=$((linenum + delta_y))

  if [ $new_y -le 0 ] || [ $new_y -gt $max ]; then
    break
  fi

  char=$(get_char_at_pos "$new_y" "$((new_x - 1))")
  if [ "$char" = "#" ]; then
    dir=$(((dir + 1) % 4))
  else
    linenum=$new_y
    len_before=$new_x
    mark_position "$linenum" "$((len_before - 1))"
  fi
done

unique_positions=$(sort "$visited" | uniq | wc -l)
rm "$visited"

printf "Part 1: %s\n" "$unique_positions"
