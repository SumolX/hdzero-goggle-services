#!/bin/sh

ln -sfn /mnt/extsd/movies /mnt/app/services/webui/movies
httpd -v -h /mnt/app/services/webui > /tmp/webui.log 2>&1
