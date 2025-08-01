#!/bin/bash
  echo "Start script"
if  [ $# -eq 0 ];then
echo "No args provided"
 else
   for i in "$@";do
  echo "Arg: $i"
   done
fi
   echo "End script"
