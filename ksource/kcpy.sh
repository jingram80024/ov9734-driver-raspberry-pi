#!/bin/bash

read -r -p "Are you sure you want to overwrite pi kernel source files? [y/N]" response
response=${response,,}
if ! [[ "$response" =~ ^(yes|y)$ ]]; then
	echo "Aborting"
	exit 1
fi

cd

SRC_DIR="linux-9734-patches/ksource"
DTS_DEST_DIR="linux/arch/arm/boot/dts/overlays"
DRIVER_DEST_DIR="linux/drivers/media/i2c"


cp $SRC_DIR/ov9734.c $DRIVER_DEST_DIR/ov9734.c
cp $SRC_DIR/Drivers_Kconfig $DRIVER_DEST_DIR/Kconfig
cp $SRC_DIR/Drivers_Makefile $DRIVER_DEST_DIR/Makefile

cp $SRC_DIR/ov9734.dtsi $DTS_DEST_DIR/ov9734.dtsi
cp $SRC_DIR/ov9734-overlay.dts $DTS_DEST_DIR/ov9734-overlay.dts
cp $SRC_DIR/overlays_Makefile $DTS_DEST_DIR/Makefile
cp $SRC_DIR/overlays_README $DTS_DEST_DIR/README

cp $SRC_DIR/stock.config linux/stock.config
cp $SRC_DIR/successful.config linux/successful.config

echo "Copied to pi kernel source"
