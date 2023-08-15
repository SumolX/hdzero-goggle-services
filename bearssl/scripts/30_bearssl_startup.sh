#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/app/services/bearssl/lib

ln -sfn /mnt/app/services/bearssl/bin/brssl /bin/brssl
