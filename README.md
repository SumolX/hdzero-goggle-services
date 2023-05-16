# HDZGOGGLE Services
3rd Party Services for the HDZero Goggle

## Services
```
dropbear:  Network communications (SSH/SCP) via WiFi Module
ntpclient: Synchronize time with NTP Server via WiFi Module
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
copy ```pkg/hdzero-google-VERSION.tar``` to the root of your SD Card.

HDZ Goggles will automatically install package when detected (Minimum Google FW Version: TBD).
