#!/bin/bash
# tag: 2-syllable words
# set -e

IN=${IN:-$PWD/pg}
OUT=${OUT:-$PWD/output/6_5/}
ENTRIES=${ENTRIES:-10}
mkdir -p "$OUT"

for input in $(ls ${IN} | head -n ${ENTRIES})
do
    cat $IN/$input  | tr -sc '[A-Z][a-z]' ' [\012*]' | grep -i '^[^aeiou]*[aeiou][^aeiou]*[aeiou][^aeiou]$' | sort | uniq -c | sed 5q > ${OUT}${input}.out
done

echo 'done';