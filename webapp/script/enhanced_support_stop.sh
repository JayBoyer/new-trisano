#!/bin/bash

set -e

function kill_pids {
  if [ "$1" = "" ]
  then
    echo "No process found."
  else
    echo "pid $1"
    kill $PIDS
  fi
}

echo -n "Killing consoles: "
PIDS=`ps aux | grep -i "sh -c irb" | grep -v grep | awk '{print $2}'`
kill_pids $PIDS
PIDS=`ps aux | grep -i "irb" | grep -v grep | awk '{print $2}'`
kill_pids $PIDS 

echo -n "Killing web server on 8080: "
PIDS=`ps aux | grep -i "-e feature -p 8080 -P /trisano" | grep -v grep | awk '{print $2}'`
kill_pids $PIDS


