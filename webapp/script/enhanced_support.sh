#!/bin/sh

USE_DEBUGGER=$1

script/enhanced_support_stop.sh 

if [ "$USE_DEBUGGER" = "debug" ]
then
  echo "Loading web server on 8080 with debugger detached"
  bundle exec script/server -e feature -p 8080 -P /trisano --debugger > /dev/null &
elif [ "$USE_DEBUGGER" = "debugger" ]
then
  echo "Loading web server on 8080 with debugger"
  bundle exec script/server -e feature -p 8080 -P /trisano --debugger 
else
  echo "Loading web server on 8080 without debugger"
  bundle exec script/server -e feature -p 8080 -P /trisano > /dev/null &
fi
