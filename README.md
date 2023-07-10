# HDZGOGGLE Services
3rd Party Services for the HDZero Goggle

## Services
```
busybox:    Software Suite Version 1.27.2
dosfstools: V4.2 Programs used to create, modify, and check the FAT filesystem
dropbear:   Network communications (SSH/SCP) via WiFi Module
ntpclient:  Synchronize time with NTP Server via WiFi Module
webui:      Provides goggle access via a HTML interface
```

## Building
```shell
./setup.sh
cd build
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
