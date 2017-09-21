### Build Debian9 RootFS

#### Setup parameters 

```
shell$ apt-get install qemu-user-static debootstrap binfmt-support
shell$ export targetdir=debian9-rootfs
shell$ export distro=stretch
```

#### Build the root file system in $targetdir(=debian9-rootfs)

```
shell$ mkdir $targetdir
shell$ sudo debootstrap --arch=armhf --foreign $distro                         $targetdir
shell$ sudo cp /usr/bin/qemu-arm-static                                        $targetdir/usr/bin
shell$ sudo cp /etc/resolv.conf                                                $targetdir/etc
shell$ sudo cp scripts/build-debian9-rootfs-with-qemu.sh                       $targetdir
shell$ sudo cp linux-image-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb   $targetdir
shell$ sudo cp linux-headers-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb $targetdir
````

#### Build debian9-rootfs with QEMU

##### Change Root to debian9-rootfs

```
shell$ sudo chroot $targetdir
```

There are two ways

1. run build-debian9-rootfs-with-qemu.sh (easy)
2. run this chapter step-by-step (annoying)

##### Setup APT

````
debian9-rootfs# distro=stretch
debian9-rootfs# export LANG=C
debian9-rootfs# /debootstrap/debootstrap --second-stage
````

```
debian9-rootfs# cat <<EOT > /etc/apt/sources.list
deb     http://ftp.jp.debian.org/debian            stretch         main contrib non-free
deb-src http://ftp.jp.debian.org/debian            stretch         main contrib non-free
deb     http://ftp.jp.debian.org/debian            stretch-updates main contrib non-free
deb-src http://ftp.jp.debian.org/debian            stretch-updates main contrib non-free
deb     http://security.debian.org/debian-security stretch/updates main contrib non-free
deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free
EOT
```

```
debian9-rootfs# cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests   "0";
EOT
```

```
debian9-rootfs# apt-get update
```

##### Install applications

```
debian9-rootfs# apt-get install -y locales dialog
debian9-rootfs# dpkg-reconfigure locales
debian9-rootfs# apt-get install -y openssh-server ntpdate resolvconf sudo less hwinfo ntp tcsh zsh
debian9-rootfs# apt-get install -y avahi-daemon
```

##### Setup hostname

```
debian9-rootfs# echo debian-fpga > /etc/hostname
```

##### Setup root password

```
debian9-rootfs# passwd
```

This time, we set the "admin" at the root' password.

To be able to login as root from Zynq serial port.

```
debian9-rootfs# cat <<EOT >> /etc/securetty
# Seral Port for Xilinx Zynq
ttyPS0
EOT
```

##### Add a new guest user

```
debian9-rootfs# adduser fpga
```

This time, we set the "fpga" at the fpga'password.

```
debian9-rootfs# echo "fpga ALL=(ALL:ALL) ALL" > /etc/sudoers.d/fpga
```

##### Setup sshd config

```
debian9-rootfs# sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
```

##### Setup Time Zone

```
debian9-rootfs# dpkg-reconfigure tzdata
```

or if noninteractive set to Asia/Tokyo

```
debian9-rootfs# echo "Asia/Tokyo" > /etc/timezone
debian9-rootfs# dpkg-reconfigure -f noninteractive tzdata
```


##### Setup fstab

```
debian9-rootfs# cat <<EOT > /etc/fstab
/dev/mmcblk0p1	/boot	auto		defaults	0	0
none		/config	configfs	defaults	0	0
EOT
````

##### Setup Network Interface

```
debian9-rootfs# cat <<EOT > /etc/network/interfaces.d/eth0
allow-hotplug eth0
iface eth0 inet dhcp
EOT
````

##### Setup /lib/firmware

debian9-rootfs# mkdir /lib/firmware

##### Install Development applications

```
debian9-rootfs# apt-get install -y build-essential
debian9-rootfs# apt-get install -y git
debian9-rootfs# apt-get install -y u-boot-tools
debian9-rootfs# apt-get install -y socat
debian9-rootfs# apt-get install -y ruby ruby-msgpack ruby-serialport
debian9-rootfs# gem install rake
debian9-rootfs# apt-get install -y python  python-dev  python-pip
debian9-rootfs# apt-get install -y python3 python3-dev python3-pip
debian9-rootfs# pip3 install msgpack-rpc-python
```

##### Install Device Tree Compiler (supported symbol version)

```
debian9-rootfs# apt-get install -y flex bison
debian9-rootfs# cd root
debian9-rootfs# mkdir src
debian9-rootfs# cd src
debian9-rootfs# git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git dtc
debian9-rootfs# cd dtc
debian9-rootfs# make
debian9-rootfs# make HOME=/usr/local install-bin
debian9-rootfs# cd /
```

##### Install Other applications

```
debian9-rootfs# apt-get install -y samba
debian9-rootfs# apt-get install -y avahi-daemon
```

##### Install Linux Header and Modules

```
debian9-rootfs# mv    boot boot.org
debian9-rootfs# mkdir boot
debian9-rootfs# dpkg -i linux-image-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb
debian9-rootfs# dpkg -i linux-headers-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb
debian9-rootfs# rm    boot/*
debian9-rootfs# rmdir boot
debian9-rootfs# mv    boot.org boot
```

##### Clean Cache

debian9-rootfs# apt-get clean

##### Finish

```
debian9-rootfs# exit
shell$ sudo rm -f $targetdir/usr/bin/qemu-arm-static
shell$ sudo rm -f $targetdir/build-debian9-rootfs-with-qemu.sh
shell$ sudo rm -f $targetdir/linux-image-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb
shell$ sudo rm -f $targetdir/linux-headers-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb
```

#### Build debian9-rootfs-vanilla.tgz

```
shell$ cd $targetdir
shell$ sudo tar cfz ../debian9-rootfs-vanilla.tgz *
```

