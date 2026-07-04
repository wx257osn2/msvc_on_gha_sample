#!/bin/bash

set -euo pipefail

apt-get install -y --no-install-recommends wine wine64 winetricks msitools winbind

mkdir -p /opt/fontconf
cat << EOF > /opt/fontconf/dummy.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fontconfig.dtd">
<fontconfig>
  <dir>/usr/share/fonts</dir>
</fontconfig>
EOF

if [[ $(uname -m) == "aarch64" ]]; then
  add-apt-repository ppa:fex-emu/fex
  apt-get update
  apt-get install -y --no-install-recommends fex-emu-wine
  path=$(dpkg -L fex-emu-wine | grep -m1 'libwow64fex\.dll$')
  cp $path /usr/lib/aarch64-linux-gnu/wine/aarch64-windows/xtajit.dll
fi
