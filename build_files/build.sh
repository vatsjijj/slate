#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# check flatpak mirrors
if flatpak remotes | grep -q '^fedora\b'; then
	flatpak remote-delete --assumeyes fedora
fi

if ! flatpak remotes | grep -q '^flathub\b'; then
	flatpak remote-add --assumeyes flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# install from packages
dnf5 -y install $(jq -r '.base_ws | join(" ")' /ctx/packages.json)

# remove from packages
dnf5 -y remove $(jq -r '.excludes | join(" ")' /ctx/packages.json)

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
