#!/bin/bash

#
# File:    Move_DailyBuild_to_Manifest.sh
# Updated: 2021-04-09

MOUNT_POINT=/media/ywlee/MyBookDuo # Where the Backup DISK is mounted

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

function mv_db_toManifests ()
{
  DAILY_BUILD_DIR=$1
  LS_CMD=$2
  KEEP_CNT=$3

  cd ${DAILY_BUILD_DIR}
  mkdir -p toManifests
  for BUILD in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
  do  
    if [ -d ${BUILD} ]
    then 
      mv ${BUILD} toManifests
    fi

    if [ -f ${BUILD}.md5 ]
    then
      mv ${BUILD}.md5 toManifests
    fi
  done
  cd - > /dev/null
}

#
# Actions start here
#

# CDR7010
DAILY_BUILD_DIR=${MOUNT_POINT}/DailyBuilds/ROM_Code/CDR7010/SHIP
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR7010
LS_CMD="ls -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.][0-9][0-9]*_"
KEEP_CNT=50
mv_db_toManifests ${DAILY_BUILD_DIR} "${LS_CMD}" ${KEEP_CNT}
~/ImageBackup/CDR7010_toManifests.sh ${DAILY_BUILD_DIR}/toManifests ${MANIFESTS_DIR} >> ~/log/toManifests.log

# CDR7011
DAILY_BUILD_DIR=${MOUNT_POINT}/DailyBuilds/ROM_Code/CDR7011/SHIP
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR7011
LS_CMD="ls -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.][0-9][0-9][0-9][0-9]*_"
KEEP_CNT=50
mv_db_toManifests ${DAILY_BUILD_DIR} "${LS_CMD}" ${KEEP_CNT}
~/ImageBackup/CDR7011_toManifests.sh ${DAILY_BUILD_DIR}/toManifests ${MANIFESTS_DIR} >> ~/log/toManifests.log

# CDR9010-SKU3
DAILY_BUILD_DIR=${MOUNT_POINT}/DailyBuilds/ROM_Code/CDR9010-D307-SKU3
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR9010-D307-SKU3
LS_CMD="ls -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.][0-9][0-9][0-9][0-9]*_"
KEEP_CNT=110
mv_db_toManifests ${DAILY_BUILD_DIR} "${LS_CMD}" ${KEEP_CNT}
~/ImageBackup/CDR9010-SKU3_toManifests.sh ${DAILY_BUILD_DIR}/toManifests ${MANIFESTS_DIR} >> ~/log/toManifests.log

# CDR9010-HTC
DAILY_BUILD_DIR=${MOUNT_POINT}/DailyBuilds/ROM_Code/CDR9010-D307-Hitachi/SHIP
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR9010-D307-Hitachi
LS_CMD="ls -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.][0-9][0-9][0-9][0-9]*_"
KEEP_CNT=53
mv_db_toManifests ${DAILY_BUILD_DIR} "${LS_CMD}" ${KEEP_CNT}
~/ImageBackup/CDR9010-HTC_toManifests.sh ${DAILY_BUILD_DIR}/toManifests ${MANIFESTS_DIR} >> ~/log/toManifests.log
