# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx

COPY build_files /
COPY packages.json /
COPY backgrounds /usr/share/backgrounds/slate/
COPY gsettings /usr/share/glib-2.0/schemas/
COPY gnome-background-properties/slate-wallpapers.xml /usr/share/gnome-background-properties/
COPY etc/os-release /etc/os-release
COPY yafti/config.yml /etc/yafti/config.yml
COPY systemd/yafti.service /usr/lib/systemd/user/

# Base Image
FROM ghcr.io/ublue-os/base-main:42

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN glib-compile-schemas /usr/share/glib-2.0/schemas

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
