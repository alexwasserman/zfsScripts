## zfsScripts ##
Misc ZFS maintenance scripts, written for my personal usage, currently on OpenZFS on OSX.

### automount ###
Run at login it checks to see if a ZFS pool is mounted and if not runs an import for it. Loops the check every 5 seconds. Checks if the O3X kext is loaded before importing.

    ./automount.sh ZFS

### poolStats ###
Prints out somewhat useful status on a given ZFS pool. Originally designed to be shown through geekTool, eg. http://www.macosxtips.co.uk/geeklets/system/basic-zfs-status/

    ./poolStats.sh ZFS

### scrub ###
Starts a scrub of a given ZFS pool. Designed to be run through launchd, and scheduled automatically.

    ./scrub.sh ZFS

### snapshotCycle ###
Generates a snapshot on a given ZFS zvol and increments the counter on existing snapshots, to keep X number in rotation. Removes the oldest. Taken in the Pool and ZVol, and a basename to name the snaps. There are better systems for this if you need to be complex, but I wrote this a while back and it's worked for me.

    ./snapshotCycle.sh <DAYS> <POOLNAME> <FILESYSTEM> <SNAPSHOT BASE NAME>

    ./snapshotCycle.sh 14 ZFS_POOL Users snap


### update ###
Runs a source update on an OpenZFS on OSX pool. Completely removed an existing installation, then builds and installs from scratch. Displays steps, but keeps all output in a log. Based on the steps from the O3X wiki here: https://openzfsonosx.org/wiki/Install

    ./update.sh ZFS


### zfsStatus ###
Shows ZFS status and volume stats - designed to be run through geekTool.

    ./zfsStatus

