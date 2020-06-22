echo "[#] Setting timezone to Brisbane, Australia..."
ln -sf /usr/share/zoneinfo/Australia/Brisbane /etc/localtime
hwclock --systohc
cp /root/arch/locale.gen /etc/locale.gen
locale-gen
cp /root/arch/locale.conf /etc/locale.conf

echo "[#] Please change the root password"
passwd

echo "[#] Installing networkmanager, microcode, and grub..."
pacman -S networkmanager intel-ucode grub

echo "[#] Configuring grub..."
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "[#] Finished. Reboot system without Arch installation media"
