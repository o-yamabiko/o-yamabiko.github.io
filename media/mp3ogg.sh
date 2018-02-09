#!/bin/sh
for i in "$1"/*.mp3
 do 
  inputfile=$i
  inputfilename=`basename $i mp3`
  ext='ogg'
  outputfilename=$inputfilename$ext

  echo 'CONVERTING TO OGG FORMAT' 
  ffmpeg -i $inputfile -c libvorbis $outputfilename

  echo 'DONE...!'
 done
