#!/bin/bash
cd $1

#
# We have three types of files to check
#  .fa files - 
# .tsv files -
# .out files -

echo ".fa files:" 
for t in *fa;do md5sum $t;done | sort -V
echo ".tsv files:"
for t in *tsv;do md5sum $t;done | sort -V
echo ".out files:"
for t in *out;do md5sum $t;done | sort -V
