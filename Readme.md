FPGA-SoC-Linux
====================================================================================

Overview
------------------------------------------------------------------------------------

## Introduction

This Repository provides a Linux Boot Image(U-boot, Kernel, Root-fs) for FPGA-SoC.

## Features

* Hardware
  + ZYBO : Xilinx Zynq-7000 ARM/FPGA SoC Trainer Board by Digilent
  + DE0-Nano-SoC : Altera SoC FPGA Development Kit by terasic
* U-Boot v2016.03 (customized)
  + Build for ZYBO and DE0-Nano-SoC
  + Customized boot by uEnv.txt
  + Customized boot by boot.scr
* Linux Kernel Version v4.4.7
  + Abailable in both Xilinx-Zynq-7000 and Altera-SoC in a single image
  + Enable Device Tree Overlay
  + Enable FPGA Manager
* Debian8(jessie) Root File System (not yet, comming soon)
  + Installed build-essential
  + Installed device-tree-compiler
  + Installed ruby ruby-msgpack ruby-serialport
  + Installed u-boot-tools
* FPGA Device Drivers  (not yet, comming soon)
  + dtbocfg (Device Tree Blob Overlay Configuration File System)
  + fpgacfg (FPGA Configuration Interface for Linux FPGA Manager Framework)
  + fclkcfg (FPGA Clock Configuration Device Driver)
  + udmabuf (User space mappable DMA Buffer)
  + zptty   (Pseudo TeleTYpewriter for FPGA Device)

Install
------------------------------------------------------------------------------------

## ZYBO

### File Description

 * tareget/zynq-zybo/
   + boot/
     - boot.bin                             : Stage 1 Boot Loader(U-boot-spl)
     - design_1_wrapper.bit                 : FPGA configuration file (Xilinx Bitstream Format)
     - u-boot.img                           : Stage 2 Boot Loader(U-boot)
     - uEnv.txt                             : U-Boot environment variables for linux boot
     - zImage-4.4.7-armv7-fpga              : Linux Kernel Image
     - zynq-zybo.dtb                        : Linux Device Tree Blob
     - zynq-zybo.dts                        : Linux Device Tree Source
 * debian8-rootfs-vanilla.tgz               : Debian8 Root File System(not yet, comming soon)
 * fpga-soc-linux-drivers_0.0.1-1_armhf.deb : Device Drivers Package  (not yet, comming soon)

### Format SD-Card

````
shell# fdisk /dev/sdc
   :
   :
   :
shell# mkfs-vfat /dev/sdc1
shell# mkfs.ext3 /dev/sdc2
````

### Write to SD-Card

````
shell# mount /dev/sdc1 /mnt/usb1
shell# mount /dev/sdc2 /mnt/usb2
shell# cp target/zynq-zybo/boot/*                  /mnt/usb1
shell# tar xfz debian8-rootfs-vanilla.tgz -C       /mnt/usb2
shell# cp fpga-soc-linux-drivers_0.0.1-1_armhf.deb /mnt/usb2/home/fpga
shell# umount mnt/usb1
shell# umount mnt/usb2
````

## DE0-Nano-SoC

### File Description

 * target/de0-nano-soc/
   + boot/
     - DE0_NANO_SOC.rbf                     : FPGA configuration file (Raw Binary Format)
     - socfpga.dtb                          : Linux Device Tree Blob
     - socfpga.dts                          : Linux Device Tree Source
     - uEnv.txt                             : U-Boot environment variables for linux boot
     - zImage-4.4.7-armv7-fpga              : Linux Kernel Image
   + u-boot/
     - u-boot-spl.sfp                       : Stage 1 Boot Loader(U-boot-spl)
     - u-boot.img                           : Stage 2 Boot Loader(U-boot)
 * debian8-rootfs-vanilla.tgz               : Debian8 Root File System(not yet, comming soon)
 * fpga-soc-linux-drivers_0.0.1-1_armhf.deb : Device Drivers Package  (not yet, comming soon)

### Format SD-Card

````
shell# fdisk /dev/sdc
   :
   :
   :
shell# mkfs-vfat /dev/sdc1
shell# mkfs.ext3 /dev/sdc2
````

### Write to SD-Card

````
shell# mount /dev/sdc1 /mnt/usb1
shell# mount /dev/sdc2 /mnt/usb2
shell# cp target/de0-nano-soc/boot/* /mnt/usb1
shell# dd if=target/de0-nano-soc/u-boot/u-boot-spl.sfp of=/dev/sdc3 bs=64k seek=0
shell# dd if=target/de0-nano-soc/u-boot/u-boot.img     of=/dev/sdc3 bs=64k seek=4
shell# tar xfz debian8-rootfs-vanilla.tgz -C       /mnt/usb2
shell# cp fpga-soc-linux-drivers_0.0.1-1_armhf.deb /mnt/usb2/home/fpga
shell# umount mnt/usb1
shell# umount mnt/usb2
````

## Install Device Drivers 

### Boot ZYBO or DE0-Nano-SoC and login fpga user

```
debian-fpga login: fpga
Password:
```

### Install Debian Package

```
fpga@debian-fpga:~$
fpga@debian-fpga:~$ sudo dpkg -i fpga-soc-linux-drivers_0.0.1-1_armhf.deb
Selecting previously unselected package fpga-soc-linux-drivers.
(Reading database ... 30688 files and directories currently installed.)
Preparing to unpack fpga-soc-linux-drivers_0.0.1-1_armhf.deb ...
Unpacking fpga-soc-linux-drivers (0.0.1-1) ...
Setting up fpga-soc-linux-drivers (0.0.1-1) ...
```

### Check Installed Package

```
fpga@debian-fpga:~$ ls -la /lib/modules/4.4.7-armv7-fpga/ikwzm/
total 684
drwxr-xr-x 2 root root   4096 Apr 25 23:14 .
drwxr-xr-x 4 root root   4096 Apr 25 23:14 ..
-rwxr-xr-x 1 root root  61468 Apr 25 21:15 dtbocfg.ko
-rwxr-xr-x 1 root root 105428 Apr 25 21:15 fclkcfg.ko
-rwxr-xr-x 1 root root 161736 Apr 25 21:15 fpgacfg.ko
-rwxr-xr-x 1 root root 168152 Apr 25 21:15 udmabuf.ko
-rwxr-xr-x 1 root root 160432 Apr 25 21:15 zptty.ko
fpga@debian-fpga:~$ sudo systemctl status device-tree-overlay.service
● device-tree-overlay.service - Device Tree Overlay Service.
   Loaded: loaded (/etc/systemd/system/device-tree-overlay.service; disabled)
   Active: inactive (dead)
fpga@debian-fpga:~$ sudo systemctl status fpga-managers.service
● fpga-managers.service
   Loaded: not-found (Reason: No such file or directory)
   Active: inactive (dead)
fpga@debian-fpga:~$ sudo systemctl status udmabuf.service
● udmabuf.service - User space mappable DMA Buffer Service.
   Loaded: loaded (/etc/systemd/system/udmabuf.service; disabled)
   Active: inactive (dead)
fpga@debian-fpga:~$ sudo systemctl status zptty.service
● zptty.service - Pseudo TTY Driver for communication with FPGA.
   Loaded: loaded (/etc/systemd/system/zptty.service; disabled)
   Active: inactive (dead)

```

### Enable Device Drivers at BOOT

```
fpga@debian-fpga:~$ sudo systemctl enable device-tree-overlay.service
Created symlink from /etc/systemd/system/multi-user.target.wants/device-tree-overlay.service to /etc/systemd/system/device-tree-overlay.service.
sudo systemctl enable fpga-manager.service
Created symlink from /etc/systemd/system/multi-user.target.wants/fpga-manager.service to /etc/systemd/system/fpga-manager.service.
fpga@debian-fpga:~$ sudo systemctl enable udmabuf.service
Created symlink from /etc/systemd/system/multi-user.target.wants/udmabuf.service to /etc/systemd/system/udmabuf.service.
fpga@debian-fpga:~$ sudo systemctl enable zptty.service
Created symlink from /etc/systemd/system/multi-user.target.wants/zptty.service to /etc/systemd/system/zptty.service.
```

### Reboot Linux

```
fpga@debian-fpga:~$ sudo reboot
```




Build 
------------------------------------------------------------------------------------

## Build U-boot for ZYBO

There are two ways

1. run scripts/build-u-boot-zynq-zybo.sh (easy)
2. run this chapter step-by-step (annoying)

### Download U-boot Source

#### Clone from git.denx.de/u-boot.git

```
shell$ git clone git://git.denx.de/u-boot.git u-boot-zynq-zybo
````

#### Checkout v2016.03

```
shell$ cd u-boot-zynq-zybo
shell$ git checkout -b u-boot-2016.03-zynq-zybo refs/tags/v2016.03
```

### Patch for zynq-zybo

```
shell$ patch -p0 < ../files/u-boot-2016.03-zynq-zybo.diff
shell$ git add --update
shell$ git commit -m "patch for zynq-zybo"
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

### Copy boot.bin and u-boot.img to zybo-zynq/boot/

```
shell$ cp spl/boot.bin  ../zynq-zybo/boot/
shell$ cp u-boot.img    ../zynq-zybo/boot/
```

## Build U-boot for DE0-Nano-SoC

There are two ways

1. run scripts/build-u-boot-de0-nano-soc.sh (easy)
2. run this chapter step-by-step (annoying)

### Download U-boot Source

#### Clone from git.denx.de/u-boot.git

```
shell$ git clone git://git.denx.de/u-boot.git u-boot-de0-nano-soc
````

#### Checkout v2016.03

```
shell$ cd u-boot-de0-nano-soc
shell$ git checkout -b u-boot-2016.03-de0-nano-soc refs/tags/v2016.03
```

### Patch for de0-nano-soc

```
shell$ patch -p0 < ../files/u-boot-2016.03-de0-nano-soc.diff
shell$ git add --update
shell$ git commit -m "patch for de0-nano-soc"
```

### Setup for Build 

```
shell$ cd u-boot-de0-nano-soc
shell$ export ARCH=arm
shell$ export CROSS_COMPILE=arm-linux-gnueabihf-
shell$ make socfpga_de0_nano_soc_defconfig
```

### Build u-boot

```
shell$ make
```

### Copy u-boot-spl.sfp and u-boot.img de0-nano-soc/u-boot/

```
shell$ cp spl/u-boot-spl.sfp ../de0-nano-soc/u-boot/u-boot-spl.sfp
shell$ cp u-boot.img         ../de0-nano-soc/u-boot/u-boot.img
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

#### Checkout v4.4.7

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
shell$ make deb-pkg
shell$ make zynq-zybo.dtb
shell$ make socfpga_cyclone5_de0_sockit.dtb
````

### Copy zImage and devicetree to target/zybo-zynq/boot/

```
shell$ cp arch/arm/boot/zImage            ../target/zynq-zybo/boot/zImage-4.4.7-armv7-fpga
shell$ cp arch/arm/boot/dts/zynq-zybo.dtb ../target/zynq-zybo/boot/zynq-zybo.dtb
```

### Copy zImage and devicetree to target/de0-nano-soc/boot/

```
shell$ cp arch/arm/boot/zImage                              ../target/de0-nano-soc/boot/zImage-4.4.7-armv7-fpga
shell$ cp arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dtb ../target/de0-nano-soc/boot/socfpga.dtb
```

## Build Debian8 RootFS

### Setup parameters 

```
shell$ apt-get install qemu-user-static debootstrap binfmt-support
shell$ export targetdir=debian8-rootfs
shell$ export distro=jessie
```

### Build the root file system in $targetdir(=debian8-rootfs)

```
shell$ mkdir $targetdir
shell$ sudo debootstrap --arch=armhf --foreign $distro                     $targetdir
shell$ sudo cp /usr/bin/qemu-arm-static                                    $targetdir/usr/bin
shell$ sudo cp /etc/resolv.conf                                            $targetdir/etc
shell$ sudo cp scripts/build-debian8-rootfs-with-qemu.sh                   $targetdir
shell$ sudo cp linux-image-4.4.7-armv7-fpga_4.4.7-armv7-fpga-1_armhf.deb   $targetdir
shell$ sudo cp linux-headers-4.4.7-armv7-fpga_4.4.7-armv7-fpga-1_armhf.deb $targetdir
````

### Build debian8-rootfs with QEMU

#### Change Root to debian8-rootfs

```
shell$ sudo chroot $targetdir
```

There are two ways

1. run build-debian8-rootfs-with-qemu.sh (easy)
2. run this chapter step-by-step (annoying)

#### Setup APT

````
debian8-rootfs# distro=jessie
debian8-rootfs# export LANG=C
debian8-rootfs# /debootstrap/debootstrap --second-stage
````

```
debian8-rootfs# cat <<EOT > /etc/apt/sources.list
deb     http://ftp.jp.debian.org/debian            jessie         main contrib non-free
deb-src http://ftp.jp.debian.org/debian            jessie         main contrib non-free
deb     http://ftp.jp.debian.org/debian            jessie-updates main contrib non-free
deb-src http://ftp.jp.debian.org/debian            jessie-updates main contrib non-free
deb     http://security.debian.org/debian-security jessie/updates main contrib non-free
deb-src http://security.debian.org/debian-security jessie/updates main contrib non-free
EOT
```

```
debian8-rootfs# cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests   "0";
EOT
```

```
debian8-rootfs# apt-get update
```

#### Install applications

```
debian8-rootfs# apt-get install -y locales dialog
debian8-rootfs# dpkg-reconfigure locales
debian8-rootfs# apt-get install -y openssh-server ntpdate resolvconf sudo less hwinfo ntp tcsh zsh
```

#### Setup hostname

```
debian8-rootfs# echo debian-fpga > /etc/hostname
```

#### Setup root password

```
debian8-rootfs# passwd
```

This time, we set the "admin" at the root' password.

To be able to login as root from Zynq serial port.

```
debian8-rootfs# cat <<EOT >> /etc/securetty
# Seral Port for Xilinx Zynq
ttyPS0
EOT
```

#### Add a new guest user

```
debian8-rootfs# adduser fpga
```

This time, we set the "fpga" at the fpga'password.

```
debian8-rootfs# echo "fpga ALL=(ALL:ALL) ALL" > /etc/sudoers.d/fpga
```

#### Setup sshd config

```
debian8-rootfs# sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
```

#### Setup fstab

```
debian8-rootfs# cat <<EOT > /etc/fstab
/dev/mmcblk0p1	/boot	auto		defaults	0	0
none		/config	configfs	defaults	0	0
EOT
````

#### Setup Network Interface

```
debian8-rootfs# cat <<EOT > /etc/network/interfaces.d/eth0
allow-hotplug eth0
iface eth0 inet dhcp
EOT
````

#### Install Development applications

```
debian8-rootfs# apt-get install -y build-essential
debian8-rootfs# apt-get install -y device-tree-compiler
debian8-rootfs# apt-get install -y u-boot-tools
debian8-rootfs# apt-get install -y ruby ruby-msgpack ruby-serialport
debian8-rootfs# gem install rake
```

#### Install Linux Header and Modules

```
debian8-rootfs# mv    boot boot.org
debian8-rootfs# mkdir boot
debian8-rootfs# dpkg -i linux-image-4.4.7-armv7-fpga_4.4.7-armv7-fpga-1_armhf.deb
debian8-rootfs# dpkg -i linux-headers-4.4.7-armv7-fpga_4.4.7-armv7-fpga-1_armhf.deb
debian8-rootfs# rm    boot/*
debian8-rootfs# rmdir boot
debian8-rootfs# mv    boot.org boot
```

#### Finish

```
debian8-rootfs# exit
shell$ sudo rm -f $targetdir/usr/bin/qemu-arm-static
shell$ sudo rm -f $targetdir/build-debian8-rootfs-with-qemu.sh
shell$ sudo rm -f $targetdir/linux-image-4.4.7-armv7-fpga_4.4.7-armv7-fpga-1_armhf.deb
shell$ sudo rm -f $targetdir/linux-headers-4.4.7-armv7-fpga_4.4.7-armv7-fpga-1_armhf.deb
```

### Build debian8-rootfs-vanilla.tgz

```
shell$ cd $targetdir
shell$ sudo tar cfz ../debian8-rootfs-vanilla.tgz *
```

## Build Device Drivers Package

### Donwload Sources from github

```
shell$ git clone https://github.com/ikwzm/dtbocfg
shell$ git clone https://github.com/ikwzm/fpgacfg
shell$ git clone https://github.com/ikwzm/fclkcfg
shell$ git clone https://github.com/ikwzm/udmabuf
shell$ git clone https://github.com/ikwzm/PTTY_AXI4
```

### Copy Source Files to drivers/

```
shell$ git archive --remote dtbocfg   --prefix=dtbocfg/  --format=tar v0.0.1 | tar xf - -C drivers
shell$ git archive --remote fpgacfg   --prefix=fpgacfg/  --format=tar v0.0.1 | tar xf - -C drivers
shell$ git archive --remote fclkcfg   --prefix=fclkcfg/  --format=tar v0.0.1 | tar xf - -C drivers
shell$ git archive --remote udmabuf   --prefix=udmabuf/  --format=tar v0.5.0 | tar xf - -C drivers
shell$ cd PTTY_AXI4; git checkout v1.0.0; cp -r src/drivers/zptty ../drivers; cd ..
```

### Build debian package

```
shell$ cd drivers
shell$ sudo debian/rule binary
```
