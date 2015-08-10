#!/bin/bash

export POOL=$1

echo "Starting scrub of: " $POOL
echo "Time is: " `date`

/usr/sbin/zpool scrub $POOL

if [ $? -gt 0 ]; 
	then
		echo "Scrub failed to start"
	else
        	echo "Scrub started successfully" 
fi

echo "Completed: " `date`
