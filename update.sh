#!/bin/bash
set -o nounset
set -o errexit

## Variables
LOG="/tmp/zfs_update_$$.log"


## Functions
log() {  # classic logger 
	local prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
   	echo "${prefix} $@" | tee -a $LOG
} 

die() {
	log "ERROR" "Step failed: $1" 
	exit 1
}

## Prechecks

if [[ $# -ne 1 ]]; 
	then
		log "ERROR" "Usage: $(basename $0) POOLNAME"
		exit 1
	else
		POOL=$1
fi

## Lets go

log "INFO" "*******************"
log "INFO" "Starting ZFS Update"
log "INFO" "*******************"

log "INFO" "Logging command output to: $LOG"

log "INFO" "Exporting pool: ${POOL}"
sudo zpool export $POOL >> $LOG 2>&1 || true

# Check to make sure it exported
if [[ ! $(zpool status 2>&1 | grep -c "no pools available") == 1 ]]
	then
die "Pool export check"
fi

rm $HOME/zfsuninstaller*  >> $LOG 2>&1 || true

log "INFO" "Running complete removal scripts in case"
cd ~/Developer/bin
sudo ./uninstall-openzfsonosx.sh >> $LOG 2>&1  || true
sudo ./uninstall-complete.sh >> $LOG 2>&1 || true
log "INFO" "Complete removal done"

log "INFO" "Updating zfsadm script"
cd ~/Developer
[ -d zfsadm-repo/.git ] && (cd zfsadm-repo ; git pull >> $LOG 2>&1 )
[ ! -d zfsadm-repo/.git ] &&  git clone https://gist.github.com/7713854.git zfsadm-repo >> $LOG 2>&1
cp ~/Developer/zfsadm-repo/zfsadm ~/Developer/bin/

cd ~/Developer

log "INFO" "Cleaning SPL"
cd spl
make clean >> $LOG 2>&1|| true
cd ..
 
log "INFO" "Cleaning ZFS"
cd zfs
make clean >> $LOG 2>&1  || true
cd ..

log "INFO" "Building ZFS"
sudo zfsadm >> $LOG 2>&1 || die "Building ZFS"

log "INFO" "Uninstalling old ZFS kexts"
sudo zfsadm -u >> $LOG 2>&1  || die "Uninstalling old kext"

log "INFO" "Installing new SPL kext"
cd ~/Developer/spl
sudo make install >> $LOG 2>&1  || die "Installing new SPL kext"
cd ..

log "INFO" "Installing new ZFS kext"
cd ~/Developer/zfs
sudo make install >> $LOG 2>&1 || die "Installing new ZFS kext"

sudo kextstat | grep lundman | tee -a $LOG

sleep 4

# Check to make sure it imported automatically
if [[ ! $(sudo zpool status 2>&1 | grep -c 'state:') == "1" ]]
	then
	die "Pool import check"
	exit 1
fi

STATUS=$(zpool status | grep state | awk -F: '{ print $2}')

log "INFO" "zpool imported successfully"
log "INFO" "zpool status: $STATUS"

log "INFO" "*******************"
log "INFO" "Completed ZFS Update"
log "INFO" "*******************"

exit 0



