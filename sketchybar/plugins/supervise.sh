#!/bin/bash
# supervise.sh NAME COMMAND...   Runs a command forever, restarting it when it exits (omniwmctl watch can crash).
NAME=$1; shift
echo $$ > "/tmp/supervise-$NAME.pid"
while true; do
  "$@" >>"/tmp/supervise-$NAME.log" 2>&1
  echo "$(date +%T) $NAME exited ($?), restarting" >> "/tmp/supervise-$NAME.log"
  sleep 1
done
