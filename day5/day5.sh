#!/bin/sh

filename="input.txt"

rules=$(sed -n '/^$/q;p' "$filename")
lines=$(sed -n '/^$/,$p' "$filename" | sed 1d)

# part 1
part1_lines="$lines"
while IFS='|' read -r first second; do
    part1_lines=$(printf "%s\n" "$part1_lines" | sed -n "/.*${second}.*${first}/!p")
done <<EOF
$(printf "%s\n" "$rules")
EOF

for line in $part1_lines; do
    length=$(printf "%s\n" "$line" | tr ',' '\n' | wc -l)
    middle=$((length / 2))
    middle_value=$(printf "%s\n" "$line" | cut -d',' -f $((middle + 1)))
    sum1=$((sum1 + middle_value))
done
printf "Part 1: %s\n" "$sum1"

# part 2
incorrect_lines="$lines"
while IFS='|' read -r first second; do
    lines=$(printf "%s\n" "$lines" | sed -n "/.*${second}.*${first}/!p")
done <<EOF
$(printf "%s\n" "$rules")
EOF

while IFS= read -r line; do
    incorrect_lines=$(printf "%s\n" "$incorrect_lines" | sed -n "/${line}/!p")
done <<EOF
$(printf "%s\n" "$lines")
EOF

comes_before() {
    if printf "%s\n" "$rules" | grep -q "^$1|$2$"; then
        return 0
    fi
    if printf "%s\n" "$rules" | grep -q "^$2|$1$"; then
        return 1
    fi
    return 1
}

while read -r line; do
    nums=$(printf "%s\n" "$line" | tr ',' '\n')
    list=$(printf "%s\n" "$line" | tr ',' ' ')
    sorted=""
    for item in $list; do
        if [ -z "$sorted" ]; then
            sorted="$item"
        else
            inserted=0
            new_sorted=""
            for sorted_item in $sorted; do
                if [ "$inserted" -eq 0 ] && comes_before "$item" "$sorted_item"; then
                    new_sorted="$new_sorted $item"
                    inserted=1
                fi
                new_sorted="$new_sorted $sorted_item"
            done
            if [ "$inserted" -eq 0 ]; then
                new_sorted="$new_sorted $item"
            fi
            sorted="$new_sorted"
        fi
    done
    sorted_list=$(printf "%s\n" "$sorted" | tr ' ' '\n' | sed 1d)
    sorted_list_len=$(printf "%s\n" "$sorted_list" | wc -l)
    mid=$((sorted_list_len / 2 + 1))
    middle_value=$(printf "%s\n" "$sorted_list" | sed -n "${mid}p")
    sum2=$((sum2 + middle_value))
done <<EOF
$(printf "%s\n" "$incorrect_lines")
EOF

printf "Part 2: %s\n" "$sum2"
