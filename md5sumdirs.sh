#!/bin/bash

WORK_DIR=$(dirname $0)
TARGET_DIR=$1

for BUILD in $(ls ${TARGET_DIR} -l | grep ^d | awk ' { print $9 } ')
do
  echo === md5sumdir ${TARGET_DIR}/${BUILD} ===
  ${WORK_DIR}/md5sumdir.sh ${TARGET_DIR}/${BUILD}
  rm ${BUILD}.md5
done
