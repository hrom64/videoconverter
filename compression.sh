#!/bin/bash

CPU_temp()
{
echo $(date +%Y-%m-%dT%H:%M:%S) "||" "${file}" "||" "CPU temperature: $(sensors | grep 'Core 0'|awk '{print $1, $2, $3 }')" "||" "$(sensors | grep 'Core 1'|awk '{print $1, $2, $3 }')"
}

file="Program started"
dir=$(find ~/ -name "$1" -type d)
files=$(find ${dir} -name "*MOV" -type f)

if [ -f "log.txt" ]
then
   cat log.txt >> log.old 
fi

CPU_temp> log.txt

mkdir -p ${dir}/compr


for file in ${files}
do
  old=${file%.*}
  new=${old}-smaller.mp4
  out=$(basename $new)
  time ffmpeg -y -i "${file}" -r 25 -c:v libx264 -preset slower -crf 23 -pix_fmt yuvj420p -c:a libmp3lame -b:a 128k "${dir}/compr/${out}"
  touch -r ${file} "${dir}/compr/${out}"
  CPU_temp>> log.txt
done
file="Program finished"
CPU_temp>> log.txt
cat log.txt

