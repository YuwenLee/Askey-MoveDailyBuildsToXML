#!/bin/bash

#
# Updated: 2021-04-09
#
FROM_DIR=$1 #${MOUNT_POINT}/DailyBuilds/ROM_Code/CDR9010-D307-SKU3/toManifests
DEST_DIR=$2 #${MOUNT_POINT}/DailyBuilds/Manifests/CDR9010-D307-SKU3

function print_example ()
{
  _SCRIPT_NAME=$1
  
  echo "Usage:"
  echo "  $_SCRIPT_NAME from_dir to_dir"
  echo "Example:"
  echo "  $_SCRIPT_NAME /media/bruceyw/MyBookDuo/DailyBuilds/ROM_Code/CDR7010/SHIP/toManifests /media/bruceyw/MyBookDuo/DailyBuilds/Manifests/CDR7010"
  echo 
}

function check_arg ()
{
  _SCRIPT_NAME=$1
  
  if [ "$FROM_DIR" = "" ]
  then
    print_example $_SCRIPT_NAME
    exit 1
  fi
  
  if [ "$DEST_DIR" = "" ]
  then
    print_example $_SCRIPT_NAME
    exit 2
  fi
}

function cp_to_dest ()
{
  _SRC=$1
  _DEST=$2
  
  _SRC_DIR=$(dirname $_SRC)
  _SRC_NAME=$(basename $_SRC)
  
  tar -C $_SRC_DIR -cf - $_SRC_NAME | tar -C $_DEST -pxf -
}

function rm_update ()
{
  #
  # Change dir to $1 and remove FOTA files and the working directories
  #
  
  _DIR=$1
  
  cd $_DIR
  
  # Remove Incremental OTA files
  for d in $(find ./ -type d -name OTA_Delta)
  do
    echo Remove $d
    rm -rf $d
  done

  # Remve Full OTA file
  for d in $(find ./ -type d -name OTA_Full)
  do
    echo Remove $d
    rm -rf $d
  done
    
  cd - > /dev/null
}

function rm_debug ()
{
  #
  # Change dir to $1 and remove debugging files
  #
  
  _DIR=$1
  
  cd $_DIR

  # Remove Debugging files
  for d in $(find ./ -type d -name DEBUG)
  do
    echo Remove $d
    rm -rf $d
  done
  
  for d in $(find ./ -type d -name disableSeLinux)
  do
    echo Remove $d
    rm -rf $d
  done

  for d in $(find ./ -type d -name enableDownLoadMode)
  do
    echo Remove $d
    rm -rf $d
  done

  cd - > /dev/null
}

#
# Action starts here
#
check_arg $0

for BUILD in $(ls -l $FROM_DIR | grep ^d | awk '{print $9}')
do
  cp_to_dest $FROM_DIR/$BUILD  $DEST_DIR
  if [ -e $FROM_DIR/$BUILD.md5 ]
  then
    cp $FROM_DIR/$BUILD.md5 $DEST_DIR
    diff $FROM_DIR/$BUILD.md5 $DEST_DIR/$BUILD.md5 > /dev/null
    if [ $? -eq 0 ]
    then
      echo $(date +%Y-%m-%d-%H:%M)
      echo == Move $BUILD.md5
      echo == From $FROM_DIR to $DEST_DIR
      rm $FROM_DIR/$BUILD.md5
    else
      echo $(date +%Y-%m-%d-%H:%M)
      echo == ERROR: Failed to move file
      echo == $FROM_DIR/$BUILD.md5
      rm $DEST_DIR/$BUILD.md5
    fi
  fi
  
  diff -r $FROM_DIR/$BUILD $DEST_DIR/$BUILD > /dev/null
  if [ $? -eq 0 ]
  then
    rm -rf $FROM_DIR/$BUILD
    echo $(date +%Y-%m-%d-%H:%M)
    echo == Move $BUILD
    echo == From $FROM_DIR to $DEST_DIR
    rm_update $DEST_DIR/$BUILD
    rm_debug  $DEST_DIR/$BUILD
    echo
  else
    echo $(date +%Y-%m-%d-%H:%M)
    echo == ERROR: Failed to move dir
    echo == $FROM_DIR/$BUILD
    rm -rf $DEST_DIR/$BUILD
    echo
  fi
done
