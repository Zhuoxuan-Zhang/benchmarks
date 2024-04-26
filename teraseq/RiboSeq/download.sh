#!/bin/bash

set -e # dliu

cd /root/TERA-Seq_manuscript/samples # dliu

source ../PARAMS.sh

samples=(
    "hsa.RiboSeq.HeLa.async.2"
)

echo ">>> MAKE DIRECTORY STRUCTURE <<<"

for i in "${samples[@]}"; do
    sdir=$SAMPLE_DIR/$i
    echo " Working for" $i

    mkdir -p $sdir/logfiles || true # dliu
    mkdir $sdir/align || true # dliu
    mkdir $sdir/db || true # dliu
done

echo ">>> CHECK FASTQ <<<"

for i in "${samples[@]}"; do
    sdir=$SAMPLE_DIR/$i
    echo " Working for" $i

    if [ -f "$sdir/fastq/reads.1.fastq.gz" ]; then
        echo "$sdir/fastq/reads.1.fastq.gz is present, continue."
    else
        echo "$sdir/fastq/reads.1.fastq.gz does not exist, trying to download."
        download=$(cat README.md | grep download | grep $i | cut -d '|' -f 4 | cut -d '(' -f2  | sed 's/)//' | sed 's#https://##')
        mkdir $sdir/fastq || true # dliu
        wget $download --progress=bar:force -O $sdir/fastq/reads.1.fastq.gz
    fi
done

echo ">>> ALL DONE <<<"