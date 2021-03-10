#!/bin/bash

#
# Updated: 2020-12-21
#

FROM_DIR=/media/ywlee/MyBookDuo/DailyBuilds/ROM_Code/CDR7011/SHIP/toManifests
DEST_DIR=/media/ywlee/MyBookDuo/DailyBuilds/Manifests/CDR7011

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
  
  # Remove Incremental OTA files (update_xxxtoyyy_*.zip)
  for _f in $(ls -la | grep -E update_[0-9]+to[0-9]+.*[.]zip | sed 's/.*update/update/g')
  do
    echo Removed OTA file $_f
    rm $_f
  done

  # Remve Full OTA file
  if [ -f update.zip ]
  then
    echo Removed OTA file update.zip
    rm update.zip
  fi
  
  # Remove update_debug_on/off.zip
  #for _f in $(ls -la | grep -E update_debugboot_o.*[.]zip | sed 's/.*update/update/g')
  #do
  #  echo Removed OTA file $_f
  #  rm $_f
  #done
    
  # Remove upater* directories
  for _d in $(ls -l | grep ^d | awk '{print $9}')
  do
    echo Removed OTA workdir $_d
    rm -rf $_d
  done
  
  cd - > /dev/null
}

function rm_debug ()
{
  _DIR=$1
  
  cd $_DIR

  for _f in $(ls | grep backup.tar.gz)
  do
    echo Remove debug file $_f
    rm $_f
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
      echo == $BUILD.md5 had been moved from $FROM_DIR to $DEST_DIR
      rm $FROM_DIR/$BUILD.md5
    else
      echo $(date +%Y-%m-%d-%H:%M)
      echo == $FROM_DIR/$BUILD.md5 is not moved
      rm $DEST_DIR/$BUILD.md5
    fi
  fi
  
  diff -r $FROM_DIR/$BUILD $DEST_DIR/$BUILD > /dev/null
  if [ $? -eq 0 ]
  then
    rm -rf $FROM_DIR/$BUILD
    echo $(date +%Y-%m-%d-%H:%M)
    echo == $BUILD had been moved from $FROM_DIR to $DEST_DIR
    rm_update $DEST_DIR/$BUILD
    rm_debug  $DEST_DIR/$BUILD
    echo
  else
    echo $(date +%Y-%m-%d-%H:%M)
    echo == $FROM_DIR/$BUILD is not moved
    rm -rf $DEST_DIR/$BUILD
    echo
  fi
done
