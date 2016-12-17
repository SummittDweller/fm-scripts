#!/usr/bin/env bash

clear

SOURCE=$1
ACTION=$2
SCRIPTS="/Users/mark/bin"
GO=$3

echo "This is ${SCRIPTS}/rsync-all.sh."
echo "---------------------------------------------------------------------------------"
echo "Source directory is: ${SOURCE}"
echo "Action is: ${ACTION}"
echo "GO is: ${GO}"
echo "---------------------------------------------------------------------------------"
echo ""

## Declare an array variable of known types
declare -a types=( "archives" "audio" "binaries" "code" "data" "documents" "images" "videos" )

## Now loop through the above array
for i in "${types[@]}"
do
   master-rsync.sh $i $SOURCE $ACTION $GO
done

exit

