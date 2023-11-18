#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo 'Installing required build deps'
rpm-ostree install just rustc lld libglvnd-devel wayland-devel libseat-devel libxkbcommon-devel libinput-devel gtk4-devel udev dbus dbus-devel
# optional dependencies
echo 'Installing optional build deps'
rpm-ostree install systemd-devel pulseaudio-libs-devel expat-devel fontconfig-devel freetype-devel lld cargo libgbm-devel clang-devel pipewire-devel

echo 'Cloning cosmic-epoch'
git clone --recurse-submodules https://github.com/pop-os/cosmic-epoch
cd cosmic-epoch

echo 'Building'
export CARGO_HOME=/tmp/cargo
just sysext

echo 'Copying config files'
mkdir /etc/cosmic-comp
cp cosmic-comp/config.ron /etc/cosmic-comp

echo 'Copying sysext files'
cp ./cosmic-sysext/usr /usr
#cp ./cosmic-sysext /var/lib/extensions