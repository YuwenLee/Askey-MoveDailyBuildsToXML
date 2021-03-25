#!/bin/bash

# 
# Download sub-dirs of the specified dir on the REMOTE_SERVER and save it to the 
# specified local dir.
#
# Updated: 2020-03-15
#

#REMOTE_SERVER=10.1.112.110
#REMOTE_PORT=22
#REMOTE_DIR=$1
#LOCAL_DIR=$2
#CHECKED_LIST=$3

function download()
{
  # Download REMOTE_DIR to LOCAL_DIR as bruceyw

  if [ ! -d ${LOCAL_DIR} ]
  then
    echo 
    echo $(date +%Y-%m-%d-%H:%M)
    echo === ERROR: Local dir =${LOCAL_DIR}= does not exist!
    exit 1
  fi
  pushd ${LOCAL_DIR} > /dev/null

  IMAGES=$(lftp -p ${REMOTE_PORT} -u bruceyw,12345678 sftp://${REMOTE_SERVER} << END_OF_CMD | grep ^d | awk ' { print $9 } ' | sed ' /^[.]/d ' 
cd ${REMOTE_DIR}
ls
END_OF_CMD
)

  for d in ${IMAGES}
  do

    lftp -p ${REMOTE_PORT} -u bruceyw,12345678 sftp://${REMOTE_SERVER} -e "ls $REMOTE_DIR/ ; exit " | grep $d.md5 &> /dev/null
    if [ $? -eq 0 ]
    then
      echo 
      echo $(date +%Y-%m-%d-%H:%M)
      echo === Download ${REMOTE_DIR}/$d from the remote
      lftp -p ${REMOTE_PORT} -u bruceyw,12345678 sftp://${REMOTE_SERVER} -e "cd $REMOTE_DIR ; mirror $d ; exit "
      if [ -f $d.md5 ]
      then
        rm $d.md5
      fi
      echo === Download ${REMOTE_DIR}/$d.md5 from the remote
      lftp -p ${REMOTE_PORT} -u bruceyw,12345678 sftp://${REMOTE_SERVER} -e "get $REMOTE_DIR/$d.md5 ; exit "
    fi
  done

  popd > /dev/null
}

function verify()
{
  # Verify the downloaded dirs
  
  for d in $(ls -l ${LOCAL_DIR} | grep ^d | awk ' { print $9 } ')
  do
    $(dirname $0)/md5sumdir.sh $LOCAL_DIR/$d
    diff $d.md5 $LOCAL_DIR/$d.md5 > /dev/null
    rm $d.md5
    if [ $? -eq 0 ] 
    then
      echo $(date +%Y-%m-%d-%H:%M) >> $CHECKED_LIST
      echo "$REMOTE_DIR/$d"        >> $CHECKED_LIST
      echo "$REMOTE_DIR/$d.md5"    >> $CHECKED_LIST
      echo "" >> $CHECKED_LIST

      if [ ! -e $LOCAL_DIR/../$d ]
      then
        mv $LOCAL_DIR/$d     $LOCAL_DIR/..
        mv $LOCAL_DIR/$d.md5 $LOCAL_DIR/..
      else
        sufix=$(date +%Y-%m%d-%H%M)
        mv $LOCAL_DIR/$d     $LOCAL_DIR/../$d-$sufix
        mv $LOCAL_DIR/$d.md5 $LOCAL_DIR/../$d-$sufix.md5 
      fi
      echo
      echo $(date +%Y-%m-%d-%H:%M)
      echo === $REMOTE_DIR/$d can be removed
    else
      if [ -f $LOCAL_DIR/$d.md5 ]
      then
        echo
        echo $(date +%Y-%m-%d-%H:%M)
        echo === ERROR: $LOCAL_DIR/$d data error!
      fi
    fi
  done
}

function upload_Result()
{
  # Upload the checked list to the REMOTE_SERVER

  if [ -e $CHECKED_LIST ]
  then
    lftp -p ${REMOTE_PORT} -u bruceyw,12345678 sftp://${REMOTE_SERVER} -e "put $CHECKED_LIST ; exit "
  fi
}

#
# Actions start here
#
REMOTE_SERVER=10.1.112.110
REMOTE_PORT=22
REMOTE_DIR=/home/jenkins/docker/var/lib/jenkins/CDR9010/share_folder/CDR9010-D307/toBeMoved
LOCAL_DIR=/media/ywlee/MyBookDuo/DailyBuilds/ROM_Code/CDR9010-D307-SKU3/toBeChecked
CHECKED_LIST=Checked-CDR9010-SKU3.txt

download
verify
upload_Result
