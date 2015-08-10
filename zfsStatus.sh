#!/bin/bash
export PATH=$PATH:/usr/sbin/
date
echo ""
zpool status ZFS
echo ""
zfs list
