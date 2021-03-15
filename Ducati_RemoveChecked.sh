#!/bin/bash

# Updated: 2020-10-12

SCRIPT_DIR=$(dirname $0)
PASSWD=$2

echo ${PASSWD} | sudo -S pwd > /dev/null
echo
echo ================================
echo $(date +%Y-%m-%d-%H:%M)
echo Running $0 at $SCRIPT_DIR

function Remove_Checked()
{
  CHECKED=$1
  CHECKED_OLD=$(dirname ${CHECKED})/$(basename ${CHECKED%.*})-old.$(basename ${CHECKED##*.})
  if [ ! -f ${CHECKED} ]
  then
    return
  fi
  
  echo === Remove =${CHECKED} - ${CHECKED_OLD}=
  if [ ! -e ${CHECKED_OLD} ]
  then
    touch ${CHECKED_OLD}
  fi
  for f in $(diff ${CHECKED} ${CHECKED_OLD} | grep toBeMoved | grep ^\< | sed 's/<[ ]*//g')
  do
    echo Remove $f
    echo ${PASSWD} | sudo -S rm -rf $f
  done
  cp ${CHECKED} ${CHECKED_OLD}
}

Remove_Checked $1
