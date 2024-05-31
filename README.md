# OV9734 Driver and Device Tree Files

OV9734 camera sensor driver for Raspberry Pi. Modified original driver by Tianshu Qiu and Bingbu Cao to remove ACPI dependence and use of_table/dts approach. I had difficulty with the ACPI model and getting the sensor working for my embedded project and found this method to be more helpful for my application.

When used with libcamera it gives some warnings because I haven't created all the APIs it's looking for, but this driver gives you a bare bones working sensor interface.

This has been tested only with the Raspberry Pi 32bit and 64bit Bookworm Desktop OS and libcamera/rpicam-apps.

## Cross-Compiling Along with Kernel From Source -- /ksource

This driver and device tree description can be compiled with the Raspberry Pi Linux kernel source. See [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/computers/linux_kernel.html) for info on compiling the kernel from source.

- git clone --depth=1 https://github.com/raspberrypi/linux.git

This repo includes the necessary source and build configuration files in the `/ksource` directory. First clone the [linux kernel](https://github.com/raspberrypi/linux) (only tested with Bookworm OS). Check that the SRC and DEST directories are correct in `/ksource/kcpy.sh` and then run it to copy the changes. Compile the kernel and copy to SD card.

## Building Locally on RPi with DKMS and DTS

For the driver install DKMS and use in `/driver` directory:

- In `/driver` directory run `sudo cp -R . /usr/src/ov9734-[version]`

- `sudo dkms add -m ov9734 -v [version]`

- `sudo dkms build -m ov9734 -v [version]`

- `sudo dkms install -m ov9734 -v [version]`

Checkout `/driver/help.txt` for adding new versions or uninstalling the module.

For the dts overlay install and use DTC in `/overlay` directory:

Because the dts file includes a dtsi file, DTC won't know how to handle this. To resolve it use the cpp preprocessor. Run:

- `IDE=ov9734`
- `SRC=$IDE-overlay.dts`
- `TMP=$IDE-overlay.tmp.dts`
- `DST=$IDE.dtbo`

- `cpp -nostdinc -I include -undef -x assembler-with-cpp $SRC > $TMP`
- `dtc -O dtb -b 0 -o $DST $TMP`
- `rm $TMP`

Copy the dtbo file to /boot/firmware/overlays/ and update /boot/config.txt by commenting out camera auto detect feature and setting dtoverlay=ov9734

