#!/bin/sh

filename="input.txt"

is_safe() {
    list="$1"
    nol=$(printf "%s\n" "$list" | wc -l)

    is_increasing=1
    is_decreasing=1

    for i in $(seq 2 "$nol"); do
        x=$(printf "%s\n" "$list" | sed -n "$((i-1))p")
        y=$(printf "%s\n" "$list" | sed -n "${i}p")
        diff=$((y - x))
        diff_abs=${diff#-}
        if [ "$diff_abs" -lt 1 ] || [ "$diff_abs" -gt 3 ]; then
            is_increasing=0
            is_decreasing=0
            break
        fi
        [ "$diff" -lt 0 ] && is_increasing=0
        [ "$diff" -gt 0 ] && is_decreasing=0
    done

    [ "$is_increasing" -eq 1 ] || [ "$is_decreasing" -eq 1 ]
}

count_part1=0
count_part2=0

while IFS= read -r line; do
    list=$(printf "%s\n" "$line" | tr ' ' '\n')
    list_count=$(printf "%s\n" "$list" | wc -l)

    if is_safe "$list"; then
        count_part1=$((count_part1 + 1))
        count_part2=$((count_part2 + 1))
        continue 2
    fi

    for i in $(seq 1 "$list_count"); do
        temp_list=$(printf "%s\n" "$line" | tr ' ' '\n' | sed "${i}d")
        if is_safe "$temp_list"; then
            count_part2=$((count_part2 + 1))
            break
        fi
    done
done < "$filename"

printf "Part 1: %d\n" "$count_part1"
printf "Part 2: %d\n" "$count_part2"
