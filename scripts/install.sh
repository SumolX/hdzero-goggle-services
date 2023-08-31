#!/bin/sh

rm -rf /mnt/app/services/bearssl && cp -a busybox /mnt/app/services/
rm -rf /mnt/app/services/busybox && cp -a busybox /mnt/app/services/
rm -rf /mnt/app/services/dosfstools && cp -a dosfstools /mnt/app/services/
rm -rf /mnt/app/services/dropbear && cp -a dropbear /mnt/app/services/
rm -rf /mnt/app/services/ffmpeg && cp -a ntpclient /mnt/app/services/
rm -rf /mnt/app/services/ntpclient && cp -a ntpclient /mnt/app/services/
rm -rf /mnt/app/services/tinycurl && cp -a scripts /mnt/app/services/
rm -rf /mnt/app/services/untrunc && cp -a scripts /mnt/app/services/
rm -rf /mnt/app/services/x264 && cp -a scripts /mnt/app/services/

rm -rf /mnt/app/services/scripts && cp -a scripts /mnt/app/services/

cp -a startup.sh /mnt/app/services/
