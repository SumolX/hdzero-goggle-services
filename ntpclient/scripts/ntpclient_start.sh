#!/bin/sh

ln -sfn /mnt/app/services/ntpclient/ntpclient /bin/ntpc

# Generate configuration once if it does not exist.
if [ ! -e /etc/ntpclient/ntpc.conf ]; then
    mkdir -p /etc/ntpclient
    echo "pool.ntp.org 0 0" > /etc/ntpclient/ntpc.conf
fi

ntpc -l -s 1 > /tmp/ntpc.log 2>&1
