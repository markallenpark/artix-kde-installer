#!/usr/bin/bash

###
# Prepare system for use

# Setup locale
echo "Configuring Locale"
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
LANG="en_US.UTF-8" locale | grep -v LC_ALL > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Configure pacman
echo "Configuring pacman"
mv /etc/pacman.conf /etc/pacman.conf.orig
cp /scripts/pacman.conf /etc/pacman.conf
pacman -Sy

# Install packages
echo "Installing packages"
pacman -Syu $(cat /scripts/packages.txt)

# Configuring services
rc-update add NetworkManager
rc-update add ntp-client
rc-update add sddm

# Install flatpak packages
/scripts/flatpak.sh

# install bootloader
grub-install --recheck /dev/vda
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

# configure root user
passwd root

# create management user
useradd -m -G wheel -s /usr/bin/sh mp
passwd mp
