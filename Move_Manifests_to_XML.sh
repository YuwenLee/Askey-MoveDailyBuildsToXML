#!/bin/bash

#
# File:    Move_Manifests_to_XML.sh
# Updated: 2021-04-09

MOUNT_POINT=/media/ywlee/MyBookDuo # Where the Backup DISK is mounted

#
# CDR7010
#
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR7010 # Where the Daily Build of CDR7010 is
LS_CMD="ls ${MANIFESTS_DIR} -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.]1[0-9][0-9][0-9]_" # The command used to list
KEEP_CNT=50 # The number of old Daily Builds to keep

for d in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
do
  if [ -e ${MANIFESTS_DIR}/$d ]
  then
    mv ${MANIFESTS_DIR}/$d ${MANIFESTS_DIR}/toXML
  fi
  
  if [ -e ${MANIFESTS_DIR}/$d.md5 ]
  then
    mv ${MANIFESTS_DIR}/$d.md5 ${MANIFESTS_DIR}/toXML
  fi
done
/mnt/FireCuda2T/ywlee_fit/ImageBackup/CDR7010_toXML.sh ${MOUNT_POINT} CDR7010 >> ~/log/toXML.log

#
# CDR7011
#
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR7011 # Where the Daily Build of CDR7010 is
LS_CMD="ls ${MANIFESTS_DIR} -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.][0-9][0-9][0-9]_" # The command used to list
KEEP_CNT=50 # The number of old Daily Builds to keep

for d in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
do
  if [ -e ${MANIFESTS_DIR}/$d ]
  then
    mv ${MANIFESTS_DIR}/$d ${MANIFESTS_DIR}/toXML
  fi

  if [ -e ${MANIFESTS_DIR}/$d.md5 ]
  then
    mv ${MANIFESTS_DIR}/$d.md5 ${MANIFESTS_DIR}/toXML
  fi
done
/mnt/FireCuda2T/ywlee_fit/ImageBackup/CDR7010_toXML.sh ${MOUNT_POINT} CDR7011 >> ~/log/toXML.log

#
# CDR9010-SKU3
#
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR9010-D307-SKU3 # Where the Daily Build is
LS_CMD="ls ${MANIFESTS_DIR} -lta | grep ^d | awk ' { print \$9 } ' | grep -e [.][0-9][0-9][0-9][0-9] -e 99" # The command used to list
KEEP_CNT=79 # The number of old Daily Builds to keep

for d in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
do
  if [ -e ${MANIFESTS_DIR}/$d ]
  then
    mv ${MANIFESTS_DIR}/$d ${MANIFESTS_DIR}/toXML
  fi

  if [ -e ${MANIFESTS_DIR}/$d.md5 ]
  then
    mv ${MANIFESTS_DIR}/$d.md5 ${MANIFESTS_DIR}/toXML
  fi
done
/mnt/FireCuda2T/ywlee_fit/ImageBackup/CDR9010_toXML.sh >> ~/log/toXML.log

#
# CDR9010-SKU4
#
MANIFESTS_DIR=${MOUNT_POINT}/DailyBuilds/Manifests/CDR9010-D307-SKU4 # Where the Daily Build of CDR7010 is
LS_CMD="ls ${MANIFESTS_DIR} -lta | grep ^d | grep CDR | awk ' { print \$9 } ' | grep -e [.][0-9][0-9][0-9][0-9]" # The command used to list
KEEP_CNT=59 # The number of old Daily Builds to keep

for d in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
do
  if [ -e ${MANIFESTS_DIR}/$d ]
  then
    mv ${MANIFESTS_DIR}/$d ${MANIFESTS_DIR}/toXML
  fi

  if [ -e ${MANIFESTS_DIR}/$d.md5 ]
  then
    mv ${MANIFESTS_DIR}/$d.md5 ${MANIFESTS_DIR}/toXML
  fi
done
/mnt/FireCuda2T/ywlee_fit/ImageBackup/CDR9010_toXML.sh >> ~/log/toXML.log
