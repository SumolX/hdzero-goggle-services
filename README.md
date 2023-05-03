# HDZGOGGLE Services
3rd Party Services for the HDZero Goggle

## Services
Dropbear provides SSH/SCP access to the HDZero Goggles

## Building
```shell
./setup.sh
cd build
make -j
```

## Cleaning
```shell
cd build
make purgeall
```

## Deployment
copy ```pkg/hdzero-google-VERSION.tar``` to the root of your SD Card.

HDZ Goggles will automatically install package when detected.
