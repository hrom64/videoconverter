#!/bin/bash

CPU_temp()
{
echo $(date +%Y-%m-%dT%H:%M:%S) "||" "${file}" "||" "CPU temperature: $(sensors | grep 'Core 0'|awk '{print $1, $2, $3 }')" "||" "$(sensors | grep 'Core 1'|awk '{print $1, $2, $3 }')"
}

file="Program started"
dir=$(find ~/ -name "$1" -type d)
files=$(find ${dir} -name "$2" -type f)

if [ -f "log.txt" ]
then
   cat log.txt >> log.old 
fi

CPU_temp> log.txt

for file in ${files}
do
  mkdir -p $(dirname $file)/compr
  old=${file%.*}
  new=${old}-smaller.mp4
  out=$(basename $new)
  time ffmpeg -y -i "${file}" -r 25 -c:v libx264 -preset slower -crf 23 -pix_fmt yuvj420p -c:a libmp3lame -b:a 128k "$(dirname $file)/compr/${out}"
  touch -r ${file} "$(dirname $file)/compr/${out}"
  CPU_temp>> log.txt
done
file="Program finished"
CPU_temp>> log.txt
cat log.txt

