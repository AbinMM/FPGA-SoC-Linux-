FPGA-SoC-Linux
==============

# Build 

## Build U-boot for ZYBO

### Download U-boot Source

#### Clone from git.denx.de/u-boot.git

```
shell$ git clone git://git.denx.de/u-boot.git u-boot-zynq-zybo
````

#### CHeckout v2016.03

```
shell$ cd u-boot-zynq-zybo
shell$ git checkout -b u-boot-2016.03-zynq-zybo refs/tags/v2016.03
```

### Patch for zynq-zybo

```
shell$ patch -p0 < ../files/u-boot-2016.03-zynq-zybo.diff
shell$ git add --update
shell$ git commit -m "patch for zynq-zybo"
shell$ git tag -a v2016.03-zynq-zybo -m "relase v2016.03-zynq-zybo"
```

### Setup for Build 

```
shell$ cd u-boot-zynq-zybo
shell$ export ARCH=arm
shell$ export CROSS_COMPILE=arm-linux-gnueabihf-
shell$ make zynq_zybo_defconfig
```

### Build u-boot

```
shell$ make
```

### Copy zImage and devicetree to zybo-zynq/boot/

```
shell$ cp spl/boot.bin  ../zynq-zybo/boot/
shell$ cp u-boot.img    ../zynq-zybo/boot/
```


## Build Linux Kernel

There are two ways

1. run scripts/build-linux-kernel.sh (easy)
2. run this chapter step-by-step (annoying)

### Download Linux Kernel Source

#### Clone from linux-stable.git

```
shell$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.7-armv7-fpga
```

#### CHeckout v4.4.7

```
shell$ cd linux-4.4.7-armv7-fpga
shell$ git checkout -b linux-4.4.7-armv7-fpga refs/tags/v4.4.7
```

### Patch for armv7-fpga

```
shell$ patch -p0 < ../files/linux-4.4.7-armv7-fpga.diff
shell$ git add --update
shell$ git add arch/arm/configs/armv7_fpga_defconfig
shell$ git commit -m "patch for armv7-fpga"
shell$ git tag -a v4.4.7-armv7-fpga -m "relase v4.4.7-armv7-fpga"
```

### Setup for Build 

````
shell$ cd linux-4.4.7-armv7-fpga
shell$ export ARCH=arm
shell$ export CROSS_COMPILE=arm-linux-gnueabihf-
shell$ make armv7_fpga_defconfig
````

### Build Linux Kernel and device tree

````
shell$ make zImage
shell$ zynq-zybo.dtb
shell$ make socfpga_cyclone5_de0_sockit.dtb
````

### Copy zImage and devicetree to zybo-zynq/boot/

```
shell$ cp arch/arm/boot/zImage            ../zynq-zybo/boot/4.4.7-zImage
shell$ cp arch/arm/boot/dts/zynq-zybo.dtb ../zynq-zybo/boot/4.4.7-devicetree.dtb
```

### Copy zImage and devicetree to de0-nano-soc/boot/

```
shell$ cp arch/arm/boot/zImage                              ../de0-nano-soc/boot/zImage
shell$ cp arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dtb ../de0-nano-soc/boot/socfpga.dtb
```

