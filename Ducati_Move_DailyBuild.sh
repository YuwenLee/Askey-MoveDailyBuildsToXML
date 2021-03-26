#!/bin/bash

#
# CDR9011-SKU3
#
DB_PATH=/home/jenkins/docker/var/lib/jenkins/CDR9010/share_folder/CDR9010-D307

LS_CMD="ls -t ${DB_PATH} | grep -e [.][0-9][0-9][0-9][0-9]_"
KEEP_CNT=100

WORK_DIR=$(dirname $0)
echo
echo $(date +%Y-%m-%d-%H:%M)
echo = Work at ${WORK_DIR}

if [ ! -d ${DB_PATH} ]
then
  echo = ERROR: 
  echo = ${DB_PATH} \<= does not exist!
  exit 1
fi

echo 12345678 | sudo -S mkdir -p ${DB_PATH}/toBeMoved
for d in $(bash -c "diff <(${LS_CMD}) <(${LS_CMD} | head -${KEEP_CNT})" | grep ^"<" | sed 's/<//g')
do
  echo $d
  echo 12345678 | sudo -S mv ${DB_PATH}/${d}  ${DB_PATH}/toBeMoved
done
${WORK_DIR}/md5sumdirs.sh ${DB_PATH}/toBeMoved 12345678
