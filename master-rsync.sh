#!/usr/bin/env bash

# Grab the arguments
TYPE=$1
SOURCE=$2
ACTION=$3
SIZE=$4
GO=$5

SCRIPTS=${0%/*}
DEST=`echo "_"${TYPE} | awk '{print toupper($0)}'`

# Report the args
clear
printf '$0 is: %s\n$BASH_SOURCE is: %s\n' "$0" "$BASH_SOURCE"
echo "---------------------------------------------------------------------------------"
echo "1) File TYPE is: ${TYPE}"
echo "2) Source directory is: ${SOURCE}"
echo "3) ACTION is: ${ACTION}"
echo "4) Minimum Size is: ${SIZE}"
echo "5) GO is: ${GO}"
echo "---------------------------------------------------------------------------------"
echo ""

INC="${SCRIPTS}/${TYPE}.txt"

# Test for a proper ACTION.
if [ "$ACTION" != "move" ]
then
  if [ "$ACTION" != "copy" ]
  then
    echo "You must specify five parameters, and the third ACTION parameter must be either 'copy' or 'move'."
    echo "This process is terminated."
    echo ""
    exit
  fi
fi

# Test for a proper GO spec.
if [ "$GO" != "GO!" ]
then
  echo "You must end your command with 'GO!' if you wish to commit all changes."
  echo "This process is a --dry-run and changes will NOT be committed!"
  echo ""
fi

if ! [ -f $INC ]
then
  echo "There is no list of file types at '$INC' corresponding to '$TYPE'."
  echo "Nothing to do here.  This process is terminated."
  echo ""
  exit
fi

# Set parameter based on ACTION.
if [ "$ACTION" = "move" ]; then PARM1="--remove-source-files"; fi
if [ "$ACTION" = "copy" ]; then PARM1=""; fi

# Set options based on DRYRUN.
if [ "$GO" = "GO!" ]; then OPTIONS="-aRruvi"; fi
if [ "$GO" != "GO!" ]; then OPTIONS="--dry-run -aRruvi"; fi

echo "This script will $ACTION the following file types (and their UPPERCASE equivalents) from "
echo "  $SOURCE to /mnt/fileserver/STORAGE/${DEST}:"
echo ""
cat $INC | (while read; do echo "    $REPLY"; done)
echo ""
echo "Original file paths will be preserved."
echo ""

rsync $OPTIONS --relative --progress --include='*/' --include-from=${INC} --exclude='*' --min-size=${SIZE} $PARM1 --prune-empty-dirs ${SOURCE} /mnt/fileserver/STORAGE/${DEST}/

echo ""
echo "Now for the UPPERCASE file types..."
echo ""

awk '{ print toupper($0) }' $INC > ${SCRIPTS}/uppercase.tmp
rsync $OPTIONS --progress --include='*/' --include-from=${SCRIPTS}/uppercase.tmp --exclude='*' --min-size=${SIZE} $PARM1 --prune-empty-dirs ${SOURCE} /mnt/fileserver/STORAGE/${DEST}/

exit 0
