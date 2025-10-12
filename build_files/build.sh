#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# install from packages
dnf5 -y install $(jq -r '.base | join(" ")' /ctx/packages.json)
dnf5 -y install $(jq -r '.desktop | join(" ")' /ctx/packages.json)

# remove from packages
dnf5 -y remove $(jq -r '.excludes | join(" ")' /ctx/packages.json)

# install yafti
pip install --prefix=/usr yafti

# make directories
mkdir -vp /usr/share/backgrounds/slate
mkdir -vp "/usr/share/glib-2.0/schemas"
mkdir -vp /usr/share/gnome-background-properties
mkdir -vp /etc/yafti
mkdir -vp /usr/lib/systemd/user

# copy files from ctx
cp -v /ctx/usr /usr
cp -v /ctx/etc /etc

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

systemctl --global enable yafti.service
systemctl enable podman.socket
systemctl enable gdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
