#!/bin/bash
export PATH=$PATH:/usr/local/bin/
date
echo ""
zpool status ZFS
echo ""
zfs list
