# Artix Installer

Installs Artix linux using openrc from the openrc base ( or any openrc installer ) image. Not fully unattended yet, it's still a work in progress.

## Current Install Parameters

**WARNING** This installer will wipe the contents of the drive for the system it is used on!

- Assumes UEFI
- Sets up 8GiB Swap
- Configures for OpenRC
- Uses SDDM and Plasma 6 for desktop environment
- Utilizes flatpaks for most gui applications
- Utilize native steam package because flatpak is broken indefinitely
- Adds X11 session, but defaults to wayland
