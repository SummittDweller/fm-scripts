#!/bin/bash

clear

SOURCE=""
SCRIPTS="$HOME/bin"
DEST="/Volumes/FILESERVER/"

echo "This is ${SCRIPTS}/backup.sh."
echo "---------------------------------------------------------------------------------"
echo "Source directory is: ${SOURCE}"
echo "---------------------------------------------------------------------------------"
echo ""

## Declare an array of subdirectories to copy from
declare -a dirs=( "_ARCHIVES" "_AUDIO" "_BINARIES" "_CODE" "_DATA" "_DOCUMENTS" "_IMAGES" "_VIDEOS" "_MISC" )

## Now loop through the above array
for i in "${dirs[@]}"
do
  echo "  Sub-directory is: ${SOURCE}$i.  Destination is ${DEST}$i."
  rsync -aruvi --progress ${SOURCE}$i ${DEST}
done


