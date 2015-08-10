#!/bin/bash

export PATH=/usr/sbin:$PATH

export POOL=$1
export STATE="UNKNOWN"

test $# -ne 1 && echo "Usage: `basename $0` POOLNAME" && exit $E_BADARGS

if [[ `zpool list ZFS | grep -c ONLINE` = 1 ]]
	then
	echo "ZFS Pool $1 is mounted already"
	echo "Exiting"
	exit 1
fi

while [[ $STATE != "LOADED" ]]
	do
	if [[ `kextstat | grep -c lundman` -gt 2 ]]
		then
		echo "Running import"
		zpool import $POOL
		export STATE="LOADED"
		exit 0
	else
		sleep 5
		echo "Kext not found, sleeping 5"
	fi
done
