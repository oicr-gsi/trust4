#!/bin/bash
cd $1
for t in *fa;do wc -l $t;done | sed 's! .*/.*!!'
for t in *tsv;do wc -l $t;done | sed 's! .*/.*!!'
for t in *out;do wc -l $t;done | sed 's! .*/.*!!'
