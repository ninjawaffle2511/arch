#!/bin/bash
echo "[#] Synchronizing Clock..."
timedatectl set-ntp true

echo "[#] Initializing fdisk..."
echo -n "Enter desired root size in GB: "
read rootsize
echo -n "Enter desired swap size in GB: "
read swapsize
echo -n "Use remaining disk space for home? (Y/n): "
read useremainder
useremainder=${useremainder,,}

if [ "$useremainder" == "y" ] || [ -z "$useremainder" ]
then
    (
    echo o;
    echo n;
    echo p;
    echo 1;
    echo ;
    echo +${rootsize}G;
    echo n;
    echo p;
    echo 2;
    echo ;
    echo +${swapsize}G;
    echo n;
    echo p;
    echo 3;
    echo ;
    echo ;
    echo w;) | sudo fdisk /dev/sda
elif [ "$useremainder" == "n" ]
then
    (
    echo o;
    echo n;
    echo p;
    echo 1;
    echo ;
    echo +${rootsize}G;
    echo n;
    echo p;
    echo 2;
    echo ;
    echo +${swapsize}G;
    echo n;
    echo p;
    echo 3;
    echo ;
    echo +${homesize}G;
    echo w;) | sudo fdisk /dev/sda
else
    echo "Invalid Input"
fi

echo "[#] Formatting Partitions..."
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2

echo "[#] Mounting Partitions..."
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home

echo "[#] Running pacstrap..."
pacstrap /mnt base linux linux-headers linux-firmware

echo "[#] chrooting into system..."
arch-chroot /mnt

echo "[#] Setting timezone to Brisbane, Australia..."
ln -sf /usr/share/zoneinfo/Australia/Brisbane /etc/localtime
hwclock --systohc

echo "[#] Please change the root password"
passwd

echo "[#] Installing networkmanager, microcode, and grub..."
pacman -S networkmanager intel-ucode grub

echo "[#] Configuring grub..."
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "[#] Finished. Reboot system without Arch installation media"
