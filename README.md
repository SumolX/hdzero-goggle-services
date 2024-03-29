# HDZGOGGLE Services
3rd Party Services for the HDZero Goggle

## Services
```
bearssl:    v0.6 Implementation of the SSL/TLS protocol.
busybox:    v1.27.2 Software Suite Version
dosfstools: v4.2 Programs used to create, modify, and check the FAT filesystem.
dropbear:   Network communications (SSH/SCP) via WiFi Module
ffmpeg:     v5.0.1 Complete solution to record, convert and stream audio and video.
ntpclient:  Synchronize time with NTP Server via WiFi Module
tinycurl:   v7.79.1 A low memory footprint of Curl designed for smaller systems.
untrunc:    MP4 Repair tool for corrupt video files.
x264:       VideoLAN x264, the best and fastest H.264 encoder.
```

## Building Target: Goggle
```shell
./setup.sh
cd build
make -j
```

## Building Target: Host (Optional)
```shell
mkdir build-host
cd build-host
cmake ..
make -j
```

## Cleaning
```shell
cd build
make cleanall
```

## Deployment
copy ```~/hdzero-goggle-services/out/hdzero-google-VERSION.tar``` to the root of your SD Card.

HDZ Goggles Minimum Firmware: May 12, 2023 [PR 223](https://github.com/hd-zero/hdzero-goggle/pull/238).

# Donation
If you enjoyed this work or would like to see additional software ported please feel free to donate.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=E4DSQMLR5JUXS)
