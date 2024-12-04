#!/bin/sh

check_for_xmas_part1() {
    check_direction() {
        second_line=$(printf "%s\n" "$lines" | sed -n "${2}p")
        [ "${second_line:$(( $1 - 1 )):1}" != "M" ] && return 1
        third_line=$(printf "%s\n" "$lines" | sed -n "${4}p")
        [ "${third_line:$(( $3 - 1 )):1}" != "A" ] && return 1
        fourth_line=$(printf "%s\n" "$lines" | sed -n "${6}p")
        [ "${fourth_line:$(( $5 - 1 )):1}" != "S" ] && return 1
        counter1=$((counter1 + 1))
    }
    if [ $2 -gt 3 ]; then #N
        check_direction $1 $(($2 - 1)) $1 $(($2 - 2)) $1 $(($2 - 3))
        if [ $(( $1 + 3 )) -le $noc ]; then # NE
            check_direction $(($1 + 1)) $(($2 - 1)) $(($1 + 2)) $(($2 - 2)) $(($1 + 3)) $(($2 - 3))
        fi
    fi
    if [ $(( $1 + 3 )) -le $noc ]; then # E
        check_direction $(($1 + 1)) $2 $(($1 + 2)) $2 $(($1 + 3)) $2
        if [ $(( $2 + 3 )) -le $nol ]; then # SE
            check_direction $(($1 + 1)) $(($2 + 1)) $(($1 + 2)) $(($2 + 2)) $(($1 + 3)) $(($2 + 3))
        fi
    fi
    if [ $(( $2 + 3 )) -le $nol ]; then # S
        check_direction $1 $(($2 + 1)) $1 $(($2 + 2)) $1 $(($2 + 3))
        if [ $1 -gt 3 ]; then # SW
            check_direction $(($1 - 1)) $(($2 + 1)) $(($1 - 2)) $(($2 + 2)) $(($1 - 3)) $(($2 + 3))
        fi
    fi
    if [ $1 -gt 3 ]; then # W
        check_direction $(($1 - 1)) $2 $(($1 - 2)) $2 $(($1 - 3)) $2
        if [ $2 -gt 3 ]; then # NW
            check_direction $(($1 - 1)) $(($2 - 1)) $(($1 - 2)) $(($2 - 2)) $(($1 - 3)) $(($2 - 3))
        fi
    fi
}

check_for_xmas_part2() {
    check_mas() {
        first_char=$3
        first_line=$(printf "%s\n" "$lines" | sed -n "$2p")
        second_char=${first_line:$(( $1 + 1 )):1}
        if [ "$second_char" != "M" -a "$second_char" != "S" ]; then
            return 1
        fi
        second_line=$(printf "%s\n" "$lines" | sed -n "$(($2 + 1))p")
        a_char=${second_line:$1:1}
        [ "$a_char" != "A" ] && return 1
        third_line=$(printf "%s\n" "$lines" | sed -n "$(($2 + 2))p")
        fourth_char=${third_line:$(( $1 - 1 )):1}
        if [ "$second_char" = "M" ]; then
            if [ "$fourth_char" != "S" ]; then
                return 1
            fi
        else
            if [ "$fourth_char" != "M" ]; then
                return 1
            fi
        fi
        fifth_char=${third_line:$(( $1 + 1 )):1}
        if [ "$first_char" = "M" ]; then
            if [ "$fifth_char" != "S" ]; then
                return 1
            fi
        else
            if [ "$fifth_char" != "M" ]; then
                return 1
            fi
        fi
        counter2=$((counter2+1))
    }
    check_mas $1 $2 $3
}
lines=$(cat input.txt)
nol=$(wc -l < input.txt)
noc=$(head -1 input.txt | wc -c)
line_counter=1
while read -r line; do
    chars=$(printf "%s" "$line" | grep -o .)
    char_counter=1
    for char in $chars; do
        if [ "$char" = "X" ]; then
            check_for_xmas_part1 "$char_counter" "$line_counter"
        fi
        if [ "$char" = "M" -o "$char" = "S" ]; then
            check_for_xmas_part2 "$char_counter" "$line_counter" "$char"
        fi
        char_counter=$((char_counter+1))
    done
    line_counter=$((line_counter+1))
done < input.txt

printf "Part 1: %s\n" "$counter1"
printf "Part 2: %s\n" "$counter2"
