#!/bin/bash

export folder=$(find ~/ -name "$@" -type d)
export files=$(find ${folder} -name "MVI*.MOV" -type f)
mkdir -p ${folder}/compr


for file in ${files}
do
  old=${file%.MOV}
  new=${old}-smaller.mp4
  echo ${new}
  out=$(basename $new)
  echo ${out}
  echo ${folder}/compr/${out}	
  time ffmpeg -y -i "${file}" -r 25 -c:v libx264 -preset slower -crf 23 -pix_fmt yuvj420p -c:a libmp3lame -b:a 128k "${folder}/compr/${out}"
  touch -r ${file} "${folder}/compr/${out}"
done
