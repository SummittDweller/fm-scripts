#!/usr/bin/env bash

clear

SOURCE=$1
ACTION=$2
SCRIPTS="$HOME/bin"

echo "This is ${SCRIPTS}/rsync-all.sh."
echo "---------------------------------------------------------------------------------"
echo "Source directory is: ${SOURCE}"
echo "Action is: ${ACTION}"
echo "---------------------------------------------------------------------------------"
echo ""

## Declare an array variable of known types
declare -a types=( "archives" "audio" "binaries" "code" "data" "documents" "images" "videos" )

## Now loop through the above array
for i in "${types[@]}"
do
   master-rsync.sh $i $SOURCE $ACTION
done

exit

