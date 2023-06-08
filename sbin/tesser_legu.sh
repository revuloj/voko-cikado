#!/bin/bash

for i in $*;
do
  echo "$i..."
  tesseract $i $i -l epo --psm 1
  cat $i.txt >> kune.txt
done