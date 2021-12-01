#!/bin/bash
cd $1

#
# We have three types of files to check
#  .fa files - stable, may be md5summed directly
# .tsv files - there is some stochasticity, some rows may shift. High-precision values may change
# .out files - stable, may calculate md5sum directly

echo ".fa files:" 
for t in *fa;do md5sum $t;done | sort -V
echo ".tsv files:"
for t in *tsv;do cut -f 3- $t | sort -V -k 3,4 | md5sum;done | sort -V
echo ".out files:"
for t in *out;do md5sum $t;done | sort -V
