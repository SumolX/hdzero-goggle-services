#!/bin/sh


ln -sfn /mnt/app/services/www/busybox /mnt/app/services/www/httpd
ln -sfn /mnt/extsd/movies /mnt/app/services/www/movies
httpd -v -h /mnt/app/services/www > /tmp/www.log 2>&1
