#!/bin/bash

PATH=$PATH:/usr/local/bin/:/usr/sbin/

usage() {
	echo "USAGE: ./snapshotCycle.sh <DAYS> <POOLNAME> <FILESYSTEM> <SNAPSHOT BASE NAME>"
	echo "DAYS must be a positive integer"
	echo "eg. ./snapshotCycle.sh 14 ZFS_POOL Users snap"
}

checkStatus() {
if [ $? -gt 0 ]; 
	then
	echo "An error occured in this step: $1"
	exit 125
fi
}

if [ $# -ne 4 ]
	then
	usage
    	exit 
fi

# Set variables to something so we don't accidentally erase a pool
export POOLNAME=FOO
export SNAPBASE=FOO
export FILESYSTEM=FOO

export DAYS=$1
export POOLNAME=$2
export FILESYSTEM=$3
export SNAPBASE=$4

export FSBASE=${POOLNAME}/${FILESYSTEM}@${SNAPBASE}_

echo ""
echo "Snapshot cycle script starting"
echo `date`
echo ""

echo " - Snapshot basename is " $FSBASE

if ! [[ "$DAYS" =~ ^[0-9]+$ ]] ; then
	usage
fi

echo " - Cycling ZFS snapshots"
echo " - Keeping $DAYS days of snapshots"

# Remove oldest
echo " - Removing oldest snapshot"
zfs destroy ${FSBASE}${DAYS}
checkStatus DestroyOldest
# echo " - Faking it: zfs destroy ${FSBASE}${DAYS}"

# Iterate and increment the rest
echo " - Incrementing previous days"
let COUNTDAY=${DAYS}-1
while [  "$COUNTDAY" -ge 0 ]; do
	let NEWDAY=COUNTDAY+1
	echo "   - Renaming $COUNTDAY"
	zfs rename ${FSBASE}${COUNTDAY} ${FSBASE}${NEWDAY}
	zfs get name,creation,used,referenced,compressratio ${FSBASE}${NEWDAY}
	checkStatus IncrementingExisting
        let COUNTDAY=COUNTDAY-1 
done

# Create new one
echo " - Creating today's snapshot"
zfs snapshot ${FSBASE}0
checkStatus TodaysSnapshot

echo ""
echo "Script complete"
echo `date`

exit 0


