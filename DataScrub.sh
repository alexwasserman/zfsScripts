#!/bin/sh

export LOG="/var/log/ZFS/DataScrub.log"

/Users/alex/Developer/Scripts/ZFS/zfsScripts/scrub.sh ZFS >> $LOG

exit 0
