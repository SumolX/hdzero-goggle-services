# HDZGOGGLE Services
3rd Party Services for the HDZero Goggle

## Services
```
bearssl:    v0.6 Implementation of the SSL/TLS protocol.
busybox:    v1.27.2 Software Suite Version
dosfstools: v4.2 Programs used to create, modify, and check the FAT filesystem.
dropbear:   Network communications (SSH/SCP) via WiFi Module
fbgrab:     v1.5 Linux framebuffer screenshot utility.
ffmpeg:     v5.0.1 Complete solution to record, convert and stream audio and video.
iperf:      v3.18 A TCP, UDP, and SCTP network bandwidth measurement tool.
libpng:     v1.6.47 Portable Network Graphics support, official libpng repository.
libx264:    VideoLAN x264, the best and fastest H.264 encoder.
libz:       v1.3.1 A general purpose data compression library.
ntpclient:  Synchronize time with NTP Server via WiFi Module
tinycurl:   v7.79.1 A low memory footprint of Curl designed for smaller systems.
untrunc:    MP4 Repair tool for corrupt video files.
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
If you enjoyed this work or would like to see additional features and functionality added in the future please feel free to donate or join my patreon.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=E4DSQMLR5JUXS)

[<img src="https://brandlogos.net/wp-content/uploads/2021/12/Patreon_logo_old-1536x352.png" width="88" height="20"/>](https://patreon.com/sumolx?utm_medium=unknown&utm_source=join_link&utm_campaign=creatorshare_creator&utm_content=copyLink)
