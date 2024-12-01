#!/bin/sh

filename="input.txt"
input=$(cat $filename | sed -nE "s@([0-9]+)[[:space:]]*([0-9]+)@\1 \2@p")

first=$(printf "%s\n" "$input" | cut -f1 -d' ' | sort -n)
second=$(printf "%s\n" "$input" | cut -f2 -d' ' | sort -n)
nol=$(wc -l < $filename)

part1=0
part2=0
for i in $(seq 1 $nol); do
    x=$(printf "%s\n" "$first" | sed -n ${i}p)
    y=$(printf "%s\n" "$second" | sed -n ${i}p)
    n=$(printf "%s\n" "$second" | grep "^$x$" | wc -l)
    if [ "$x" != "$y" ]; then
        [ "$x" -gt "$y" ] && diff=$(($x - $y)) || diff=$(($y - $x))
        part1=$(($part1 + $diff))
    fi
    part2=$(($part2 + $(($x * $n))))
done
printf "Part 1: %s\n" "$part1"
printf "Part 2: %s\n" "$part2"
