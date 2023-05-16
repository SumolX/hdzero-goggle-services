#!/bin/sh

ln -sfn /mnt/app/services/busybox/busybox /bin/udhcpc

/bin/udhcpc -n -p /run/udhcpc.eth0.pid -i eth0 -x hostname:myhostname > /tmp/uhdcpc.log 2>&1
