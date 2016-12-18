#!/usr/bin/env bash

# Grab the arguments
TYPE=$1
SOURCE=$2
ACTION=$3
SIZE=$4
GO=$5

# Get the real script folder.  Lifted from http://stackoverflow.com/a/12197518
pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
while([ -h "${SCRIPT_PATH}" ]); do
    cd "`dirname "${SCRIPT_PATH}"`"
    SCRIPT_PATH="$(readlink "`basename "${SCRIPT_PATH}"`")";
done
cd "`dirname "${SCRIPT_PATH}"`" > /dev/null
SCRIPTPATH="`pwd`";
popd  > /dev/null
# echo "script=${SCRIPT_PATH}"
# echo "pwd   =`pwd`"

DEST=`echo "_"${TYPE} | awk '{print toupper($0)}'`

# Report the args
clear
printf '$0 and $BASH_SOURCE are: %s  %s\n' "$0" "$BASH_SOURCE"
printf 'Working directory and $SCRIPTPATH are: %s  %s\n' "`pwd`" "$SCRIPTPATH"
echo "---------------------------------------------------------------------------------"
echo "1) File TYPE is: ${TYPE}"
echo "2) Source directory is: ${SOURCE}"
echo "3) ACTION is: ${ACTION}"
echo "4) Minimum Size is: ${SIZE}"
echo "5) GO is: ${GO}"
echo "---------------------------------------------------------------------------------"
echo ""

INC="${SCRIPTPATH}/${TYPE}.txt"

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

# Are we on the fileserver or is it mounted here?
if [ -d "/files/STORAGE" ]; then
  DROOT="/files/STORAGE"
elsif [ -d "/mnt/fileserver/STORAGE" ]; then
  DROOT="/mnt/fileserver/STORAGE"
else   
  echo "The fileserver destination root is undefined. This process is terminated."
  echo ""
  exit
fi

echo "This script will $ACTION the following file types (and their UPPERCASE equivalents) from "
echo "  $SOURCE to ${DROOT}/${DEST}:"
echo ""
cat $INC | (while read; do echo "    $REPLY"; done)
echo ""
echo "Original file paths will be preserved."
echo ""

rsync $OPTIONS --relative --progress --include='*/' --include-from=${INC} --exclude='*' --min-size=${SIZE} $PARM1 --prune-empty-dirs ${SOURCE} ${DROOT}/${DEST}/

echo ""
echo "Now for the UPPERCASE file types..."
echo ""

awk '{ print toupper($0) }' $INC > ${SCRIPTPATH}/uppercase.tmp
rsync $OPTIONS --progress --include='*/' --include-from=${SCRIPTPATH}/uppercase.tmp --exclude='*' --min-size=${SIZE} $PARM1 --prune-empty-dirs ${SOURCE} ${DROOT}/${DEST}/

exit 0
