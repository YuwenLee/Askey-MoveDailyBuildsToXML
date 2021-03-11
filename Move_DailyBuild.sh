#!/bin/bash

#
# CDR9011-SKU3
#
DB_PATH=/home/jenkins/docker/var/lib/jenkins/CDR9010/share_folder/CDR9010-D307

LS_CMD="ls -t ${DB_PATH} | grep -e [.][0-9][0-9][0-9][0-9]_"
KEEP_CNT=115

WORK_DIR=$(pwd)
echo
echo $(date +%Y-%m-%d-%H:%M)

if [ ! -d ${DB_PATH} ]
then
  echo = Work at ${WORK_DIR}
  echo = ERROR: 
  echo = ${DB_PATH} \<= does not exist!
  exit 1
fi
set -e

mkdir -p ${DB_PATH}/toBeMoved

for d in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
do
  echo $d
  echo 12345678 | sudo -S mv ${DB_PATH}/${d}  ${DB_PATH}/toBeMoved
done
${WORK_DIR}/md5sumdirs.sh ${DB_PATH}/toBeMoved
