#!/bin/bash
set -e

WORK_DIR=$(dirname $0)
TARGET_DIR=$1
PASSWD=$2
SUDO=

if [ ! "${PASSWD}" = "" ]
then
  SUDO="echo '${PASSWD}' | sudo -S "
fi

echo ============
echo sudo=${SUDO}
for BUILD in $(ls ${TARGET_DIR} -l | grep ^d | awk ' { print $9 } ')
do
  echo === md5sumdir ${TARGET_DIR}/${BUILD} ===
  ${WORK_DIR}/md5sumdir.sh ${TARGET_DIR}/${BUILD}
  bash -c "${SUDO} mv ${BUILD}.md5 ${TARGET_DIR}"
done
