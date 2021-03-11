#!/bin/bash
DIR=$1

WORK_DIR=$(pwd)
MD5_FILE=$(pwd)/$(basename ${DIR}).md5

function md5sumdir ( )
{
  cd $1
  
  if [ ! 0 -eq $(ls -p | grep -v / | wc -l) ]
  then
    echo ===${SUB_DIR}==== | sed 's/^===[/]/===/g' >> $MD5_FILE
  fi
  
  for f in $(ls -la | grep ^- | awk ' { print $9 } ')
  do
    echo $f
    md5sum $f >> $MD5_FILE
  done

  for dir in $(ls -la | grep ^d | awk ' { print $9 } ' | sed '/^[.]/d')
  do
    SUB_DIR=${SUB_DIR}/$dir
    md5sumdir $dir
    SUB_DIR=$(dirname "${SUB_DIR}" | sed 's/^[.]//g')
  done

  cd ..
}

echo "= Work at $WORK_DIR"
echo "= Scan    $1"
echo "= Output  $MD5_FILE"

if [ -f $MD5_FILE ]
then
  rm $MD5_FILE
fi

SUB_DIR=$(basename ${DIR})
md5sumdir ${DIR}
echo Result ${DIR} $(md5sum ${MD5_FILE} | awk ' { print $1 } ')
echo 12345678 | sudo -S cp ${MD5_FILE} $(dirname ${DIR})
