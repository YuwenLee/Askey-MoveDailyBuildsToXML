#!/bin/bash

# File:    CDR9010_toXML.sh
# Updated: 2021-03-09

MOUNT_POINT=/media/ywlee/MyBookDuo # Where the Backup DISK is mounted
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR9010-D307-SKU4/toXML # The path of the manifests dir
XML_DIR=${MOUNT_POINT}/DailyBuilds/xml/CDR9010-D307-SKU4 # The path of the xml dir

function clone_to_dest ()
{
  _SRC=$1
  _DEST=$2
  
  _SRC_DIR=$(dirname $_SRC)
  _SRC_NAME=$(basename $_SRC)
  
  tar -C $_SRC_DIR -cf - $_SRC_NAME | tar -C $_DEST -pxf -
  if [ ! $? -eq 0 ]
  then
    echo
    echo $(date +%Y-%m-%d-%H:%M)
    echo "ERROR: Failed to copy ${_SRC} to ${_DEST}"
  fi
}

function remove_files ()
{
  VER=$(basename $(pwd) | awk -F"_" '{ print $3 }' | sed 's/^V//g' | sed 's/\([0-9][0-9][0-9][0-9]\).*$/\1/g') > /dev/null
  FILES=$(find ./ -name "${VER}*Images.zip")
  FILES=$FILES" "$(find ./ -name "adb2b-target_files*${VER}.zip")  
  for f in $FILES
  do
    rm $f
    if [ ! $? -eq 0 ]
    then
      echo
      echo $(date +%Y-%m-%d-%H:%M)
      echo "ERROR: Failed to delete $f"
    fi
  done
}

#
# Actions start here
#

for BUILD in $(ls -la ${MANIFESTS_DIR} | grep ^d | grep CDR | awk ' { print $9 } ') 
do
  clone_to_dest ${MANIFESTS_DIR}/${BUILD} ${XML_DIR}
  if [ -e ${MANIFESTS_DIR}/${BUILD}.md5 ]
  then
    clone_to_dest ${MANIFESTS_DIR}/${BUILD}.md5 ${XML_DIR}
  fi
  
  cd ${XML_DIR}/${BUILD}
  remove_files
  cd - > /dev/null
  echo
  echo $(date +%Y-%m-%d-%H:%M)
  echo == Remove ${MANIFESTS_DIR}/${BUILD}
  rm -rf ${MANIFESTS_DIR}/${BUILD}
  rm -f ${MANIFESTS_DIR}/${BUILD}.md5
done
