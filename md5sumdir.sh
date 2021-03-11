#!/bin/bash

WORK_DIR=$(pwd)
MD5_FILE=$(pwd)/$(basename $1).md5

function md5sumdir ( )
{
  echo ===$(basename $1)==== >> $MD5_FILE

  cd $1
  for f in $(ls -la | grep ^- | awk ' { print $9 } ')
  do
    echo $f
    md5sum $f >> $MD5_FILE
  done

  for dir in $(ls -la | grep ^d | awk ' { print $9 } ' | sed '/^[.]/d')
  do
    md5sumdir $dir
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

md5sumdir $1
echo Result $1 $(md5sum $MD5_FILE | awk ' { print $1} ')

echo 12345678 | sudo -S cp $MD5_FILE $(dirname $1)
