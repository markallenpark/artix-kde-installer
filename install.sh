#!/usr/bin/bash

###
# Prepares system for installation


# Install parted so we can easilly partition disks with script
echo "Getting necessary installation tools"
pacman -Sy
pacman -S parted

##
# Partition disks
#
# This is currently setup for a QEMU VM with UEFI ( to make sure UEFI works )
# you will need to adjust this section to match your devices configuration.
echo "Partitioning Disk"
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart ESP fat32 1MiB 1GiB
parted /dev/vda -- set 1 esp on
parted /dev/vda -- mkpart ROOT xfs 1GiB -8GiB
parted /dev/vda -- mkpart SWAP linux-swap -8GiB 100%

# Format partitions
echo "Formatting partitions"
mkfs.fat -F 32 -n ESP /dev/vda1
mkfs.xfs -L ROOT /dev/vda2
mkswap -L SWAP /dev/vda3

# Mount partitions
echo "Mounting partitions"
swapon /dev/disk/by-label/SWAP
mount /dev/disk/by-label/ROOT /mnt
mkdir -p /mnt/efi
mount /dev/disk/by-label/ESP /mnt/efi

# Install base system
echo "Preparing installation"
rc-service ntpd start
basestrap /mnt base openrc elogind-openrc linux linux-firmware amd-ucode bash-completion xfsprogs
fstabgen -L /mnt >> /mnt/etc/fstab

# Run installation scripts
mkdir /mnt/scripts
cp scripts/* /mnt/scripts/
chmod +x /mnt/scripts/*.sh
artix-chroot /mnt /scripts/install.sh

# Clean-up
rm -rf /mnt/scripts

echo "Installation complete! Rebooting system!"

reboot
