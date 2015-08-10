#!/bin/bash

if [[ -x /tmp/zfs.*.tmp ]]
	then
	rm /tmp/zfs.*.tmp
fi

zfs get all $(zpool status | head -1 | awk -F: '{ print $2}' | sed s/\ //) | awk '{ print $2}' > /tmp/zfs.AAA.tmp

for vol in $(zfs list | awk '{ print $1 }' | tail +2)
do
echo "$vol" > /tmp/zfs.$(echo $vol | sed 's/\//\@/').tmp
zfs get all $vol | tail +2 | awk '{ print " " $3 }' >> /tmp/zfs.$(echo $vol | sed 's/\//\@/').tmp
done

paste /tmp/zfs.*.tmp | column -t

if [[ -x /tmp/zfs.*.tmp ]]
	then
	rm /tmp/zfs.*.tmp
fi

exit
