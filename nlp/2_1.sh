#!/bin/bash
# tag: merge_upper
# set -e

# Merge upper and lower counts
IN=${IN:-$PWD/pg}
OUT=${OUT:-$PWD/output/2_1/}
ENTRIES=${ENTRIES:-10}
mkdir -p "$OUT"

for input in $(ls ${IN} | head -n ${ENTRIES})
do
    cat $IN/$input | tr '[a-z]' '[A-Z]' | tr -sc '[A-Z]' '[\012*]' | sort | uniq -c > ${OUT}/${input}.out
done

echo 'done';