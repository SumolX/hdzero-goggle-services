#!/bin/sh

#remove old files
rm -rf /mnt/app/services/dropbear
rm -rf /mnt/app/services/ntpclient
rm -rf /mnt/app/services/scripts

#install new files
cp -a dropbear /mnt/app/services/
cp -a ntpclient /mnt/app/services/
cp -a scripts /mnt/app/services/
cp -a startup.sh /mnt/app/services/
