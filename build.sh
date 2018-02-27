#!/bin/bash

CMD=$1
DEVICE=$2
if [ -z "$DEVICE" ]; then
    DEVICE=p212-user-32
fi
cd /src && \
source build/envsetup.sh && \
lunch $DEVICE
if [ "$CMD" = "source" ]; then
    exec bash
fi

# uboot
cd uboot && ./mk gxl_p212_v1 && cd /src && \
cp -arf uboot/fip/u-boot.bin device/amlogic/p212/ && \
cp -arf uboot/fip/u-boot.bin.* device/amlogic/p212/upgrade/

if [ "$CMD" = "slow" ]; then
    MAKE_OPT=""
else
    MAKE_OPT="-j12"
fi
# ota
make otapackage $MAKE_OPT