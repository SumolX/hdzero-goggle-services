#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/app/services/ffmpeg/lib

ln -sfn /mnt/app/services/ffmpeg/ffmpeg /bin/ffmpeg
ln -sfn /mnt/app/services/ffmpeg/ffprobe /bin/ffprobe

