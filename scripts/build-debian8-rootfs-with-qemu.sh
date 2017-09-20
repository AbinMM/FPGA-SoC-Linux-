
#### Setup APT

distro=jessie
export LANG=C

/debootstrap/debootstrap --second-stage

cat <<EOT > /etc/apt/sources.list
deb     http://ftp.jp.debian.org/debian            jessie         main contrib non-free
deb-src http://ftp.jp.debian.org/debian            jessie         main contrib non-free
deb     http://ftp.jp.debian.org/debian            jessie-updates main contrib non-free
deb-src http://ftp.jp.debian.org/debian            jessie-updates main contrib non-free
deb     http://security.debian.org/debian-security jessie/updates main contrib non-free
deb-src http://security.debian.org/debian-security jessie/updates main contrib non-free
EOT

cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests   "0";
EOT

apt-get update  -y

#### Install Core applications

apt-get install -y locales dialog
dpkg-reconfigure locales
apt-get install -y openssh-server ntpdate resolvconf sudo less hwinfo ntp tcsh zsh

#### Setup hostname

echo "debian-fpga" > /etc/hostname

#### Set root password

echo Set root password
passwd

cat <<EOT >> /etc/securetty
# Seral Port for Xilinx Zynq
ttyPS0
EOT

#### Add fpga user

echo Add fpga user
adduser fpga
echo "fpga ALL=(ALL:ALL) ALL" > /etc/sudoers.d/fpga

#### Setup sshd config

sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config

#### Setup Time Zone

dpkg-reconfigure tzdata

#### Setup fstab

cat <<EOT > /etc/fstab
/dev/mmcblk0p1	/boot	auto		defaults	0	0
none		/config	configfs	defaults	0	0
EOT

#### Setup Network Interface

cat <<EOT > /etc/network/interfaces.d/eth0
allow-hotplug eth0
iface eth0 inet dhcp
EOT

#### Setup /lib/firmware

mkdir /lib/firmware

#### Install Development applications

apt-get install -y build-essential
apt-get install -y git
apt-get install -y u-boot-tools
apt-get install -y socat
apt-get install -y ruby ruby-msgpack ruby-serialport
gem install rake

apt-get install -y python  python-dev  python-pip
apt-get install -y python3 python3-dev python3-pip
pip3 install msgpack-rpc-python

#### Install Device Tree Compiler (supported symbol version)

apt-get install -y flex bison
cd root
mkdir src
cd src
git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git dtc
cd dtc
make
make HOME=/usr/local install-bin
cd /

#### Install Other applications

apt-get install -y samba 
apt-get install -y avahi-daemon

#### Install Linux Modules

mv    boot boot.org
mkdir boot
dpkg -i linux-image-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb
dpkg -i linux-headers-4.12.13-armv7-fpga_4.12.13-armv7-fpga-1_armhf.deb
rm    boot/*
rmdir boot
mv    boot.org boot
