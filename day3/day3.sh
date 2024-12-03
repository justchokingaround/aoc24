#!/bin/sh

filename="input.txt"

lines=$(sed 's/mul/\nmul/g' "$filename" | sed -nE "s@mul\(([0-9]+)\,([0-9]+)\).*@\1 \2@p")

sum1=0
while IFS= read -r line; do
    x=$(printf "%s" "$line" | cut -d' ' -f1)
    y=$(printf "%s" "$line" | cut -d' ' -f2)
    sum1=$((sum1 + x * y))
done < <(printf "%s\n" "$lines")

sum2=0
file=$(cat "$filename" | tr -d '\n')
lines=$(printf "%s\n" "$file" | sed 's/^/do()/g;s/do/\n/g')
while IFS= read -r line; do
    if [ "${line:0:2}" == "()" ]; then
        nums=$(printf "%s\n" "$line" | sed 's/mul/\nmul/g' | sed -nE "s@mul\(([0-9]+)\,([0-9]+)\).*@\1 \2@p")
        while IFS= read -r num; do
            x=$(printf "%s\n" "$num" | cut -d' ' -f1)
            y=$(printf "%s\n" "$num" | cut -d' ' -f2)
            sum2=$((sum2 + x * y))
        done < <(printf "%s\n" "$nums")
    fi
done < <(printf "%s\n" "$lines")

printf "Part 1: %s\n" "$sum1"
printf "Part 2: %s\n" "$sum2"
