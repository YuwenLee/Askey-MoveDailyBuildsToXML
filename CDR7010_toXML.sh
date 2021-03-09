#!/bin/bash

# File:    CDR7010_toXML.sh
# Updated: 2021-03-09

MOUNT_POINT=$1 
PRODUCT=$2

MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/${PRODUCT}/toXML
XML_DIR=${MOUNT_POINT}/DailyBuilds/xml/${PRODUCT}

BUILD=

function print_example ()
{
  _SCRIPT_NAME=$1
  
  echo "Usage:"
  echo "  $_SCRIPT_NAME mount_point product build"
  echo "Example:"
  echo "  $_SCRIPT_NAME /media/ywlee/MyBookDuo CDR7010"
  echo 
}

function check_arg ()
{
  _SCRIPT_NAME=$1
  
  if [ "$MOUNT_POINT" = "" ]
  then
    print_example $_SCRIPT_NAME
    exit 1
  fi
  
  if [ "$PRODUCT" = "" ]
  then
    print_example $_SCRIPT_NAME
    exit 1
  fi
}

function clone_to_dest ()
{
  _SRC=$1
  _DEST=$2
  
  _SRC_DIR=$(dirname $_SRC)
  _SRC_NAME=$(basename $_SRC)
  
  tar -C $_SRC_DIR -cf - $_SRC_NAME | tar -C $_DEST -pxf -
  if [ ! $? -eq 0 ]
  then
    echo "ERROR: Failed to copy ${_SRC} to ${_DEST}"
  fi
}

function remove_files ()
{
  rm ${BUILD}.zip
  rm msm8953_64-new_target_files-ship.jenkins.*.zip
  rm msm8953_64-ota-ship.jenkins.*.zip
}

#
# Action starts here
#
echo
echo $(date +%Y-%m-%d-%H:%M)

check_arg $0
if [ ! -e ${MANIFESTS_DIR} ]
then
  echo Error: ${MANIFESTS_DIR} does not exist.
  exit 1
fi

mkdir -p ${XML_DIR}
if [ ! -e ${XML_DIR} ]
then
  echo Error: ${XML_DIR} does not exist.
  exit 1
fi

for BUILD in $(ls -l ${MANIFESTS_DIR} | grep ^d | grep CDR | awk ' { print $9 } ')
do
  clone_to_dest ${MANIFESTS_DIR}/${BUILD} ${XML_DIR}
  if [ -e ${MANIFESTS_DIR}/${BUILD}.md5 ]
  then
    clone_to_dest ${MANIFESTS_DIR}/${BUILD}.md5 ${XML_DIR}
  fi
  
  cd ${XML_DIR}/${BUILD}
  remove_files
  cd - > /dev/null
  echo == Remove ${MANIFESTS_DIR}/${BUILD}
  rm -rf ${MANIFESTS_DIR}/${BUILD}
  rm -f ${MANIFESTS_DIR}/${BUILD}.md5
done
